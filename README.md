# Capstone Project [![CircleCI](https://circleci.com/gh/matteeyao/capstone-backend/tree/main.svg?style=svg)](https://circleci.com/gh/matteeyao/capstone-backend/tree/main)

## Local Development

### set environment

1. Create your `app.env` file from the example file: `cp .env.app.testing app.env`
```
POSTGRES_HOST=db
PGUSER=postgres
PGPASSWORD=postgres
RAILS_ENV=development
```

2. Create your `db.env` file from the example file: `cp .env.db.testing db.env`
```
POSTGRES_USER=postgres
POSTGRES_PASSWORD=postgres
POSTGRES_DB=rails_ledger_dev
```

### Starting the application

```
$ docker-compose build
$ docker-compose up
$ docker-compose run web bundle exec rails db:migrate:reset
```

### run tests

```
$ docker-compose run web bundle exec rspec
```

### reset the database

```
$ docker-compose up db
$ docker-compose exec web bundle exec rails db:migrate:reset
```

**Delete and rebuild database**:

This will reset your database and reload your current schema w/ all:

```zsh
$ docker-compose exec web rake db:reset db:migrate
```

This will destroy your db, create it, and then migrate your current schema:

```zsh
$ docker-compose exec web rake db:drop db:create db:migrate
```

### run rails console

```
$ docker-compose run web rails c
```

### generate migration

```
$ docker-compose exec web bundle exec rails g migration <migrationName>
```

... and then run:

```
$ docker-compose exec web bundle exec rails db:migrate:reset
```

### rolling back all migrations

To rollback all migrations:

```zsh
$ docker-compose exec web rake db:migrate VERSION=0
```

Then, run all migrations again with:

```zsh
$ docker-compose exec web rake db:migrate
```

### retting the database

**Reset**

```zsh
$ docker-compose exec web rake db:migrate:reset #runs db:drop db:create db:migrate
```

This method drops the database and runs the migrations again.

**Loading the last schema**

```zsh
$ docker-compose exec web rake db:reset
```

### seed the database

```zsh
$ docker-compose exec web rake db:seed
```

This method will drop the database and load the data from the last schema.

Navigate to http://localhost:3080
