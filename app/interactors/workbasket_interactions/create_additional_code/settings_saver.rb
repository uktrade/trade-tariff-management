module WorkbasketInteractions
  module CreateAdditionalCode
    class SettingsSaver < ::WorkbasketInteractions::SettingsSaverBase
      WORKBASKET_TYPE = "CreateAdditionalCode".freeze

      REQUIRED_PARAMS = %w(
        workbasket_name
        validity_start_date
      ).freeze

      ATTRS_PARSER_METHODS = %w(
        workbasket_name
        validity_start_date
        validity_end_date
        filtered_additional_codes
      ).freeze

      ATTRS_PARSER_METHODS.map do |option|
        define_method(option) do
          attrs_parser.public_send(option)
        end
      end

      attr_accessor :records

      def valid?
        @records = []
        check_required_params!

        if @save_mode == "submit_for_cross_check"
          check_additional_codes!

          if errors.blank?
            Sequel::Model.db.transaction(@do_not_rollback_transactions.present? ? {} : { rollback: :always }) do
              build_additional_codes!
              validate_additional_codes!
            end
          end
        end

        errors.blank?
      end

      def persist!
        @do_not_rollback_transactions = true
        save_additional_codes!
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
        if filtered_additional_codes.size == 0
          @errors["zero_additional_codes"] = "At least one new code must be entered"
        else
          filtered_additional_codes.each do |index, item|
            @errors["additional_code_type_id_#{index}"] = "Additional code type can't be blank for new additional code at row #{index.to_i + 1}" if item['additional_code_type_id'].blank?
            if item['additional_code'].blank?
              @errors["additional_code_#{index}"] = "Additional code can't be blank for new additional code at row #{index.to_i + 1}"
            else
              @errors["additional_code_#{index}"] = "Additional code can contain only numbers and characters for new additional code at row #{index.to_i + 1}" if item['additional_code'].upcase =~ /[^A-Z0-9]/
            end
            # FIXME: There is bug here when trying to validate description without defining additional_code_type_id.
            @errors["additional_code_description_#{index}"] = "Description can't be blank for new additional code at row #{index.to_i + 1}" if item['description'].blank? && !attrs_parser.meursing?(item)
          end
        end
      end

      def build_additional_codes!
        filtered_additional_codes.each do |position, item|
          if attrs_parser.meursing?(item)
            meursing_additional_code = MeursingAdditionalCode.new(attrs_parser.meursing_additional_code_attributes(item))
            ::WorkbasketValueObjects::Shared::PrimaryKeyGenerator.new(meursing_additional_code, position.to_i).assign!
            @records << meursing_additional_code
            next
          end

          additional_code = AdditionalCode.new(attrs_parser.additional_code_attributes(item))
          ::WorkbasketValueObjects::Shared::PrimaryKeyGenerator.new(additional_code, position.to_i).assign!
          additional_code_sid = additional_code.additional_code_sid
          @records << additional_code

          AdditionalCodeDescriptionPeriod.unrestrict_primary_key
          additional_code_description_period = AdditionalCodeDescriptionPeriod.new(
            attrs_parser.additional_code_description_period_attributes(additional_code_sid, item)
          )
          ::WorkbasketValueObjects::Shared::PrimaryKeyGenerator.new(additional_code_description_period, position.to_i).assign!
          additional_code_description_period_sid = additional_code_description_period.additional_code_description_period_sid
          @records << additional_code_description_period

          AdditionalCodeDescription.unrestrict_primary_key
          additional_code_description = AdditionalCodeDescription.new(
            attrs_parser.additional_code_description_attributes(additional_code_description_period_sid, additional_code_sid, item)
          )
          @records << additional_code_description
        end
      end

      def validate_additional_codes!
        additional_code_errors = {}
        additional_code_errors.merge!(check_duplicates_in_basket)
        records.each_with_index do |record, index|
          validator = validator(record)
          if validator.present?
            ::WorkbasketValueObjects::Shared::ConformanceErrorsParser.new(
              record,
                validator,
                {}
            ).errors.map do |_key, error|
              additional_code_errors.merge!("#{index}": error.join('. '))
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
      rescue StandardError
        nil
      end

      def check_duplicates_in_basket
        type_codes = Set.new
        records.each do |record|
          if record.class == AdditionalCode
            combined_key = [record.additional_code_type_id, record.additional_code]
            if type_codes.include?(combined_key)
              return {"0": "ACN10: The combination of additional code type + additional code + start date must be unique."}
            else
              type_codes << combined_key
            end
          end
        end
        {}
      end
    end
  end
end
