module CreateMeasures
  class AttributesParser

    SIMPLE_OPS = %w(
      operation_date
      workbasket_name
      commodity_codes
      additional_codes
    )

    attr_accessor :workbasket_settings,
                  :codes_analyzer,
                  :step,
                  :ops

    def initialize(workbasket_settings, step, ops=nil)
      @workbasket_settings = workbasket_settings
      @step = step
      @ops = ops.present? ? ops : workbasket_settings.settings
      prepare_ops

      @codes_analyzer = ::CreateMeasures::CodesAnalyzer.new(
        start_date: ops[:start_date].to_date,
        commodity_codes: commodity_codes,
        additional_codes: additional_codes,
        commodity_codes_exclusions: commodity_codes_exclusions
      )
    end

    SIMPLE_OPS.map do |option_name|
      define_method(option_name) do
        ops[option_name]
      end
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

    def measure_components
      if ops[:measure_components].present?
        ops[:measure_components].select do |k, option|
          option[:duty_expression_id].present?
        end
      else
        []
      end
    end

    def conditions
      if ops[:conditions].present?
        ops[:conditions].select do |k, option|
          option[:condition_code].present?
        end
      else
        []
      end
    end

    def footnotes
      if ops[:footnotes].present?
        ops[:footnotes].select do |k, option|
          option[:footnote_type_id].present?
        end
      else
        []
      end
    end

    def commodity_codes_exclusions
      list = ops['commodity_codes_exclusions']
      list.present? ? list.split( /\r?\n/ ).map(&:strip) : []
    end

    def candidates
      codes_analyzer.collection
    end

    begin :decoration_methods
      def regulation
        regulation_id = ops[:regulation_id]

        regulation = BaseRegulation.actual
                                   .not_replaced_and_partially_replaced
                                   .where(base_regulation_id: regulation_id).first

        if regulation.blank?
          regulation = ModificationRegulation.actual
                                             .not_replaced_and_partially_replaced
                                             .where(modification_regulation_id: regulation_id).first
        end

        regulation.formatted_id
      end

      def operation_date_formatted
        date_to_format(ops[:operation_date])
      end

      def start_date_formatted
        date_to_format(ops[:start_date])
      end

      def end_date_formatted
        ops[:end_date].present? ? date_to_format(ops[:end_date]) : "-"
      end

      def measure_type
        MeasureType.by_measure_type_id(ops[:measure_type_id])
                   .first
                   .description
      end

      def commodity_codes_formatted
        codes_analyzer.commodity_codes_formatted
      end

      def exclusions_formatted
        codes_analyzer.exclusions_formatted
      end

      def additional_codes_formatted
        codes_analyzer.additional_codes_formatted
      end

      def origin
        id = ops[:geographical_area_id]
        desc = GeographicalArea.actual
                               .where(geographical_area_id: id)
                               .first
                               .description

        "#{desc} (#{id})"
      end

      def origin_exceptions
        areas = ops[:excluded_geographical_areas]
        areas.present? ? areas.join(", ") : "-"
      end
    end

    private

      def prepare_ops
        if step == "duties_conditions_footnotes"
          @ops = ops.merge(workbasket_settings.main_step_settings)
        end
      end

      def date_to_format(date)
        date.strftime("%d %B %Y")
      end
  end
end
