module WorkbasketValueObjects
  class AttributesParserBase

    attr_accessor :workbasket_settings,
                  :codes_analyzer,
                  :step,
                  :ops

    def initialize(workbasket_settings, step, ops=nil)
      @workbasket_settings = workbasket_settings
      @step = step
      @ops = if ops.present?
        ops
      else
        ActiveSupport::HashWithIndifferentAccess.new(workbasket_settings.settings)
      end

      prepare_ops
      setup_code_analyzer
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

    def conditions
      prepare_collection(:conditions, :condition_code)
    end

    def footnotes
      prepare_collection(:footnotes, :footnote_type_id)
    end

    def excluded_geographical_areas
      if ops[:excluded_geographical_areas].present?
        ops[:excluded_geographical_areas].uniq
      else
        []
      end.reject { |i| i.blank? }
    end

    def commodity_codes_exclusions
      list = ops['commodity_codes_exclusions']
      list.present? ? list.split( /\r?\n/ ).map(&:strip) : []
    end

    def candidates
      codes_analyzer.try(:collection)
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

      def setup_code_analyzer
        if ops[:start_date].present?
          @codes_analyzer = ::WorkbasketValueObjects::Shared::CodesAnalyzer.new(
            start_date: ops[:start_date].to_date,
            commodity_codes: commodity_codes || [],
            additional_codes: additional_codes || [],
            commodity_codes_exclusions: commodity_codes_exclusions
          )
        end
      end

      def date_to_format(date)
        date.try(:to_date)
            .try(:strftime, "%d %B %Y")
      end

      def prepare_collection(namespace, key_option)
        if ops[namespace].present?
          ops[namespace].select do |k, option|
            option[key_option].present?
          end
        else
          []
        end
      end
  end
end
