Sequel.migration do
  change do
    # Do nothing
    # Sequel raises:
    # `NoMethodError: undefined method >' for nil:NilClass`
    # if you run `bundle exec rake db:migrate` and
    # there are would not at least of one file in db/migrate folder
  end
end
