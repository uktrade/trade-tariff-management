module WorkbasketInteractions
  module CreateAdditionalCode
    class SettingsSaver < ::WorkbasketInteractions::SettingsSaverBase

      WORKBASKET_TYPE = "CreateAdditionalCode"

      REQUIRED_PARAMS = %w(
        workbasket_name
        validity_start_date
      )

      ATTRS_PARSER_METHODS = %w(
        workbasket_name
        validity_start_date
        validity_end_date
        filtered_additional_codes
      )

      ATTRS_PARSER_METHODS.map do |option|
        define_method(option) do
          attrs_parser.public_send(option)
        end
      end

      attr_accessor :records

      def valid?
        @records = []
        build_additional_codes!
        validate_additional_codes!
        errors.blank?
      end

      def persist!
        save_additional_codes!
      end

      private

      def build_additional_codes!
        filtered_additional_codes.each do |position, item|
          additional_code = AdditionalCode.new(attrs_parser.additional_code_attributes(item))
          ::WorkbasketValueObjects::Shared::PrimaryKeyGenerator.new(additional_code, position.to_i).assign!
          additional_code_sid = additional_code.additional_code_sid
          @records << additional_code

          AdditionalCodeDescriptionPeriod.unrestrict_primary_key
          additional_code_description_period = AdditionalCodeDescriptionPeriod.new(
              attrs_parser.additional_code_description_period_attributes(additional_code_sid, item))
          ::WorkbasketValueObjects::Shared::PrimaryKeyGenerator.new(additional_code_description_period, position.to_i).assign!
          additional_code_description_period_sid = additional_code_description_period.additional_code_description_period_sid
          @records << additional_code_description_period

          AdditionalCodeDescription.unrestrict_primary_key
          additional_code_description = AdditionalCodeDescription.new(
              attrs_parser.additional_code_description_attributes(additional_code_description_period_sid, additional_code_sid, item))
          @records << additional_code_description

          if attrs_parser.meursing?(item)
            meursing_additional_code = MeursingAdditionalCode.new(attrs_parser.meursing_additional_code_attributes(item))
            ::WorkbasketValueObjects::Shared::PrimaryKeyGenerator.new(meursing_additional_code, position.to_i).assign!
            @records << meursing_additional_code
          end
        end
      end

      def validate_additional_codes!
        additional_code_errors = {}
        records.each do |record|
          validator = validator(record)
          if validator.present?
            ::WorkbasketValueObjects::Shared::ConformanceErrorsParser.new(
                record,
                validator,
                {}
            ).errors.map do |key, error|
              additional_code_errors.merge(key: error.join('. '))
            end
          end
        end
        @errors[:additional_codes] = additional_code_errors if additional_code_errors.present?
      end

      def save_additional_codes!
        records.each do |record|
          assign_system_ops!(record)
          record.save
        end
      end

      def validator(record)
        "#{record.class.name}Validator".constantize
      rescue
        nil
      end

    end
  end
end
