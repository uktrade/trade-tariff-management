require 'ditsso_internal'

Rails.application.config.middleware.use OmniAuth::Builder do

  if ENV['DITSSO_INTERNAL_PROVIDER'].present?
    provider 'ditsso_internal',
             ENV['DITSSO_INTERNAL_CLIENT_ID'],
             ENV['DITSSO_INTERNAL_CLIENT_SECRET']
  else
    provider :developer, :fields => [:uid, :email, :first_name, :last_name],
             :uid_field => :uid
  end

end
