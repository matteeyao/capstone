# [GraphQL the Rails way: Part 2 - Writing standard and custom mutations](https://www.keypup.io/blog/graphql-the-rails-way-part-2-writing-standard-and-custom-mutations)

In the last module we covered [how to dynamically define queryable resources](https://www.keypup.io/blog/graphql-the-rails-way-part-2-writing-standard-and-custom-mutations) using `graphql-ruby`, making it almost a one-liner to get fully functional API resources.

In this module we are going to talk about mutations and how to define them The Rails Way.

If you're familiar w/ REST, you know how CRUD operations are codified. One uses POST for create actions, PUT or PATCH for update actions and DELETE for destroy actions.

The HTTP verb mapping always makes developers wonder whether they should use POST, PUT or PATCH when actions fall outside of traditional CRUD operations. For example, let's consider a REST action which is "approve a transaction". Which verb should you use? Well it depends.

If you consider that the transaction is getting updated, you should use PUT or PATCH. Now if you consider that you create an approval, which in turns updates the transaction then you should use POST.

I dislike these dilemmas b/c each developer will have a different view on it. And as more developers work on your API well...inconsistencies will spawn across your REST actions.

W/ GraphQL there are no such questions. You keep hitting the /graphql endpoint w/ POST requests.

A mutation is simple: it's an operation which leads to a write, somewhere. It can be anything, such as:

* Create, update or delete a record

* Approve a transaction

* Rollback a record

* Bulk update a series of records

* Post an image on Imgur

So let's see how to define mutations w/ `graphql-ruby` and - more importantly - how to make them reusable.

In this episode I will be reusing the `Book(name, page_size, user_id)` and `User(name, email)` models we defined in the [previous module](https://www.keypup.io/blog/graphql-the-rails-way-part-1-exposing-your-resources-for-querying)

## Defining mutations

All mutations must be registered in the `Types::MutationType` file, the same way queryable resources must be declared in the `Types::QueryType` file.

Mutations can be declared in block form inside the `Types::MutationType` file but that's kind of messy. We'll use a proper mutation class to define our mutation.

First, let's register our mutation. The class doesn't exist yet but we'll get it soon.

```rb
# app/graphql/types/mutation_type.rb
# frozen_string_literal: true

module Types
  class MutationType < Types::BaseObject
    # Map the name of the mutation to the class handling the
    # actual mutation logic.
    field :update_book, mutation: Mutations::UpdateBook
  end
end
```

Nothing complicate here. It's fairly straightforward.

Now to write a mutation, we need to define four aspects:

1. The required (e.g. ID) and accepted arguments (e.g. update attributes)

2. The return field, similar to a queryable resource

3. The authorization logic - Is the user allowed to perform the action

4. The actual mutation logic and return value

That sounds quite reasonable, you would expect this sequence from any controller action. So let's see what the mutation looks like.

```rb
# app/graphql/mutations/update_book.rb
# frozen_string_literal: true

module Mutations
  # Update attributes on a book
  class UpdateBook < BaseMutation
    # Require an ID to be provided
    argument :id, ID, required: true

    # Allow the following fields to be updated. Each is optional.
    argument :pages, Integer, required: false
    argument :name, String, required: false

    # Return fields. A standard approach is to return the mutation
    # state (success & errors) as well as the updated object.
    field :success, Boolean, null: false
    field :errors, [String], null: false
    field :book, Types::BookType, null: true

    # Check if the user is authorized to perform the action
    #
    # Considering we just delegate to the parent method we could just
    # remove this method.
    #
    # In a real-world scenario you would invoke a policy to check if
    # the current user is allowed to update the book.
    def authorized?(**args)
      super

      # E.g. with Pundit
      # super &&
      #   BookPolicy.new(context[:current_user], Record.find_by(id: args[:id])).update?
    end

    # Mutation logic and return value. The model id is extracted
    # to find the book.
    #
    # The rest of the keyword arguments are directly
    # passed to the update method. Because GraphQL is strongly typed we
    # know the rest of the arguments are safe to pass directly to the
    # update method (= in the list of accepted arguments)
    def resolve(id:, **args)
      record = Book.find(id)

      if record.update(args)
        { success: true, book: record, errors: [] }
      else
        { success: false, book: nil, errors: record.errors.full_messages }
      end
    rescue ActiveRecord::RecordNotFound
      return { success: false, book: nil, errors: ['record-not-found'] }
    end
  end
end
```
