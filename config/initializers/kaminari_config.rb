# frozen_string_literal: true

per_page = if Rails.env.production?
  300
elsif Rails.env.development?
  25
elsif Rails.env.test?
  10
end

Kaminari.configure do |config|
  config.default_per_page = per_page
  config.max_per_page = per_page
  # config.window = 4
  # config.outer_window = 0
  # config.left = 0
  # config.right = 0
  # config.page_method_name = :page
  # config.param_name = :page
  # config.params_on_first_page = false
end
