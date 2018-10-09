Sequel.migration do
  change do
    alter_table :workbaskets do
      add_column :cross_checker_id, Integer
      add_column :approver_id, Integer
    end
  end
end
