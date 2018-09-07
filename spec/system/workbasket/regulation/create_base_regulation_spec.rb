require "rails_helper"

describe "Create Regulation", js: true do

  let!(:user)   { create :user }

  it "follow create regulation page" do
    visit '/'
    expect(page).to have_content 'Create a regulation'
    click_link 'Create a regulation'

    expect(page).to have_content 'Specify the regulation type'
    within('.workbasket_forms_create_regulation_form_role') do
      # $('.workbasket_forms_create_regulation_form_role input')[0].click() works pn browser
      # find('input').click
      page.driver.execute_script("$('.workbasket_forms_create_regulation_form_role input')[0].click()")
      wait = Selenium::WebDriver::Wait.new(timeout: 10)
      begin
        wait.until { page.driver.find_css(".selectize-dropdown-content span.selection").present? }
        puts page.driver.find_css(".selectize-dropdown-content span.selection").inspect
      rescue
        puts 'select not opened'
      end


      # page.should have_selector?('.dropdown-active')
    # print page.html
    # find(:css, "#workbasket_forms_create_regulation_form_role-selectized", visible: false).set('Base regulation')
    # find(:css, "#workbasket_forms_create_regulation_form_role-selectized", visible: false).native.send_keys(:return)
      # fill_in("#workbasket_forms_create_regulation_form_role-selectized", with: 'Base Regulation')
    end
    element = page.driver.execute_script("return document.body")

    File.open('tmp/capybara/page.html', "w+") do |f|
      f.write(element.attribute("innerHTML"))
    end

    page.save_screenshot('screenshot.png')
    # expect(page).to have_content 'Start date'
  end

  after do

  end

end