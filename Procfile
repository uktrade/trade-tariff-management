web: bundle exec rake cf:on_first_instance db:migrate && bundle exec puma -C config/puma.rb
worker: bundle exec sidekiq -C ./config/sidekiq.yml
