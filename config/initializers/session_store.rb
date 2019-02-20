# Be sure to restart your server when you modify this file.

redis_url = if ENV['REDIS_URL'].present?
  ENV["REDIS_URL"]
elsif ENV['VCAP_SERVICES'].present?
  JSON.parse(ENV["VCAP_SERVICES"])["redis"].select do |s|
    s["name"] == ENV["REDIS_INSTANCE_NAME"]
  end[0]["credentials"]["uri"]
end

Rails.application.config.session_store :redis_store,
  servers: [redis_url],
  expire_after: 240.minutes,
  key: "_#{Rails.application.class.parent_name.downcase}_session",
  threadsafe: false
