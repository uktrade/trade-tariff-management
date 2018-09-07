module WorkbasketServices
  module MeasureAssociationSavers
    class MultipleAssociation < ::WorkbasketServices::MeasureAssociationSavers::AssociationBase

      def valid?
        generate_records!
        validate_records!

        Rails.logger.info ""
        Rails.logger.info " MultipleAssociation errors: #{@errors.inspect}"
        Rails.logger.info ""
        Rails.logger.info " measure.new?: #{measure.new?}"
        Rails.logger.info ""

        if @errors.blank? && !measure.new?
          Rails.logger.info ""
          Rails.logger.info " persist! in MultipleAssociation"
          Rails.logger.info ""

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
