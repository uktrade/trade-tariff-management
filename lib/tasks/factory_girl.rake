namespace :factory_girl do
  desc "Verify that all FactoryGirl factories are valid"
  task lint: :environment do
    if Rails.env.test?
      print "Linting factories..."

      require "factory_girl_rails"
      # TODO: Remove patching of Sequel
      require_relative "../../spec/support/sequel"

      DatabaseCleaner.clean_with(:truncation)
      DatabaseCleaner.cleaning do
        FactoryGirl.lint(traits: true)
      end

      print " done\n"
    else
      system("bundle exec rake factory_girl:lint RAILS_ENV='test'")
      fail if $?.exitstatus.nonzero?
    end
  end
end
