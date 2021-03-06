ENV["RAILS_ENV"] ||= 'test'

require "spec_helper"

require 'webmock/rspec'

allowed_sites = [
  "https://codeclimate.com",
  "https://chromedriver.storage.googleapis.com",
  "https://github.com/mozilla/geckodriver/releases",
  "https://selenium-release.storage.googleapis.com",
  "https://developer.microsoft.com/en-us/microsoft-edge/tools/webdriver"
]
WebMock.disable_net_connect!(allow: allowed_sites, allow_localhost: true)

# SimpleCov.add_filter "vendor"
#
# if ENV.key?("CODECLIMATE_REPO_TOKEN")
#   SimpleCov.formatters = []
#   SimpleCov.start CodeClimate::TestReporter.configuration.profile
# elsif ENV.key?("ENABLE_COVERAGE")
#   puts "Code coverage enabled"
#   SimpleCov.start "rails"
# end

require File.expand_path('../config/environment', __dir__)

require 'rspec/rails'
require 'json_expressions/rspec'
require 'fakefs/spec_helpers'
require 'sidekiq/testing'

require 'capybara/rspec'
require 'capybara/rails'
require 'selenium/webdriver'

require Rails.root.join("spec/support/tariff_validation_matcher.rb")
Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

# require models and serializers
Dir[Rails.root.join("app/models/*.rb")].each { |f| require f }
Dir[Rails.root.join("app/serializers/*.rb")].each { |f| require f }

RSpec.configure do |config|
  config.use_transactional_fixtures = false
  config.raise_errors_for_deprecations!
  config.infer_spec_type_from_file_location!
  config.infer_base_class_for_anonymous_controllers = false
  config.alias_it_should_behave_like_to :it_results_in, "it results in"
  config.alias_it_should_behave_like_to :it_is_associated, "it is associated"
  config.include RSpec::Rails::RequestExampleGroup, type: :request, file_path: /spec\/api/
  config.include ControllerSpecHelper, type: :controller
  config.include SynchronizerHelper
  config.include LoggerHelper
  config.include RescueHelper
  config.include ChiefDataHelper
  config.include ActiveSupport::Testing::TimeHelpers
  config.include CapybaraFormHelper, type: :feature
  config.include Rails.application.routes.url_helpers

  redis = Redis.new(db: 15)
  RedisLockDb.redis = redis

  config.before(:example, :type => :request) do
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(create(:user))
    allow_any_instance_of(ApplicationController).to receive(:token_expired?).and_return(false)
    allow_any_instance_of(ApplicationController).to receive(:audit_session).and_return(nil)
  end

  config.before(:example, :type => :feature) do
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(create(:user))
    allow_any_instance_of(ApplicationController).to receive(:token_expired?).and_return(false)
    allow_any_instance_of(ApplicationController).to receive(:audit_session).and_return(nil)
  end

  config.before(:suite) do
    redis.flushdb
  end

  config.after(:suite) do
    redis.flushdb
  end

  config.before do
    Rails.cache.clear
    Sidekiq::Worker.clear_all
  end
end
