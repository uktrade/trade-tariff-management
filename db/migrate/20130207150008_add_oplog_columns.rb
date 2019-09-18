Sequel.migration do
  up do
    Sequel::Model.db.tables
                    .reject{|t_name| t_name.in?([:tariff_updates, :sections, :schema_migrations])}
                    .reject{|t_gis_table| t_gis_table.in?([:spatial_ref_sys,:raster_columns, :raster_overviews, :geography_columns, :geometry_columns ])}
                    .reject{|t| t.to_s =~ /chief|chapter_notes|section_notes|chapters_sections|hidden|search/}.each do |table_name|
      alter_table table_name do
        add_primary_key :oid
        add_column :operation, String, size: 1, default: 'C'
        add_column :operation_date, Date
      end
    end
  end

  down do
    Sequel::Model.db.tables
                    .reject{|t_name| t_name.in?([:tariff_updates, :sections, :schema_migrations])}
                    .reject{|t_gis_table| t_gis_table.in?([:spatial_ref_sys,:raster_columns, :raster_overviews, :geography_columns, :geometry_columns ])}
                    .reject{|t| t.to_s =~ /chief|chapter_notes|section_notes|chapters_sections|hidden|search/}.each do |table_name|
      alter_table table_name do
        drop_column :oid
        drop_column :operation
        drop_column :operation_date
      end
    end
  end
end
