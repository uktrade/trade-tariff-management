Rack::Timeout.service_timeout = Integer(ENV.fetch("RACK_TIMEOUT_SERVICE", 60))
Rack::Timeout.unregister_state_change_observer(:logger) if Rails.env.development?
