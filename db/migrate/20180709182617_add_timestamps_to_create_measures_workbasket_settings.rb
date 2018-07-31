Sequel.migration do
  change do
    alter_table :create_measures_workbasket_settings do
      add_column :created_at, :time
      add_column :updated_at, :time
    end
  end
end
