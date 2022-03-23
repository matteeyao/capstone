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
$ docker-compose run web bundle exec rails db:migrate:reset
```

### run rails console

```
$ docker-compose run web rails c
```

### generate migration

```
docker-compose run web bundle exec rails g migration <migrationName>
```

... and then run:

```
$ docker-compose run web bundle exec rails db:migrate:reset
```

Navigate to http://localhost:3000
