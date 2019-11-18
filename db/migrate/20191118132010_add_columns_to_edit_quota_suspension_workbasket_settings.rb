Sequel.migration do
  change do
    alter_table :edit_quota_suspension_workbasket_settings do
      add_column :quota_definition_sid, String
      add_column :quota_suspension_period_sid, String
    end
  end
end
