Sequel.migration do
  change do
    add_index :measures_oplog, :ordernumber
  end
end
