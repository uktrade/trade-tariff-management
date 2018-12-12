module Measures
  class BulkParamsConverter
    attr_accessor :existing_measure,
                  :ops

    def initialize(existing_measure, measure_ops)
      @existing_measure = existing_measure
      @ops = measure_ops
    end

    def converted_ops
      res = {}

      res[:start_date] = ops["validity_start_date"].to_date
      res[:end_date] = ops["validity_end_date"].try(:to_date) if ops["validity_end_date"] != "-"

      if ops["goods_nomenclature"].present?
        res[:goods_nomenclature_code] = ops["goods_nomenclature"]["goods_nomenclature_item_id"]
      end

      if ops["additional_code"].present?
        res[:additional_code] = ops["additional_code"]["additional_code"]
        res[:additional_code_type_id] = ops["additional_code"]["type_id"]
      end

      if ops["measure_type"].present?
        res[:measure_type_id] = ops["measure_type"]["measure_type_id"]
      end

      if ops["regulation"].present?
        res[:regulation_id] = if ops["regulation"]["base_regulation_id"].present?
                                ops["regulation"]["base_regulation_id"]

                              elsif ops["regulation"]["modification_regulation_id"].present?
                                ops["regulation"]["modification_regulation_id"]

                              elsif ops["regulation"]["regulation_id"].present?
                                ops["regulation"]["regulation_id"]
        end
      end

      if ops["geographical_area"].present?
        res[:geographical_area_id] = ops["geographical_area"]["geographical_area_id"]
      end

      res[:reduction_indicator] = existing_measure&.reduction_indicator || ops["reduction_indicator"]
      res[:quota_ordernumber] = existing_measure&.ordernumber || ops["order_number"]
      res[:export_refund_nomenclature_sid] = existing_measure&.export_refund_nomenclature_sid || ops["export_refund_nomenclature_sid"]

      ::Measures::AttributesNormalizer.new(
        ActiveSupport::HashWithIndifferentAccess.new(res)
      ).normalized_params
    end
  end
end
