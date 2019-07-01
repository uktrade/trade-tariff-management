require "selenium/webdriver"
require 'webdrivers'

Webdrivers::Chromedriver.required_version = '74.0.3729.6'

Capybara.register_driver :chrome do |app|
  Capybara::Selenium::Driver.new(app, browser: :chrome)
end

Capybara.register_driver :headless_chrome do |app|
  capabilities = Selenium::WebDriver::Remote::Capabilities.chrome(
    chromeOptions: { args: %w(headless disable-gpu window-size=2024,3072) }
  )

  Capybara::Selenium::Driver.new app,
                                 browser: :chrome,
                                 desired_capabilities: capabilities
end

Capybara.javascript_driver = :headless_chrome
Capybara.default_max_wait_time = 10
Capybara.server = :puma, { Silent: !ENV.key?("DEBUG") }
