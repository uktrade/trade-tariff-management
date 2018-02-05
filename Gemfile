source "https://rubygems.org"

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

ruby "2.4.3"

gem "rails", "5.1.3"

# DB
gem "pg", "0.18.4"
gem "sequel", "~> 4.32"
gem "sequel-rails", "~> 0.9", ">= 0.9.12"

# Server
gem "puma", "~> 3.4"

# UI
gem "govuk_template", "0.20.0"
gem "coffee-rails", "~> 4.2.2", ">= 4.1.0"
gem "govuk_frontend_toolkit", "~> 4.18", ">= 4.18.4"
gem 'govuk_elements_rails', '~> 1.2', '>= 1.2.2'
gem "jquery-rails", "~> 4.2.2"
gem "sass-rails", "~> 5.0.6"
gem "uglifier", "~> 2.7"

# AWS
gem "aws-sdk", "~> 2"
gem "aws-sdk-rails", ">= 1.0.1"

# Helpers
gem "hashie", "~> 3.4"
gem "multi_json", "~> 1.11"
gem "yajl-ruby", "~> 1.3.1", require: "yajl"
gem "builder", "~> 3.2"
gem "ox", ">= 2.8.1"
gem "nokogiri", "~> 1.8.1"
gem 'holidays'
gem "govspeak", "~> 3.6", ">= 3.6.2"
gem "addressable", "~> 2.3"
gem 'slim-rails'

# API related
gem "tilt"
gem "rabl", "~> 0.12"
gem "ansi", "~> 1.5"
gem "responders", "~> 2.1", ">= 2.1.0"

# Background jobs
gem "sidekiq", "~> 4.1.4"
gem "sidekiq-scheduler", "~> 2.1.8"

gem "plek", "~> 1.11"
gem "gds-sso", "~> 13", ">= 12.1.0"

# System gems
gem "dalli", "~> 2.7"
gem "connection_pool", "~> 2.2"
gem "newrelic_rpm"
gem "logstash-event"
gem "lograge", ">= 0.3.6"
gem "rack-timeout", "~> 0.4"
gem "bootscale", "~> 0.5", require: false

group :production do
  gem "rails_12factor"
  gem "sentry-raven"
end

group :development do
  gem "foreman"
  gem "letter_opener"
end

group :development, :test do
  gem "dotenv-rails", ">= 2.1.1"
  gem "pry-byebug"
  gem "pry-rails"
end

group :test do
  gem "rspec-rails", "~> 3.5.2"
  gem "factory_girl_rails", "~> 4.8.0", require: false
  gem "fakefs", "~> 0.11.0", require: "fakefs/safe"
  gem "forgery", github: "mtunjic/forgery", branch: "master"
  gem "json_expressions", "~> 0.9.0"
  gem "simplecov", "~> 0.14.1"
  gem "simplecov-rcov"
  gem "webmock", "~> 3.0.1"
  gem "database_cleaner", github: "theharq/database_cleaner", branch: "sequel-updates"
  gem "rspec_junit_formatter"
end
