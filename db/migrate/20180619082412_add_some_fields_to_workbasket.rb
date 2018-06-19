Sequel.migration do
  change do
    alter_table :workbaskets do
      add_column :regulation_id, String
      add_column :regulation_role, String
      add_column :changes_do_not_come_from_legislation, :boolean, default: false
      add_column :reason_of_changes, String, text: true
      add_column :operation_date, Date
    end
  end
end
