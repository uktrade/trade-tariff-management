module WorkbasketServices
  module MeasureAssociationSavers
    class MultipleAssociation < ::WorkbasketServices::MeasureAssociationSavers::AssociationBase
      def valid?
        generate_records!
        validate_records!

        if @errors.blank? && !measure.new?
          persist!
        end

        @errors.blank?
      end

    private

      def validate!(record)
        if validator(record.class.name).present?
          ::WorkbasketValueObjects::Shared::ConformanceErrorsParser.new(
            record, validator(record.class.name), {}
          ).errors
           .map do |k, v|
            @errors[k] = v
          end
        end
      end
    end
  end
end
