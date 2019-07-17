class SSOLoginPage < SitePrism::Page
  set_url ENV['LOGIN']

  element :username, "#id_username"
  element :password, "#id_password"
  element :login_button, "input[value='login']"
  element :uid, "#uid"
  element :email, "#email"
  element :first_name, "#first_name"
  element :last_name, "#last_name"
  element :sigin_button, "button[type='submit']"

  def login
    uid.set ENV['TARIFFMANAGER']
    email.set "1"
    first_name.set "1"
    last_name.set "1"
    sigin_button.click
  end

  def login_as(user)
    case user
      when 'tariff_manager'
        uid.set ENV['TARIFFMANAGER']
      when 'cross_checker'
        uid.set ENV['CROSSCHECKER']
      when 'approver'
        uid.set ENV['APPROVER']
    end
    email.set "1"
    first_name.set "1"
    last_name.set "1"
    sigin_button.click
  end
end