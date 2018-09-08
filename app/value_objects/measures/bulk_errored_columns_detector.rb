module Measures
  class BulkErroredColumnsDetector

    MATCH_TABLE = {
      regulation: [
        :measure_generating_regulation_role,
        :measure_generating_regulation_id,
        :justification_regulation_role,
        :justification_regulation_id
      ],
      measure_type_id: [
        :measure_type_id
      ],
      validity_start_date: [
        :validity_start_date
      ],
      validity_end_date: [
        :validity_end_date
      ],
      goods_nomenclature: [
        :goods_nomenclature_item_id,
        :goods_nomenclature_sid
      ],
      additional_code: [
        :additional_code_sid,
        :additional_code_type_id,
        :additional_code_id
      ],
      geographical_area: [
        :geographical_area_id,
        :geographical_area_sid
      ]
    }

    attr_accessor :errors

    def initialize(errors)
      @errors = errors
    end

    def errored_columns
      errors.keys.map do |key|
        if key.is_a?(Array)
          key.map do |k|
            detect_errored_column(k)
          end
        else
          detect_errored_column(key)
        end
      end.flatten
         .uniq
         .reject { |el| el.blank? }
    end

    private

      def detect_errored_column(key)
        res = MATCH_TABLE.select do |k, v|
          v.detect do |f_name|
            f_name.to_s == key.to_s
          end
        end.keys
           .first
           .to_s

        res.present? ? res : "measure_sid"
      end
  end
end
