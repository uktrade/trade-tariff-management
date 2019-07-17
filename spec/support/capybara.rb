require "selenium/webdriver"
require 'webdrivers'
require 'fileutils'
require 'capybara-screenshot/rspec'
require 'capybara/rspec'
require_relative '../../spec/support/capybara_form_helper'

# Remove old screenshots
FileUtils.rm_rf(Dir['screenshots/rspec/*'])
Capybara.save_path = "screenshots/rspec"

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

Capybara.javascript_driver = :chrome_headless
Capybara.default_max_wait_time = 30
Capybara.server = :puma, { Silent: !ENV.key?("DEBUG") }
