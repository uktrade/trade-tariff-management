# Require External Libraries
require 'cucumber/rails'
require 'capybara/cucumber'
require 'capybara/rspec'
require 'selenium-webdriver'
require 'site_prism'
require 'securerandom'
require 'rbconfig'
require 'capybara-screenshot/cucumber'
require 'pry'
require_relative '../../spec/support/capybara_form_helper'
require 'fileutils'

CONFIG = YAML::load_file("#{File.dirname(__FILE__)}/../test_data.yaml")

# Remove old screenshots
FileUtils.rm_rf(Dir['screenshots/cucumber/*'])

Capybara.configure do |config|
  config.ignore_hidden_elements = false #true by default
  config.default_max_wait_time = 30
end

Capybara.register_driver :chrome do |app|
  Capybara::Selenium::Driver.new(app, browser: :chrome)
end


Capybara.register_driver :chrome_headless do |app|
  options = ::Selenium::WebDriver::Chrome::Options.new

  options.add_argument('--headless')
  options.add_argument('--no-sandbox')
  options.add_argument('--disable-dev-shm-usage')
  options.add_argument('--window-size=1400,1400')

  Capybara::Selenium::Driver.new(app, browser: :chrome, options: options)
end


#Capture screenshots by default in failing tests
Capybara::Screenshot.register_driver(:chrome) do |driver, path|
  driver.browser.save_screenshot(path)
end

Capybara::Screenshot.register_driver(:chrome_headless) do |driver, path|
  driver.browser.save_screenshot(path)
end

case ENV['BROWSER']
  when 'headless'
    Capybara.javascript_driver = Capybara.default_driver = :chrome_headless
  else
    Capybara.default_driver = :chrome
end

Capybara.app_host = ENV['BASE_URL']
Capybara.save_path = "screenshots/cucumber"

puts "#############################################################################################"
puts "RUNNING TESTS ON ENVIRONMENT: #{ENV['BASE_URL']}"
puts "#############################################################################################"
