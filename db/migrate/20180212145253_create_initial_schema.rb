Sequel.migration do
  change do
    system `bundle exec rake db:structure:load`
  end
end
