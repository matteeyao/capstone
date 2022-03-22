# [Learn TDD in Rails](https://learntdd.in/rails/#setup)

To see how TDD works in Rails, let's walk through a simple real-world example of building a feature. We'll be using Rails 6.0 along with RSpec and Capybara, two popular test libraries for Ruby. Each section of the article is linked to a corresponding commit in the [Git repo](https://github.com/learn-tdd-in/rails) (opens new window)that shows the process step-by-step.

## Setup

First, create the new Rails app:

```zsh
$ rails new --skip-test learn_tdd_in_rails
$ cd learn_tdd_in_rails
```

Next, we need to add some testing gems. Add the following to your `Gemfile`:

```diff
 group :development, :test do
   # Call 'byebug' anywhere in the code to stop execution and get a debugger console
   gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
+  gem 'rspec-rails'
 end
+
+group :test do
+  gem 'capybara'
+  gem 'selenium-webdriver'
+end

 group :development do
```

Install the gems:

```zsh
$ bundle install
```

Then set up RSpec:

```zsh
$ rails generate rspec:install
```

## The Feature Test

When performing outside-in TDD, our first step is to **create an end-to-end test describing the feature we want users to be able to do**. For our simple messaging app, the first feature we want is to be able to enter a message, send it, and see it in the list.

In Rails, end-to-end tests are referred to as system tests. Generate a new system test:

```zsh
$ rails g rspec:system creating_blog_posts
```

This will create a file `spec/system/creating_blog_posts_spec.rb`. Open it and make the following changes:

```diff
 require 'rails_helper'

 RSpec.describe "CreatingBlogPosts", type: :system do
   before do
     driven_by(:rack_test)
   end

-  pending "add some scenarios (or delete) #{__FILE__}"
+  it 'saves and displays the resulting blog post' do
+    visit '/blog_posts/new'
+
+    fill_in 'Title', with: 'Hello, World!'
+    fill_in 'Body', with: 'Hello, I say!'
+
+    click_on 'Create Blog Post'
+
+    expect(page).to have_content('Hello, World!')
+    expect(page).to have_content('Hello, I say!')
+
+    blog_post = BlogPost.order("id").last
+    expect(blog_post.title).to eq('Hello, World!')
+    expect(blog_post.body).to eq('Hello, I say!')
+  end
 end
```

The code describes the steps a user would take interacting with our app:

* Visiting the new blog post page

* Entering a tile and body into form fields

* Clicking a "Create Blog Post" button

* Confirming that the blog post appears on the screen

We also confirm that the blog post is saved into the database, to make sure we aren't just displaying the data on the screen but that we've also persisted it.

After we've created our test, the next step in TDD is to **run the test and watch it fail**. This test will (be "red") at first because we haven't yet implemented the functionality.

Run the test:

```zsh
$ rspec
```

You should see the following error:

```zsh
F

Failures:

  1) CreatingBlogPosts saves and displays the resulting blog post
     Failure/Error: visit '/blog_posts/new'

     ActionController::RoutingError:
       No route matches [GET] "/blog_posts/new"



     # ./spec/system/creating_blog_posts_spec.rb:9:in `block (2 levels) in <top (required)>'

Finished in 0.03064 seconds (files took 0.89609 seconds to load)
1 example, 1 failure

Failed examples:

rspec ./spec/system/creating_blog_posts_spec.rb:8 # CreatingBlogPosts saves and displays the resulting blog post
```

## Write the code you wish you had

The next step of TDD is to **write only enough production code to fix the current error or test failure**. In our case, all we need to do is add a route for `/blog_posts/new`.

A common principle in TDD is to **write the code you wish you had**. We could add a `get blog_posts/new` route to implement just this one route. But say we want to stick w/ Rails conventions and create a resourceful controller instead. In `config/routes.rb`, let's add a more standard `resources` instead:

```diff
 Rails.application.routes.draw do
   # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
+  resources :blog_posts
 end
```

Rails allows you to "unit test" routes, but for trivial configuration like this, it's fine to let the acceptance test cover it w/o stepping down to the unit level.

Rerun the test. Now we get a new error:

```zsh
1) CreatingBlogPosts saves and displays the resulting blog post
   Failure/Error: visit '/blog_posts/new'

   ActionController::RoutingError:
     uninitialized constant BlogPostsController
```

The error says the controller doesn't exit. To write only enough production code to fix this error, let's create an empty controller class. In `app/controllers/`, create a `blog_posts_controller.rb` file and add the following contents:

```rb
class BlogPostsController < ApplicationController
end
```

