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
    username.set ENV['USERNAME']
    password.set ENV['PASSWORD']
    login_button.click
  end
end
