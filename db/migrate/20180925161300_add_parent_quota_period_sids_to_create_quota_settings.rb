Sequel.migration do
  change do
    alter_table :create_quota_workbasket_settings do
      add_column :parent_quota_period_sids_jsonb, :jsonb, default: '{}'
    end
  end
end
