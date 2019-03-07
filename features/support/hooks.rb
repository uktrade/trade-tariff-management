

Before do |scenario|
  if Capybara.current_driver == :chrome
    page.driver.browser.manage.window.maximize
  end
end

AfterStep do
  sleep 0  #It'll help to slow down the tests to see what's been selected and clicked on the front end
end