source "https://rubygems.org"

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

ruby "~> 2.5.0"

gem "rails", "5.1.6.2"

# DB
gem 'pg', '~> 1.1', '>= 1.1.3'
gem "sequel", "~> 4.32"
gem "sequel-rails", "~> 0.9", ">= 0.9.12"

# Server
gem "puma", "~> 3.12"

# UI
gem "sass-rails", "5.0.6"
gem 'vuejs-rails'
gem "jquery-rails", "~> 4.3.1"
gem "coffee-rails", "~> 4.2.2"
gem "uglifier", "~> 2.7"
gem 'govuk_template', '>= 0.23.0'
gem 'govuk_elements_rails', '>= 3.1.3'
gem 'govuk_frontend_toolkit', :git => "https://github.com/alphagov/govuk_frontend_toolkit_gem.git", :submodules => true
gem 'bootstrap-sass', '>= 3.4.1'
gem "bootstrap-datepicker-rails", "~> 1.7.1.1"
gem 'momentjs-rails'
gem "pikaday-gem"
gem "selectize-rails"
gem "parsley-rails"
gem "font-awesome-rails"

# Single sign on
gem 'omniauth-oauth2'

# needed to mitigate against CVE-2015-9284
gem 'omniauth-rails_csrf_protection', '~> 0.1'

# File uploads and AWS
gem "shrine"
gem "aws-sdk-rails"
gem "aws-sdk-s3"
gem "rubyzip", "~> 1.2.2"

# Helpers
gem "hashie", "~> 3.4"
gem 'oj'
gem "multi_json", "~> 1.11"
gem "builder", "~> 3.2"
gem "ox", ">= 2.8.1"
gem "nokogiri", "~> 1.10.4"
gem 'holidays'
gem "govspeak", "~> 5.6.0"
gem "addressable", "~> 2.3"
gem 'slim-rails'
gem 'kaminari'
gem 'kaminari-sequel'
gem "simple_form", "~> 3.5"
gem "jbuilder"
gem "enumerize"

# Decorators & Exposing named methods
gem 'draper'
gem 'decent_exposure'
gem 'decent_decoration'

# API related
gem "curb", "~> 0.8"
gem "tilt"
gem "rabl", "~> 0.12"
gem "ansi", "~> 1.5"
gem "responders", "~> 2.1", ">= 2.1.0"

# Background jobs
gem "redis-rails"
gem "sidekiq", "~> 4.1.4"
gem "sidekiq-scheduler", "~> 2.1.8"

# System gems
gem "connection_pool", "~> 2.2"
gem "logstash-event"
gem "lograge", ">= 0.3.6"
gem "bootsnap", require: false

gem "ffi", "~> 1.9.24"

group :production do
  gem "sentry-raven"
  gem "rails_12factor"
end

group :development do
  gem "foreman"
  gem "letter_opener"
  gem "govuk-lint"
  gem "meta_request"
end

group :development, :test do
  gem 'byebug'
  gem "dotenv-rails"
  gem "factory_bot_rails", require: false
  gem "pry"
  gem "pry-rails"
end

group :test do
  gem "rspec-rails"
  gem "fakefs", require: "fakefs/safe"
  gem "forgery"
  gem "json_expressions"
  gem "simplecov"
  gem "webmock"
  gem "database_cleaner"
  gem 'codeclimate-test-reporter', require: nil
  gem "rspec_junit_formatter"
  gem 'capybara'
  gem 'selenium-webdriver'
  gem 'launchy'
  gem 'webdrivers'
  gem 'cucumber-rails', require: false
  gem 'site_prism'
  gem 'capybara-screenshot'
end
