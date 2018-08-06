module WorkbasketServices
  module AssociationSavers
    class ExcludedGeographicalAreas < ::WorkbasketServices::AssociationSavers::SingleAssociation

      private

        def generate_record!
          area = GeographicalArea.actual.where(
            geographical_area_id: record_ops[:excluded_geographical_area]
          ).first

          @record = MeasureExcludedGeographicalArea.new(
            excluded_geographical_area: area.geographical_area_id
          )
          record.measure_sid = measure.measure_sid
          record.geographical_area_sid = area.geographical_area_sid

          set_primary_key(record)
        end
    end
  end
end
