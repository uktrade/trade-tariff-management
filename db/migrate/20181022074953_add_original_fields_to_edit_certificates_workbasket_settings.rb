Sequel.migration do
  change do
    alter_table :edit_certificates_workbasket_settings do
      add_column :original_certificate_type_code, String
      add_column :original_certificate_code, String
    end
  end
end
