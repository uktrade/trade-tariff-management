

# Require External Libraries
require 'cucumber/rails'
require 'capybara/cucumber'
require 'capybara/rspec'
require 'selenium-webdriver'
require 'site_prism'
require 'selenium-webdriver'
require 'securerandom'
require 'rbconfig'
require 'capybara-screenshot/cucumber'
require 'pry'
require_relative '../../spec/support/capybara_form_helper'


Capybara.configure do |config|
  config.ignore_hidden_elements = false #true by default
  config.default_max_wait_time = 10
end

Capybara.register_driver :chrome do |app|
  Capybara::Selenium::Driver.new(app, browser: :chrome)
end

Capybara.register_driver :headless_chrome do |app|
  capabilities = Selenium::WebDriver::Remote::Capabilities.chrome(
      chromeOptions: { args: %w(headless disable-gpu window-size=1824,3072) }
  )

  Capybara::Selenium::Driver.new app,
                                 browser: :chrome,
                                 desired_capabilities: capabilities
end

#Capture screenshots by default in failing tests
Capybara::Screenshot.register_driver(:chrome) do |driver, path|
  driver.browser.save_screenshot(path)
end

case ENV['BROWSER']
  when 'headless'
    Capybara.javascript_driver = Capybara.default_driver = :headless_chrome
  else
    Capybara.default_driver = :chrome
end

ENV['BASE_URL'] = 'https://tariffs-uat.london.cloudapps.digital'
puts "#############################################################################################"
puts "RUNNING TESTS ON ENVIRONMENT: #{ENV['BASE_URL']}"
puts "#############################################################################################"

Capybara.app_host = ENV['BASE_URL']
Capybara.save_path = "screenshots"
