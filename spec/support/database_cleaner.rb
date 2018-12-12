RSpec.configure do |config|
  # Only allow CI postgresql as 'remote' URL, no others
  # Future versions of DatabaseCleaner (> 1.7.0?) will allow a whitelist instead
  if ENV.fetch("DATABASE_URL", "").start_with?("postgresql://postgres:postgres@postgres:5432/")
    DatabaseCleaner.allow_remote_database_url = true
  end

  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseCleaner.strategy = if Capybara.current_driver == :rack_test
                                 :transaction
                               else
                                 :truncation
                               end
  end

  config.before(:each, truncation: true) do
    DatabaseCleaner.strategy = :truncation
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end
end
