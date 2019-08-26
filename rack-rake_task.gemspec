# frozen_string_literal: true

$LOAD_PATH.push File.expand_path('lib', __dir__)

Gem::Specification.new do |s|
  s.name        = 'rack-rails_task'
  s.version     = '0.0.1'
  s.author      = 'Bartek Wilczek'
  s.email       = 'bwilczek@gmail.com'
  s.homepage    = 'http://github.com/bwilczek/rack-rails_task'
  s.summary     = 'Rack middleware that runs rake tasks over HTTP'
  s.description = 'This gem provides a way to remotely run rake tasks'
  s.license      = 'MIT'

  s.files        = Dir['README.md', 'lib/**/*.rb']
  s.require_path = 'lib'

  s.add_development_dependency 'faraday'
  s.add_development_dependency 'pry'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'rubocop'
end
