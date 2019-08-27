# Usage

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

```shell
curl -X GET "http://localhost:3000/rake_task?task=db:reset"
```

```ruby
response = Rack::RakeTaskClient.new('http://localhost:3000').task('db:reset')

response['output']     # contents of STDOUT from rake task execution
response['error']      # contents of STDERR from rake task execution
response['exit_code']  # POSIX exit code from rake task execution
```

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

**REMEMBER:** During development always restart the rails app to make the changes made to the middleware effective.
