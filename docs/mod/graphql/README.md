# Using GraphQL w/ Ruby on Rails

**Objective**: Learn how to create a new project w/ Ruby on Rails and GraphQL while setting it up to use React and Apollo. The focus is on getting the API running and executing a query.

## Introduction

Ruby on Rails is an MVC (model, view, controller) framework that you can use to build web applications using the Ruby programming language. GraphQL is a declarative query language and server-side runtime that makes it easier for frontend developers to perform data fetching. Now, how can you use them together?

In this module, we're going to recap the basics of Ruby on Rails, GraphQL, and then demonstrate how to build and query a Rails-GraphQL API.

## Basics of Ruby on Rails

Since the release of Ruby on Rails (RoR or simply “Rails”) in 2004, there have been hundreds of thousands of web applications using the framework. You’ve probably been using a handful of applications that are built with Ruby on Rails: GitHub, Shopify, Airbnb, Twitch, Bloomberg, ConvertKit, and Soundcloud to name a few. It is open-source software that prides itself on following “The Rails Doctrine” or “The Rails Way” when programming. The most popular being: optimize for programmer happiness and convention over configuration. 

Rails is a framework written in Ruby with the goal to spend more time writing code and less time setting up config files. It unites Ruby with HTML, JavaScript, and CSS to create a web application that operates on a web server. Generally, it is a server-side web application. With its minimal syntax and many gems, it allows you to quickly create and share software projects. 

However, Rails is an opinionated framework. It assumes and guides you in the “best way” of doing something. If you follow the “Rails way” you might find your development time productivity-increasing if you can adapt to its ways. 

## Ruby on Rails architecture

Rails was built on the basic MVC architecture: modal, view, controller. 

* **Model**: ruby classes, business logic, talks w/ the database and validates the data

* **View**: templates that render data from the models, and handles the presentation to a user

* **Controller**: controls the flow of an application, handles requests, initiates changes in the model (Hint: this is where GraphQL things go!)

## Basics of GraphQL

GraphQL is known to be neither the frontend nor the backend but rather the language spoken between the two to exchange information. It's designed to make APIs fast, flexible, and developer-friendly. As an alternative to REST, GraphQL allows us to pull data from multiple data sources from only a single API call. Two ways of interaction w/ a database using GraphQL are w/ queries and mutations.

1. **Query**: this allows us to get data. It is the "read" in CRUD.

2. **Mutation**: this allows us to change information, including adding, updating, or removing data. It is where "create", "update", and "destroy" are in CRUD.

Since GraphQL is language-independent, we can use the Ruby gem "graphql" to create a project. This helps w/ a specific file structure and certain command-line tools to add GraphQL functionality in our Rails API.

## Building the API

Here's how we are going to do it:

1. **Set up a new Ruby on Rails project**

2. **Make some models**

3. **Add some pre-generated data**

4. **Create a GraphQL Rails endpoint**

5. **Write our first query**

### Set up a new rails project

For this project, let’s make a small Taylor Swift API or should we call it “TAY-PI” that has a few of her Red (Taylor’s Version) album songs. We will have an artist with items. We’ll dive more into that relationship on the Rails side in a bit. But first, let’s create the project.

If you don’t already have rails installed on your machine, let’s add that first by running the following command in your console. 

```zsh
gem install rails
```

Next we want to create a new rails project. Run the following command in your console and feel free to leave out any of the `--skip` flags, but none of them will be used for this project. Keep in mind testing is important! But we will not be going over it in this tutorial.

```zsh
rails new taypi -d postgresql --skip-action-mailbox --skip-action-text --skip-spring --webpack=react -T
```

Navigate or cd into your project repo and open the project in a code editor. Next, let's make some models. Remember, these are Ruby classes that talk w/ the database and validate the data. We will create models for `Artist` and `Item`. An artist (Taylor Swift) can have many items and represents the user who can manage the items. An item does not have more than one artist (for now) and it will describe an entity (the song).

To generate these two models, run the following 2 lines separately in your console.

```zsh
rails g model Artist first_name last_name email
```

```zsh
rails g model Item title description:text image_url artist:references
```

To add the relationship between the artist and the items, navigate to the **app/models/artist.rb** file and add `has_many :items, dependent: :destroy`

```rb
class Artist < ApplicationRecord
    has_many :items, dependent: :destroy
end
```
