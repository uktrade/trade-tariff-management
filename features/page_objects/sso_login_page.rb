class SSOLoginPage < SitePrism::Page
  set_url "https://sso.trade.uat.uktrade.io/login/"

  element :username, "#id_username"
  element :password, "#id_password"
  element :login_button, "input[value='login']"

  def login
    username.set 'oo.crosscheck@tradetariff.test'
    password.set 'd5o0m766Lk8'
    login_button.click
  end
end