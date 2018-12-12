module WorkbasketValueObjects
  module CreateAdditionalCode
    class AttributesParser < WorkbasketValueObjects::AttributesParserBase
      SIMPLE_OPS = %w(
        workbasket_name
        validity_start_date
        validity_end_date
        additional_codes
      ).freeze

      SIMPLE_OPS.map do |option_name|
        define_method(option_name) do
          ops[option_name]
        end
      end

      attr_accessor :ops,
                    :filtered_additional_codes

      def initialize(workbasket_settings, step, ops = nil)
        @workbasket_settings = workbasket_settings
        @step = step
        @ops = if ops.present?
                 ops
               else
                 ActiveSupport::HashWithIndifferentAccess.new(
                   workbasket_settings.settings
                 )
               end
        @filtered_additional_codes = filter_additional_codes(ops['additional_codes']) || []
      end

      def additional_code_attributes(attributes)
        {
            additional_code_type_id: attributes['additional_code_type_id'],
            additional_code: attributes['additional_code'].upcase,
            validity_start_date: validity_start_date,
            validity_end_date: validity_end_date
        }
      end

      def additional_code_description_period_attributes(additional_code_sid, attributes)
        {
            additional_code_sid: additional_code_sid,
            additional_code_type_id: attributes['additional_code_type_id'],
            additional_code: attributes['additional_code'].upcase,
            validity_start_date: validity_start_date,
            validity_end_date: validity_end_date
        }
      end

      def additional_code_description_attributes(additional_code_description_period_sid, additional_code_sid, attributes)
        {
            additional_code_description_period_sid: additional_code_description_period_sid,
            language_id: 'EN',
            additional_code_sid: additional_code_sid,
            additional_code_type_id: attributes['additional_code_type_id'],
            additional_code: attributes['additional_code'].upcase,
            description: attributes['description']
        }
      end

      def meursing_additional_code_attributes(attributes)
        {
            additional_code: attributes['additional_code'].upcase,
            validity_start_date: validity_start_date,
            validity_end_date: validity_end_date
        }
      end

      def meursing?(attributes)
        AdditionalCodeType.find(additional_code_type_id: attributes['additional_code_type_id']).meursing?
      end

      def operation_date
        validity_start_date
      end

    private

      def filter_additional_codes(ops)
        if ops.present?
          ops.select do |_key, item|
            item['additional_code_type_id'].present? || item['additional_code'].present? || item['description'].present?
          end
        end
      end
    end
  end
end
