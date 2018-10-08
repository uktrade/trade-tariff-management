Sequel.migration do
  change do
    alter_table :users do
      add_column :approver_user, :boolean, default: false
    end
  end
end
