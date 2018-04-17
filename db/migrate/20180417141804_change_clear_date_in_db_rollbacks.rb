Sequel.migration do
  up do
    alter_table :db_rollbacks do
      drop_column :clear_date
      add_column :date_filters, :text
    end
  end
end
