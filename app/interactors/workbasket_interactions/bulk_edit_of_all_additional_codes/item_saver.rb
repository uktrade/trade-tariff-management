module WorkbasketInteractions
  module BulkEditOfAllAdditionalCodes
    class ItemSaver
      attr_accessor :workbasket_item,
                    :workbasket,
                    :operation_date,
                    :existing

      def initialize(workbasket_item)
        @workbasket_item = workbasket_item
        @workbasket = workbasket_item.workbasket
        @operation_date = workbasket.operation_date.try(:midnight)
        @existing = workbasket_item.record
        @records = []
      end

      def persist!
        params = workbasket_item.hash_data

        if workbasket_item.deleted?
          params['validity_end_date'] = operation_date
        end

        if params['changes'].include?('validity_end_date') || workbasket_item.deleted?
          @records << if meursing?(params)
                        build_meursing_additional_code!(params)
                      else
                        build_additional_code!(params)
                      end
        end

        if params['changes'].include?('description') && !meursing?(params)
          @records = @records + build_additional_code_description!(params)
        end

        @records.each do |record|
          ::WorkbasketValueObjects::Shared::SystemOpsAssigner.new(
            record, system_ops
          ).assign!
          record.save
        end
      end

      def validate!(params)
        return { validity_start_date: "Start date can't be blank!" } if params[:validity_start_date].blank?

        if params['changes'].include?('validity_end_date') && !meursing?(params)
          additional_code = build_additional_code!(params)
          ::WorkbasketValueObjects::Shared::ConformanceErrorsParser.new(
            additional_code,
              AdditionalCodeValidator,
              {}
          ).errors
        end
      end

    private

      def meursing?(params)
        AdditionalCodeType.find(additional_code_type_id: params['type_id']).meursing?
      end

      def build_meursing_additional_code!(params)
        MeursingAdditionalCode.unrestrict_primary_key
        MeursingAdditionalCode.new(
          meursing_additional_code_sid: existing.additional_code_sid,
          additional_code: existing.additional_code,
          validity_start_date: params['validity_start_date'].to_date,
          validity_end_date: params['validity_end_date'].blank? || params['validity_end_date'] == '-' ? nil : params['validity_end_date'].to_date
        )
      end

      def build_additional_code!(params)
        AdditionalCode.unrestrict_primary_key
        AdditionalCode.new(
          additional_code_sid: existing.additional_code_sid,
          additional_code_type_id: existing.additional_code_type_id,
          additional_code: existing.additional_code,
          validity_start_date: params['validity_start_date'].to_date,
          validity_end_date: params['validity_end_date'].blank? || params['validity_end_date'] == '-' ? nil : params['validity_end_date'].to_date
)
      end

      def build_additional_code_description!(params)
        AdditionalCodeDescription.unrestrict_primary_key
        AdditionalCodeDescriptionPeriod.unrestrict_primary_key
        description = existing.additional_code_description
        [
            AdditionalCodeDescription.new(
              additional_code_description_period_sid: description.additional_code_description_period_sid,
              additional_code_sid: description.additional_code_sid,
              additional_code_type_id: description.additional_code_type_id,
              additional_code: description.additional_code,
              language_id: description.language_id,
              description: params['additional_code_description']['description']
),
            AdditionalCodeDescriptionPeriod.new(
              additional_code_description_period_sid: description.additional_code_description_period_sid,
              additional_code_sid: description.additional_code_sid,
              additional_code_type_id: description.additional_code_type_id,
              additional_code: description.additional_code,
              validity_start_date: params['additional_code_description']['validity_start_date'].to_date
)
        ]
      end

      def system_ops
        {
            operation_date: operation_date,
            current_admin_id: workbasket.user_id,
            workbasket_id: workbasket.id,
            status: "awaiting_cross_check"
        }
      end
    end
  end
end
