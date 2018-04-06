Sequel.migration do
  up do
    drop_table :node_envelopes
    drop_table :node_transactions
    drop_table :node_messages
  end
end
