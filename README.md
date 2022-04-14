# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

## Install

```sh
bundle install
```

## Ruby version
  '2.5.7'
## System dependencies
* postgresql

## Run
- `rails s` to start the rails server

## Database creation

  * Creating role with postgres
```sh
  sudo su - postgres
  psql
>  create ROLE hama;
  # alter role with login
>  ALTER ROLE "hama" WITH LOGIN;
  # alter rolle with creartdb
>  ALTER USER hama CREATEDB;
```
  Create the database
```sh
  rake db:create
```
  Run the migration files
```sh
  rake db:migrate
```

## User info
* set '"DEVISE_JWT_SECRET_KEY"' in your .bashrc

## Using rubocop
  * Finding indentation error run
```sh
  rubucop
```
  * For auto-correct run
```sh
  rubocop -A
```
  * Or
```sh
```
  * To stop test the specific type in Rubocop linter, you can add the test type name in './.rubocop.yml'
```sh
  ex: Style/Encoding:
        Enabled: false
```

* For running or not running a specific file add file name in AllCops, Exclude/Include in '.rubocop.yml'

## How to run the test suite
  # RSPEC Test:

  * For running all test:
```sh
  rspec
```
* For running specific test:
```sh
  rspec spec/your_test_path
```
