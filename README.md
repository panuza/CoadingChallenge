# README

This README would normally document whatever steps are necessary to get the
application up and running.

This is the repository for the CoadingChallenge code base.

## System dependencies

* Ruby version: 2.6.3
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
  
## Start backend app

Run `bundle exec rails s` to start rails app on your local.

## Start frontend app

Github link front end app on vue `https://github.com/panuza/frontend-code`

Run `yarn dev`  to start app locally.


## Project link on heroku

`https://secure-cove-66231.herokuapp.com`
