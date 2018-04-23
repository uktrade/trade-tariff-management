Sequel.migration do
  change do
    %w(
      base_regulations_oplog
      modification_regulations_oplog
      complete_abrogation_regulations_oplog
      explicit_abrogation_regulations_oplog
      prorogation_regulations_oplog
      full_temporary_stop_regulations_oplog
    ).map do |table_name|
      add_column table_name, :added_by_id, Integer
      add_column table_name, :added_at, Time
    end
  end
end
