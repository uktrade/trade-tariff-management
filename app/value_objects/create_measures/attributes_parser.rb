module CreateMeasures
  class AttributesParser

    attr_accessor :workbasket_settings,
                  :step,
                  :ops

    def initialize(workbasket_settings, step, ops)
      @workbasket_settings = workbasket_settings
      @step = step
      @ops = ops

      prepare_ops
    end

    def workbasket_name
      ops[:workbasket_name]
    end

    def commodity_codes
      ops[:commodity_codes]
    end

    def commodity_codes_exclusions
      list = ops[:commodity_codes_exclusions]
      list.present? ? list.split( /\r?\n/ ).map(&:strip) : []
    end

    def additional_codes
      ops[:additional_codes]
    end

    def candidates
      if commodity_codes.present?
        commodity_codes.split( /\r?\n/ )
      else
        additional_codes.split(",")
      end.map(&:strip)
    end

    def measure_params(code, mode)
      res = {
        start_date: ops[:start_date],
        end_date: ops[:end_date],
        regulation_id: ops[:regulation_id],
        measure_type_id: ops[:measure_type_id],
        reduction_indicator: ops[:reduction_indicator],
        geographical_area_id: ops[:geographical_area_id]
      }

      if mode == :commodity_codes
        res[:goods_nomenclature_code] = code
      else
        res[:additional_code] = code
      end

      ::Measures::AttributesNormalizer.new(
        ActiveSupport::HashWithIndifferentAccess.new(res)
      ).normalized_params
    end

    private

      def prepare_ops
        if step == "duties_conditions_footnotes"
          @ops = ops.merge(workbasket_settings.main_step_settings)
        end
      end
  end
end
