# WORK IN PROGRESS !!

```ruby
# Gemfile
group :development do
  gem 'rack-rails_task'
end

# rails: config/environments/development.rb
require 'rack/rake_task'
config.middleware.use Rack::RakeTask
```
Now `rake` tasks can be executed over HTTP:
http://localhost:3000/rake_task?task=db:reset

This is useful in a CI stack, for example: to reset the database between test scenarios.

# Testing

Before running `rspec`:

1. Start the `mysql` instance for the embedded test rails app:

```
docker run --rm --name bookstore-mysql -e MYSQL_ROOT_PASSWORD=root -e MYSQL_DATABASE=bookstore -e MYSQL_USER=bookstore -e MYSQL_PASSWORD=bookstore -p 3309:3306 mysql/mysql-server:5.6
```

2. Start the embedded test rails application:

```
cd spec/support/bookstore
bundle install
bundle exec rails s
```

**REMEMBER:** Always restart the rails app to make the changes made to the middleware effective.

# TODOs

* [ ] Return a JSON with error and output fields
* [ ] Refactor the middleware class
* [ ] Improve spec coverage
