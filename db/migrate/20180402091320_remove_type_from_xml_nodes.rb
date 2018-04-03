Sequel.migration do
  up do
    alter_table :node_envelopes do
      drop_column :type
    end

    alter_table :node_transactions do
      drop_column :type
    end

    alter_table :node_messages do
      drop_column :type
    end
  end

  down do
    alter_table :node_envelopes do
      add_column :type, String
    end

    alter_table :node_transactions do
      add_column :type, String
    end

    alter_table :node_messages do
      add_column :type, String
    end
  end
end
