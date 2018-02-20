# Be sure to restart your server when you modify this file.

Rails.application.config.session_store :cookie_store, key: "_trade_tariff_management_#{ENV['GOVUK_APP_DOMAIN'].gsub('.', '')}"
