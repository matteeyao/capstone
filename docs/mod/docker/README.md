# [Full-stack Introduction using Rails, React, Docker and Heroku](https://rowant.co.uk/full-stack-introduction-using-rails-react-docker-and-heroku/)

In this example, we're going to write a very simple application that will scrape a JSON feed, save it into a database and then provide an API to access the new feed. To accompany that we will set up a React frontend instance. This will all be bundled into docker containers and hosted on Heroku.

## React

For this example, we're just going to create a blank React instance. Instructions can be found here. We're not going to add any code as this tutorial is going to mainly focus on the backend side. A future tutorial will go over some of the React features in more detail. So assuming we have set up our React app we can now run it using:

```zsh
yarn start
```

This will boot up our webserver and supply us w/ our React frontend on port 3000. Next is to set up the main part of our stack, which will be the rails backend.

## Ruby on Rails

To provide the API we are going to use Ruby on Rails. The data is going to be fetched from a WordPress feed on my website, and we are going to convert that into a more user-friendly version.

I won't include all the rails setup introductions as that can be found [here](https://guides.rubyonrails.org/getting_started.html). To start, we will set up a blank rails app w/ a PostgreSQL database w/ the API only option set to true.

```zsh
rails new RailsProject –api –database=postgresql
```

As we are only using the rails app to provide the API and not the frontend, by including `-api` this will tell rails not to add views for every controller that gets generated. The controllers also inherit from an `ActionController::API` base class instead of `ActionController::Base` so they will only have access to code that they need to know about. If you ever need to change the API value you can just navigate to `config/application.rb` and change the `config.api_only value`.

W/ the rails app setup, we can then create a controller that will serve up the JSON for the API. We can use the following terminal command to generate a controller.

```zsh
rails generate controller Posts index
```

This will generate a post controller w/ an action called index. It will also set up an entry in the `config/routes.rb`. The routes file lays out all the possible entry points for the API. In this file we can declare resources that act to certain CRUD (Create, Read, Update, Destroy) operations. Find more information on [CRUD and the 7 restful actions here](https://blog.usejournal.com/lets-build-taskbot-a-simple-crud-app-using-ruby-on-rails-part-1-a9710097c1c3). In this example, we are just going to have an API for returning all post entries. As a result, the routes file looks like this:

```rb
#config/routes.rb

Rails.application.routes.draw do
    
    namespace :api do
        namespace :v1 do
            resources :posts, only: [:index]
        end
    end

end
```

We start off by adding two namespace entries which provide the entry point for the API. By supplying a version it means any future changes can be deployed w/o bringing down the old API. Inside the `v1` namespace, we declare a resource called post which only conforms to the index restful action. Rails will then create the routes based on this configuration. All routes can be seen by using the routes command.

```zsh
rails routes
```

```zsh
Prefix 				api_v1_posts
Verb				GET    
URI Pattern 		/api/v1/posts(.:format)    
Controller#Action	api/v1/posts#index
```

As you can see one rout command is created, which will be used to supply all the posts through the API.

W/ the route now lined up, its time to add the code which will read the existing feed, and add the objects into the database.

First, we create the model, using a rails command:

```zsh
rails generate model Post title:string image:string content:text
```

This will create a new Post model w/ three properties for title, image, and content. Title and image are both declared as strings, whereas the content, which will be a large HTML string, is declared as text. The command also creates a class `db/migrate.rb` directory, which will create a posts table in the Postgres database when doing a migration. W/ the table now set up, the database can be created. To create the database run the following command:

```zsh
rails db:create
```

When you add new model objects or add new parameters to model objects a new migration file will be created. To apply the migration to the current database we run:

```zsh
rails db:migrate
```

W/ the rails app now setup we can run it using the following command. This will start the rails server on port 3001:

```zsh
rails s -p 3001
```

The bones of the application are now setup. We next need to create a task which will read the existing feed and populate the database w/ our new objects.

To create a standalone task we need to set up a rake task which can then be run on Heroku using the Heroku scheduler plugin. The plugin allows tasks to be run at any configured interval. All rake tasks need to be placed inside the `lib/tasks` folder. Below is the task which will read the existing feed and input objects into our database:

```rb
#lib/tasks/read_wordpress.rake

task :read_blog do
    require "net/http"

    file = Net::HTTP.get(URI.parse("https://rowant.co.uk/wp-json/wp/v2/posts"))
    json = JSON.parse(file)

    json.each do |post|
        po = Post.find_or_initialize_by(id: post["id"])
        po.title = post["title"]["rendered"]
        po.content = post["content"]["rendered"]
        po.image = post.dig("better_featured_image", "media_details", "sizes", "medium_large", "source_url")
        po.created_at = post["date"]
        po.save
    end
end
```

Creating a task is very straightforward. Just give it a name, which in our case is read blog and then the executing code goes in the block below.

In this example, we make a network request to the existing WordPress API, parse the response and then create model objects from the JSON. This is all then saved into our database.

`find_or_initialize_by` will make sure we don't duplicate any objects.

W/ the objects now stored into the database, we can now return them to the new API. To do that we need to update the Posts controller we generated earlier.

```rb
#controllers/api/v1/posts_controller.rb

module Api::V1
    class PostsController < ApplicationController
        def index
            render json: Post.all, status: :ok
        end
    end
end
```

Here we are rendering all the posts when the index function is called. As this linked up in our routes file, `/api/v1/posts` will now return all the posts.

That's our basic API set up. This can easily be run locally, but wouldn't it be nice if we could bundle this all together into its own docker container? Converting to a docker container also means we can make use of other docker features, such as docker-compose which allows multiple containers to be spun in one command.

## Docker

To convert to a docker container we first need to install Docker and follow the installation instructions. Once set up, creating the containers is fairly straightforward. All we need is a Dockerfile at the root of the directory.

A Dockerfile contains all the necessary information to create the docker container. As we are creating a full-stack application, we will need separate docker containers for our API, React frontend, and Postgres database. Docker already has a large list of open-source containers that will fit our needs for both Postgres and React. We will then need to create one custom container for our rails API. This is done w/ a Dockerfile which is placed at the root of the API directory:

```docker
FROM ruby:2.6.3
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs
RUN mkdir -p /app/backend
WORKDIR /app/backend
COPY Gemfile /app/backend/Gemfile
COPY Gemfile.lock /app/backend/Gemfile.lock
RUN bundle install
COPY . /app/backend

EXPOSE 3001

CMD rails s -p 3001 -b '0.0.0.0'
```

All the above code is doing is setting up our rails environment so it has exactly everything it needs to run. As we are working w/ multiple containers, we need to supply a directory for each container. Our rails container will be stored in the `app/backend` subdirectory. Once the directory is created, and all dependencies are installed, we have to expose the port the rails instance will be run on, and then run the command to start the rails server.

W/ the custom container now setup, we can start to tie all our containers together using `docker-compose`. Docker-compose allows for multiple containers to be set up in one command, which is great during development. To bind the containers together a `docker-compose.yml` file is needed at the root of the directory.

```docker
version: '3'
services:
  frontend:
    image: "node:10-alpine"
    working_dir: /myapp/frontend
    volumes:
      – ./frontend:/myapp/frontend
    ports:
      – "3000:3000"
    command: "yarn start"
    depends_on:
      – backend
  db:
    image: postgres
    volumes:
      – ./tmp/db:/var/lib/postgresql/data
  backend:
    build:
      context: ./backend
    volumes:
      – ./backend:/myapp/backend
    ports:
      – "3001:3001"
    depends_on:
      – db
```

We start off by declaring the docker-compose version, which at the time of writing is 3. We then move on to list all the services we want to use. In our case, this will be our frontend, backend, and database containers. As mentioned before, our frontend container will use an already existing image. [Docker hub](https://hub.docker.com/) is a marketplace to find any pre-built containers you may wish to use in your applications. In our case, we will use the **node:10-alpine** for our frontend container and **postgres** for our database container.

We can then set our **working directory**, which is needed as we have multiple containers in this one repo, so we need to specify what directory the container will run in. Much like we did in the Dockerfile for our custom rails container. Setting the **volumes** directory comes next, which Docker uses so that containers have access to other containers.

Containers that need to expose ports will need to add the respective ports as done above. Also, any containers that depend on other containers will need to declare that under **depends_on**. Finally, if we need to run any commands to start the containers then these need to be added to the **command** section. As our rails container uses a Dockerfile to do this, no command is needed.

There we have it. To recap the docker-compose file will create three containers. One for our react application, one for the rails backend, and one for our Postgres database.

Before we run the docker command to start the containers we need to make a quick update to our rails application so that the database uses our Postgres database supplied using Docker. This is done by updating the **config/database.yml**, and setting the host to the name our database which is **db**:

```yml
#config/database.yml

default: &default
…

  host: db 
```

Finally, our docker setup is complete. To start the containers we just run a single command in the root directory of our application:

```zsh
docker-compose up
```

Once everything starts up we will be able to access our rails and react apps on port 3000 and 30001 respectively.

To then run commands within our containers we just have to prefix it with the docker command. For example to set up the database within docker you would run:

```zsh
docker-compose run backend rails db:create
```

## Heroku

Now we have our containers up and running, the next step would be to deploy them to Heroku. Deploying containers works a little differently than the conventional way. Assuming Heroku is already installed, and an app has been created, we first need to add a `Heroku.yml` to our root directory.

This file is used by Heroku so it knows what docker container to run and allows any environment variables to be passed in. In this example, we will deploy our rails API container. Our `Heroku.yml` will look like this:

```yml
build:
    docker:
      web: backend/Dockerfile
    config:
      RAILS_ENV: production
```

Under **build**, we say that we want to deploy a Heroku web instance from a docker container. We then supply the path to the Dockerfile from our rails container. Under config, we need to supply an environment variable which tells the rails app to run in production mode. Before deploying, another quick update is needed to the **config/database.yml**. This time we need to change the database URL so that our rails app will read the Heroku Postgres instance. When we deploy, Heroku has its own Postgres container which we will use instead of our development container:

```yml
production:
  <<: *default
  …
  url: <%= ENV['DATABASE_URL'] %>
```

Before deploying we need to tell our Heroku app that it's a container. To do that just run the following command:

```zsh
heroku stack:set container
```

Now we are ready to deploy, which is done by running:

```zsh
git push heroku master
```

This will deploy our container to Heroku and start it up. If everything is set up correctly, the container should boot up and our production API should now be visible. Before we can use the API we will need to set up the database in Heroku. This is easily done with the following command:

```zsh
heroku run rails db:migrate
```

One final thing is we need to set up Heroku to run our rails task that converts the existing API into our new one. To run our rails task, we first to need to add a Heroku plugin. Heroku has plugins for many different scenarios and luckily for us, the Heroku Scheduler is just what we need. It allows for tasks to be run at configured intervals. We are going to set it up to run our read_wordpress task every day at 1:00 am.

![Heroku scheduler](https://rowant.co.uk/wp-content/uploads/2020/02/Screenshot-2020-02-09-at-13.40.25.png)

This will then populate our database so we have a working API.
