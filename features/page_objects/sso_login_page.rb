class SSOLoginPage < SitePrism::Page
  set_url "https://sso.trade.uat.uktrade.io/login/"

  element :username, "#id_username"
  element :password, "#id_password"
  element :login_button, "input[value='login']"
  element :uid, "#uid"
  element :email, "#email"
  element :first_name, "#first_name"
  element :last_name, "#last_name"
  element :sigin_button, "button[type='submit']"

  def login
    dev_login
  end

  def uat_login
    username.set 'oo.crosscheck@tradetariff.test'
    password.set 'd5o0m766Lk8'
    login_button.click
  end

  def dev_login
    uid.set 'oo'
    email.set '1'
    first_name.set '1'
    last_name.set '1'
    sigin_button.click
  end
end