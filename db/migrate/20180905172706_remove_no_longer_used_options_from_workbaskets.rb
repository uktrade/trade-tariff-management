Sequel.migration do
  change do
    alter_table :workbaskets do
      drop_column :regulation_id
      drop_column :regulation_role
      drop_column :changes_do_not_come_from_legislation
      drop_column :reason_of_changes
    end
  end
end

