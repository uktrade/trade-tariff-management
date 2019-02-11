namespace :factory_bot do
  desc "Verify that all FactoryBot factories are valid"
  task lint: :environment do
    if Rails.env.test?
      print "Linting factories..."

      require_relative "../../spec/support/factory_bot"

      DatabaseCleaner.clean_with(:truncation)
      DatabaseCleaner.cleaning do
        FactoryBot.lint(traits: true)
      end

      print " done\n"
    else
      system("bundle exec rake factory_bot:lint RAILS_ENV='test'")
      fail if $?.exitstatus.nonzero?
    end
  end
end
