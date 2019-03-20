class SSOLoginPage < SitePrism::Page
  set_url ENV['LOGIN']
  
  element :username, "#id_username"
  element :password, "#id_password"
  element :login_button, "input[value='login']"

  def login
    username.set ENV['USERNAME']
    password.set ENV['PASSWORD']
    login_button.click
  end
end