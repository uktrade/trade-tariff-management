module WorkbasketServices
  module AssociationSavers
    class SingleAssociation < ::WorkbasketServices::AssociationSavers::AssociationBase

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

        if @errors.blank? && !measure.new?
          persist!
        end

        @errors.blank?
      end

      def persist!
        persist_record!(record)
      end

      private

        def validate!
          ::Measures::ConformanceErrorsParser.new(
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
