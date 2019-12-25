# README

This README would normally document whatever steps are necessary to get the
application up and running.

This is the repository for the CoadingChallenge code base.

## System dependencies

* Ruby version: 2.5.1
* Node version: 10.15.3
* NPM version: 6.5.0
* Rails version: 5.2.4
* Sidekiq 

### Postgresql

Remember to set appropriate RAILS_ENV if running on different environment

      `bundle exec rake rake db:create RAILS_ENV=test`

      `bundle exec rake rake db:migrate RAILS_ENV=test`


### Frontend packages

Managed by Yarn and NPM

NPM dependencies are configured on `package.json`

## Testing

How to run the test suite

      `bundle exec rspec spec`

## Yarn

Run `yarn install` to install all packages
  
## Start frontend app

Run `yarn dev` 

## Start backend app

Run `bundle exec rails s` 
