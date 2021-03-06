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

        update_additional_code_dates!(params) if validity_dates_changed?(params)

        if params['changes'].include?('description') && !meursing?(params)
          build_additional_code_description!(params)
        end
      end

      def validate!(params)
        return { validity_start_date: "Start date can't be blank!" } if params[:validity_start_date].blank?

        if params['changes'].include?('validity_end_date') && !meursing?(params)
          additional_code = update_additional_code!(params)
          ::WorkbasketValueObjects::Shared::ConformanceErrorsParser.new(
            additional_code,
              AdditionalCodeValidator,
              {}
          ).errors
        end
      end

    private

      def update_additional_code_dates!(params)
        @records << if meursing?(params)
                      update_meursing_additional_code!(params)
                    else
                      update_additional_code!(params)
                    end
      end

      def validity_dates_changed?(params)
        params['changes'].include?('validity_start_date') || params['changes'].include?('validity_end_date')
      end

      def meursing?(params)
        AdditionalCodeType.find(additional_code_type_id: params['type_id']).meursing?
      end

      def update_meursing_additional_code!(params)
        MeursingAdditionalCode.unrestrict_primary_key
        code = MeursingAdditionalCode.find(meursing_additional_code_sid: existing.additional_code_sid)

        assign_start_date(code, params)
        assign_end_date(code, params)
        ::WorkbasketValueObjects::Shared::SystemOpsAssigner.new(
          code, system_ops.merge(operation: "U")
        ).assign!(false)

        code.save
      end

      def update_additional_code!(params)
        AdditionalCode.unrestrict_primary_key
        code = AdditionalCode.find(additional_code_sid: existing.additional_code_sid)

        assign_start_date(code, params)
        assign_end_date(code, params)
        ::WorkbasketValueObjects::Shared::SystemOpsAssigner.new(
          code, system_ops.merge(operation: "U")
        ).assign!(false)

        code.save
      end

      def assign_start_date(code, params)
        code.validity_start_date = params['validity_start_date'] if params['changes'].include?('validity_start_date')
      end

      def assign_end_date(code, params)
        code.validity_end_date = operation_date if workbasket_item.deleted?
        code.validity_end_date = params['validity_end_date'] if params['changes'].include?('validity_end_date')
      end

      def description_periods
        AdditionalCodeDescriptionPeriod.where(additional_code_sid: existing.additional_code_sid).all
      end

      def existing_description_period_on_same_day(params)
        periods = description_periods.select do |period|
          period.validity_start_date.strftime('%d %b %Y') == params['additional_code_description']['validity_start_date']
        end
      end

      def build_additional_code_description!(params)
        AdditionalCodeDescription.unrestrict_primary_key
        AdditionalCodeDescriptionPeriod.unrestrict_primary_key

        existing_description_period_on_same_day = existing_description_period_on_same_day(params)

        unless existing_description_period_on_same_day.empty?
          update_description!(params, existing_description_period_on_same_day)
        else
          add_new_description_and_description_period!(params)
        end
      end

      def update_description!(params, existing_description_period_on_same_day)
        description = existing_description_period_on_same_day.first.additional_code_description
        description.description = params['additional_code_description']['description']

        ::WorkbasketValueObjects::Shared::SystemOpsAssigner.new(
          description, system_ops.merge(operation: "U")
        ).assign!
        description.save
      end

      def add_new_description_and_description_period!(params)
        description = existing.additional_code_description
        records = [
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
        records.each do |record|
          ::WorkbasketValueObjects::Shared::SystemOpsAssigner.new(
            record, system_ops
          ).assign!
          record.save
        end
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
