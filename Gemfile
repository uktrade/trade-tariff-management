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
gem "sass-rails", "5.0.6"
gem "jquery-rails", "~> 4.1.0"
gem "coffee-rails", "~> 4.2.2"
gem "uglifier", "~> 2.7"
gem 'govuk_admin_template', '5.0.0'
gem "bootstrap-datepicker-rails", "~> 1.4"

# File uploads and AWS
gem "shrine"
gem "aws-sdk"
gem "aws-sdk-rails"
gem "aws-sdk-s3"

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
gem 'kaminari'
gem 'kaminari-sequel'
gem "simple_form", "~> 3.5"

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

gem "plek", "~> 1.11"
gem "gds-sso", "~> 13", ">= 12.1.0"
gem "pundit", "0.3.0"

# System gems
gem "connection_pool", "~> 2.2"
gem "logstash-event"
gem "lograge", ">= 0.3.6"
gem "rack-timeout", "~> 0.4"
gem "bootscale", "~> 0.5", require: false

# We freezed it, as it installs higher version by default,
# which conflicts with cloud foundary's ruby_buildpack
# as in new version 'ffi' require 'automake' package
#
gem "ffi", "1.9.18"

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
