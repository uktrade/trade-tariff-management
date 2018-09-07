module WorkbasketServices
  module MeasureAssociationSavers
    class SingleAssociation < ::WorkbasketServices::MeasureAssociationSavers::AssociationBase

      attr_accessor :measure,
                    :system_ops,
                    :record,
                    :record_ops,
                    :extra_increment_value,
                    :errors

      def initialize(measure, system_ops, record_ops={})
        @measure = measure
        @system_ops = system_ops
        @record_ops = record_ops
        @extra_increment_value = record_ops[:position]

        @errors = {}
      end

      def valid?
        generate_record!
        validate!

        Rails.logger.info ""
        Rails.logger.info " SingleAssociation errors: #{@errors.inspect}"
        Rails.logger.info ""
        Rails.logger.info " measure.new?: #{measure.new?}"
        Rails.logger.info ""

        if @errors.blank? && !measure.new?
          Rails.logger.info ""
          Rails.logger.info " persist! in SingleAssociation"
          Rails.logger.info ""

          persist!
        end

        @errors.blank?
      end

      def persist!
        persist_record!(record)
      end

      private

        def validate!
          ::WorkbasketValueObjects::Shared::ConformanceErrorsParser.new(
            record, validator, {}
          ).errors
           .map do |k, v|
            @errors[k] = v
          end
        end

        def validator
          "#{record.class.name}Validator".constantize
        end
    end
  end
end
