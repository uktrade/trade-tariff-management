Sequel.migration do
  change do
    alter_table :sections do
      add_column :updated_at, Time, null: false
    end
  end
end
