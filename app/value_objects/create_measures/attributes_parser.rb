module CreateMeasures
  class AttributesParser

    SIMPLE_OPS = %w(
      operation_date
      workbasket_name
      commodity_codes
      additional_codes
    )

    attr_accessor :workbasket_settings,
                  :step,
                  :ops

    def initialize(workbasket_settings, step, ops)
      @workbasket_settings = workbasket_settings
      @step = step
      @ops = ops

      prepare_ops
    end

    SIMPLE_OPS.map do |option_name|
      define_method(option_name) do
        ops[option_name]
      end
    end

    def measure_components
      ops[:measure_components].select do |k, option|
        option[:duty_expression_id].present?
      end
    end

    def conditions
      ops[:conditions].select do |k, option|
        option[:condition_code].present?
      end
    end

    def footnotes
      ops[:footnotes].select do |k, option|
        option[:footnote_type_id].present?
      end
    end

    def commodity_codes_exclusions
      list = ops[:commodity_codes_exclusions]
      list.present? ? list.split( /\r?\n/ ).map(&:strip) : []
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
