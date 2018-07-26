require "db_migration_helpers/xml_export_view_re_populator"

Sequel.migration do
  change do
    script = ::DbMigrationHelpers::XmlExportViewRePopulator

    script.const_get("MODELS_TO_UPDATE").map do |model|
      new_definition = script.new_view_definition(model)
      table_name = script.viewname(model)

      run "DROP VIEW public.#{table_name};"

      alter_table "#{table_name}_oplog" do
        add_column :status, String
        add_column :workbasket_id, Integer
        add_column :workbasket_sequence_number, Integer
      end

      run %Q{
        CREATE VIEW public.#{table_name} AS
        #{new_definition}
      }
    end
  end
end
