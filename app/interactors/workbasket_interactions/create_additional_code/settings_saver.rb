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

      def valid?
        check_required_params!
        check_additional_codes!
        errors.blank?
      end

      def persist!
        filtered_additional_codes.each do |position, item|
          build_additional_code!(item)
        end
      end

      private

      def check_required_params!
        general_errors = {}

        REQUIRED_PARAMS.map do |k|
          if public_send(k).blank?
            general_errors[k.to_sym] = "#{k.to_s.capitalize.split('_').join(' ')} can't be blank!"
          end
        end

        @errors[:general] = general_errors if general_errors.present?
      end

      def check_additional_codes!
        additional_codes_errors = {}
        filtered_additional_codes.each do |position, item|
          @errors["additional_code_additional_code_type_id_#{index}"] = "\##{index.to_i + 1} - Additional code type can't be blank" if item['additional_code_type_id'].blank?
          if item['additional_code_type_id'].blank?
            @errors["additional_code_additional_code_#{index}"] = "\##{index.to_i + 1} - Additional code can't be blank"
          else
            @errors["additional_code_additional_code_#{index}"] = "\##{index.to_i + 1} - Additional code can contain only numbers and characters" unless item['additional_code_type_id'].upcase =~ /[^A-Z0-9]/
          end
          @errors["additional_code_description_#{index}"] = "\##{index.to_i + 1} - Description can't be blank" if item['description'].blank?
        end
        errors[:additional_codes] = additional_codes_errors if additional_codes_errors.present?
      end

      def build_additional_code!(item)
        additional_code_sid = create_additional_code(item)
        additional_code_description_period_sid = create_additional_code_description_period(additional_code_sid, item)
        create_additional_code_description(additional_code_description_period_sid, additional_code_sid, item)
      end

      def create_additional_code_description(additional_code_description_period_sid, additional_code_sid, item)
        additional_code_description = AdditionalCodeDescription.new(
            attrs_parser.additional_code_description_attributes(additional_code_description_period_sid, additional_code_sid, item))
        assign_system_ops!(additional_code_description)
        additional_code_description.save
      end

      def create_additional_code_description_period(additional_code_sid, item)
        additional_code_description_period = AdditionalCodeDescriptionPeriod.new(
            attrs_parser.additional_code_description_period_attributes(additional_code_sid, item))
        ::WorkbasketValueObjects::Shared::PrimaryKeyGenerator.new(additional_code_description_period).assign!
        assign_system_ops!(additional_code_description_period)
        additional_code_description_period.save
        additional_code_description_period_sid = additional_code_description_period.additional_code_description_period_sid
      end

      def create_additional_code(item)
        additional_code = AdditionalCode.new(attrs_parser.additional_code_attributes(item))
        ::WorkbasketValueObjects::Shared::PrimaryKeyGenerator.new(additional_code).assign!
        assign_system_ops!(additional_code)
        additional_code.save
        additional_code_sid = additional_code.additional_code_sid
      end

    end
  end
end
