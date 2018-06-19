Sequel.migration do
  up do
    rename_column :workbaskets_events, :title, :event_type
  end

  down do
    rename_column :workbaskets_events, :event_type, :title
  end
end
