module WorkbasketInteractions
  module BulkEditOfAdditionalCodes
    class ItemSaver

      attr_accessor :workbasket_item,
                    :workbasket,
                    :operation_date,
                    :existing

      def initialize(workbasket_item)
        @workbasket_item = workbasket_item
        @workbasket = workbasket_item.workbasket
        @operation_date = workbasket.operation_date.midnight
        @existing = workbasket_item.record
        @records = []
      end

      def persist!
        params = workbasket_item.hash_data
        params[:validity_end_date] = operation_date if workbasket_item.deleted?

        if params[:validity_end_date].present?
          @records << build_additional_code!(params)
        end

        if params[:description].present?
          @records = records + build_additional_code_description!(params)
        end

        records.each do |record|
          ::WorkbasketValueObjects::Shared::SystemOpsAssigner.new(
              record, system_ops
          ).assign!
          record.save
        end
      end

      def validate!(params)
        return {validity_start_date: "Start date can't be blank!"} if params[:validity_start_date].blank?

        if params[:validity_end_date].present?
          additional_code = build_additional_code!(params)
          ::WorkbasketValueObjects::Shared::ConformanceErrorsParser.new(
              additional_code,
              AdditionalCodeValidator,
              {}
          ).errors
        end
      end

      private

      def build_additional_code!(params)
        AdditionalCode.new(
            {
                additional_code_sid: existing.additional_code_sid,
                additional_code_type_id: existing.additional_code_type_id,
                additional_code: existing.additional_code,
                validity_start_date: params[:validity_start_date],
                validity_end_date: params[:validity_end_date]
            })
      end

      def build_additional_code_description!(params)
        description = existing.additional_code_description
        [
            AdditionalCodeDescription.new(
                {
                    additional_code_description_period_sid: description.additional_code_description_period_sid,
                    additional_code_sid: description.additional_code_sid,
                    additional_code_type_id: description.additional_code_type_id,
                    additional_code: description.additional_code,
                    language_id: description.language_id,
                    description: params[:description]
                }),
            AdditionalCodeDescriptionPeriod.new(
                {
                    additional_code_description_period_sid: description.additional_code_description_period_sid,
                    additional_code_sid: description.additional_code_sid,
                    additional_code_type_id: description.additional_code_type_id,
                    additional_code: description.additional_code,
                    validity_start_date: params[:validity_start_date],
                    validity_end_date: params[:validity_end_date]
                })
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
