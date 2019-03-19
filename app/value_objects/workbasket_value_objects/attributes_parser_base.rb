module WorkbasketValueObjects
  class AttributesParserBase
    attr_accessor :workbasket_settings,
                  :step,
                  :ops

    def initialize(workbasket_settings, step, ops = nil)
      @workbasket_settings = workbasket_settings
      @step = step
      @ops = if ops.present?
               ops
             else
               ActiveSupport::HashWithIndifferentAccess.new(workbasket_settings.settings)
      end

      prepare_ops # Implemented in base class
      setup_commodity_code_analyzer
      setup_additional_code_analyzer
    end

    def measure_params(variable_params)
      res = {
        start_date: @start_date || ops[:start_date],
        end_date: @end_date || ops[:end_date],
        regulation_id: ops[:regulation_id],
        measure_type_id: ops[:measure_type_id],
        reduction_indicator: ops[:reduction_indicator],
        geographical_area_id: variable_params[:geographical_area_id],
        quota_ordernumber: @quota_order_number || ops[:quota_ordernumber],
        goods_nomenclature_code: variable_params[:goods_nomenclature_code],
        additional_code: variable_params[:additional_code]
      }

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

    def measure_components
      if @measure_components.present?
        @measure_components
      else
        prepare_collection(:measure_components, :duty_expression_id)
      end
    end

    def geographical_area_id
      ops[:geographical_area_id]
    end

    def excluded_geographical_areas
      if ops[:excluded_geographical_areas].present?
        ops[:excluded_geographical_areas].uniq
      else
        []
      end.reject(&:blank?)
    end

    def commodity_codes_exclusions
      list = ops['commodity_codes_exclusions']
      list.present? ? list.split(/[\s|,]+/)
                          .map(&:strip)
                          .reject(&:blank?)
                          .uniq : []
    end

    def entered_exception_codes
      ops['commodity_codes_exclusions']
    end


    def candidates
      a_codes = @additional_codes_analyzer.collection
      gn_codes = @commodity_codes_analyzer.collection

      if gn_codes.blank?
        gn_codes = [nil]
      end

      if a_codes.blank?
        a_codes = [nil]
      end

      # Return a list of GN codes and additional codes and origin codes, allowing for empty arrays
      gn_codes.map do |goods_nomenclature_code|
        a_codes.map do |additional_code|
          Array.wrap(ops['geographical_area_id']).map do |geographical_area_id|
            {
                goods_nomenclature_code: goods_nomenclature_code,
                additional_code: additional_code,
                geographical_area_id: geographical_area_id
            }
          end
        end
      end.flatten
    end

    begin :decoration_methods
          def regulation
            regulation_id = ops[:regulation_id]

            regulation = BaseRegulation.not_replaced_and_partially_replaced
                                       .actual_or_starts_in_future
                                       .where(base_regulation_id: regulation_id).first

            if regulation.blank?
              regulation = ModificationRegulation.not_replaced_and_partially_replaced
                                                 .actual_or_starts_in_future
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
            @commodity_codes_analyzer.commodity_codes_formatted
          end

          def exclusions_formatted
            @commodity_codes_analyzer.exclusions_formatted
          end

          def additional_codes_formatted
            @additional_codes_analyzer.additional_codes_formatted
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

          def date_to_format(date)
            date.try(:to_date)
                .try(:strftime, "%d %B %Y")
          end
    end

  private

    def setup_commodity_code_analyzer
      @commodity_codes_analyzer = ::WorkbasketValueObjects::Shared::CommodityCodesAnalyzer.new(
        start_date: ops[:start_date],
        commodity_codes: commodity_codes || [],
        commodity_codes_exclusions: commodity_codes_exclusions
      )
    end

    def setup_additional_code_analyzer
      @additional_codes_analyzer = ::WorkbasketValueObjects::Shared::AdditionalCodesAnalyzer.new(
        start_date: ops[:start_date],
        additional_codes: additional_codes || []
      )
    end

    def prepare_collection(namespace, key_option)
      if ops[namespace].present?
        ops[namespace].select do |_k, option|
          option[key_option].present?
        end
      else
        []
      end
    end
  end
end
