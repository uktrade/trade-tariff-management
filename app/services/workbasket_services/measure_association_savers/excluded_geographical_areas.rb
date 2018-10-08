module WorkbasketServices
  module MeasureAssociationSavers
    class ExcludedGeographicalAreas < ::WorkbasketServices::MeasureAssociationSavers::SingleAssociation

      private

        def generate_record!
          area = geographical_area(record_ops[:excluded_geographical_area])

          @record = MeasureExcludedGeographicalArea.new(
            excluded_geographical_area: area.geographical_area_id
          )
          record.measure = measure
          record.measure_sid = measure.measure_sid
          record.geographical_area_sid = area.geographical_area_sid

          set_primary_key(record)
        end
    end
  end
end
