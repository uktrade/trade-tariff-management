require "sidekiq"

redis_url = if ENV['REDIS_URL'].present?
  ENV["REDIS_URL"]
elsif ENV['VCAP_SERVICES'].present?
  JSON.parse(ENV["VCAP_SERVICES"])["redis"].select do |s|
    s["name"] == ENV["REDIS_INSTANCE_NAME"]
  end[0]["credentials"]["uri"]
else
  ""
end

redis_config = { url: redis_url }

Sidekiq.configure_server do |config|
  config.redis = redis_config
end

Sidekiq.configure_client do |config|
  config.redis = redis_config
end

