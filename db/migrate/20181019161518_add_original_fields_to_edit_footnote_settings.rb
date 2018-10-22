Sequel.migration do
  change do
    alter_table :edit_footnotes_workbasket_settings do
      add_column :original_footnote_type_id, String
      add_column :original_footnote_id, String
    end
  end
end
