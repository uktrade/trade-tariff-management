module WorkbasketInteractions
  module BulkEditOfAdditionalCodes
    class ItemSaver

      attr_accessor :workbasket_item,
                    :workbasket,
                    :operation_date,
                    :existing,
                    :additional_code

      def initialize(workbasket_item)
        @workbasket_item = workbasket_item
        @workbasket = workbasket_item.workbasket
        @operation_date = workbasket.operation_date.midnight
        @existing = workbasket_item.record
      end

      def persist!
        end_date_existing!

        unless workbasket_item.deleted?
          add_new_measure!
          add_duty_expressions!
          add_conditions!
          add_footnotes!
          add_excluded_geographical_areas!
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

      private

      def end_date_existing!
        existing.validity_end_date = if workbasket_item.deleted?
                                       operation_date
                                     else
                                       (operation_date - 1.day).midnight
                                     end

        ::WorkbasketValueObjects::Shared::SystemOpsAssigner.new(
            existing, system_ops.merge(operation: "U")
        ).assign!

        existing.save
      end

      def add_new_measure!
        @measure = Measure.new(
            ::AdditionalCodes::BulkParamsConverter.new(
                existing, measure_ops
            ).converted_ops
        )
        measure.validity_start_date = operation_date
        measure.measure_sid = Measure.max(:measure_sid).to_i + 1
        measure.original_measure_sid = existing.measure_sid

        set_oplog_attrs_and_save!(measure)
      end

      def add_duty_expressions!
        measure_components = measure_ops[:measure_components]

        if measure_components.present?
          ::WorkbasketServices::MeasureAssociationSavers::MeasureComponents.validate_and_persist!(
              measure,
              system_ops.merge(type_of: :measure_components),
              measure_components
          )
        end
      end

      def add_conditions!
        conditions = measure_ops[:measure_conditions]

        if conditions.present?
          ::WorkbasketServices::MeasureAssociationSavers::Conditions.validate_and_persist!(
              measure,
              system_ops.merge(type_of: :conditions),
              conditions
          )
        end
      end

      def add_footnotes!
        footnotes = measure_ops[:footnotes]

        if footnotes.present?
          ::WorkbasketServices::MeasureAssociationSavers::Footnotes.validate_and_persist!(
              measure,
              system_ops.merge(type_of: :footnotes),
              footnotes
          )
        end
      end

      def add_excluded_geographical_areas!
        excluded_geographical_areas = measure_ops[:excluded_geographical_areas]

        if excluded_geographical_areas.present?
          ::WorkbasketServices::MeasureAssociationSavers::ExcludedGeographicalAreas.validate_and_persist!(
              measure,
              system_ops.merge(type_of: :excluded_geographical_areas),
              excluded_geographical_areas
          )
        end
      end

      def measure_ops
        @measure_ops ||= ::WorkbasketInteractions::BulkEditOfMeasures::ItemOpsNormalizer.new(
            workbasket_item.hash_data
        ).normalized_ops
      end

      def set_oplog_attrs_and_save!(record)
        ::WorkbasketValueObjects::Shared::PrimaryKeyGenerator.new(record).assign!

        ::WorkbasketValueObjects::Shared::SystemOpsAssigner.new(
            record, system_ops
        ).assign!

        record.save
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
