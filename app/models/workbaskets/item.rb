module Workbaskets
  class Item < Sequel::Model(:workbasket_items)

    STATES = [
      :in_progress,
      :submitted,
      :rejected
    ]

    plugin :timestamps

    many_to_one :workbasket, key: :workbasket_id,
                             foreign_key: :id

    validates do
      presence_of :status,
                  :workbasket_id,
                  :record_id,
                  :record_key,
                  :record_type

      inclusion_of :status, in: STATES.map(&:to_s)

      uniqueness_of [
        :workbasket_id,
        :record_id,
        :record_key,
        :record_type
      ]
    end

    dataset_module do
      def by_workbasket(workbasket)
        where(workbasket_id: workbasket.id)
      end

      def by_id_asc
        order(Sequel.asc(:id))
      end

      include ::BulkEditHelpers::OrderByIdsQuery
    end

    def new_data_parsed
      @new_data_parsed ||= JSON.parse(new_data)
    end

    def original_data_parsed
      @original_data_parsed ||= JSON.parse(original_data)
    end

    def hash_data
      data = new_data_parsed.present? ? new_data_parsed : original_data_parsed

      if validation_errors_parsed.present?
        data["errored_columns"] = validation_errors_parsed
      end

      if changed_values_parsed.present?
        data["changed_columns"] = changed_values_parsed
      end

      data
    end

    def persist!
      ::WorkbasketInteractions::BulkEditOfMeasures::ItemSaver.new(self).persist!
    end

    def deleted?
      new_data_parsed['deleted'].present?
    end

    def validation_errors_parsed
      @validation_errors_parsed ||= JSON.parse(validation_errors)
    end

    def changed_values_parsed
      @changed_values_parsed ||= JSON.parse(changed_values)
    end

    def record
      record_type.constantize
                 .where(record_key.to_sym => record_id)
                 .first
    end

    def validate_measure!(measure_params={})
      return { validity_start_date: "Start date can't be blank!" } if measure_params[:validity_start_date].blank?

      errors = {}

      measure = Measure.new(
        ::Measures::BulkParamsConverter.new(
          record, measure_params
        ).converted_ops
      )

      measure.measure_sid = Measure.max(:measure_sid).to_i + 1
      measure.updating_measure = record

      ::WorkbasketValueObjects::Shared::ConformanceErrorsParser.new(
        measure, MeasureValidator, {}
      ).errors
    end

    def error_details(errored_column)
      errors_detected = validate_measure!(
        ActiveSupport::HashWithIndifferentAccess.new(
          hash_data
        )
      )

      errors_detected.values
                     .flatten
    end

    class << self
      def create_from_target_record(workbasket, target_record)
        item = new(workbasket_id: workbasket.id)

        key = target_record.primary_key
        item.record_key = key
        item.record_id = target_record.public_send(key)
        item.record_type = target_record.class.to_s
        item.original_data = target_record.to_json.to_json
        item.status = "in_progress"

        item.save
      end
    end
  end
end
