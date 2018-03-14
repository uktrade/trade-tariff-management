GovukAdminTemplate.environment_style = Rails.env.test? ? "integration" : Rails.env

GovukAdminTemplate.configure do |c|
  c.show_flash = true
end
