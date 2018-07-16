module Workbaskets
  module CreateMeasures
    class SettingsSaver

      FORM_STEPS = %w(main duties_conditions_footnotes)
      NEXT_STEP_POINTERS = %w(main duties_conditions_footnotes)
      PREVIOUS_STEP_POINTERS = %w(duties_conditions_footnotes review_and_submit)

      REQUIRED_PARAMS = {
        start_date: :validity_start_date,
        operation_date: :operation_date
      }

      MAIN_STEP_SETTINGS = %w(
        regulation_id
        start_date
        end_date
        measure_type_id
        workbasket_name
        operation_date
        commodity_codes
        commodity_codes_exclusions
        additional_codes
        reduction_indicator
        geographical_area_id
        excluded_geographical_areas
      )

      DUTIES_CONDITIONS_FOOTNOTES_STEP_SETTINGS = %w(
        measure_components
        conditions
        footnotes
      )

      attr_accessor :current_step,
                    :settings,
                    :workbasket,
                    :settings_params,
                    :errors,
                    :candidates_with_errors

      def initialize(workbasket, current_step, settings_ops={})
        @workbasket = workbasket
        @settings = workbasket.create_measures_settings

        @current_step = current_step
        @settings_params = ActiveSupport::HashWithIndifferentAccess.new(settings_ops)
        @errors = {}
        @candidates_with_errors = []
      end

      def save!
        workbasket.title = settings_params[:workbasket_name]
        workbasket.save

        settings.settings_jsonb = settings_params.to_json
        settings.save
      end

      def valid?
        check_required_params!
        return false if @errors.present?

        validate!
        candidates_with_errors.blank?
      end

      def success_ops
        ops = {}
        ops[:next_step] = true if next_step?

        ops
      end

      class << self
        def keys_for_step(step)
          const_get("#{step.upcase}_STEP_SETTINGS")
        end
      end

      private

        def next_step?
          FORM_STEPS.include?(current_step)
        end

        def check_required_params!
          REQUIRED_PARAMS.map do |k, v|
            if settings_params[k.to_s].blank?
              @errors[v.to_sym] = "#{k.to_s.capitalize.split('_').join(' ')} can't be blank!"
            end
          end

          if commodity_codes.blank? && additional_codes.blank?
            @errors[:commodity_codes] = errors_translator(:blank_commodity_and_additional_codes)
          end

          if commodity_codes.blank? && exceptions.present?
            @errors[:commodity_codes_exclusions] = errors_translator(:commodity_codes_exclusions)
          end
        end

        def validate!
          candidates.map do |code|
            record = validate_candidate!(code, validation_mode)

            if record.errors.present?
              @candidates_with_errors << [
                code: record.errors.full_messages
              ]
            end
          end
        end

        def validation_mode
          commodity_codes.present? ? :commodity_codes : :additional_codes
        end

        def validate_candidate!(code, mode)
          measure = Measure.new(
            measure_params(code, mode)
          )
          measure.measure_sid = Measure.max(:measure_sid).to_i + 1

          ::Measures::ValidationHelper.new(
            measure, {}
          ).measure
        end

        def candidates
          if commodity_codes.present?
            commodity_codes.split( /\r?\n/ )
          else
            additional_codes.split(",")
          end.map(&:strip)
        end

        def commodity_codes
          settings_params[:commodity_codes]
        end

        def exceptions
          list = settings_params[:commodity_codes_exclusions]
          list.present? ? list.split( /\r?\n/ ).map(&:strip) : []
        end

        def additional_codes
          settings_params[:additional_codes]
        end

        def measure_params(code, mode)
          ops = {
            start_date: settings_params[:start_date],
            end_date: settings_params[:end_date],
            regulation_id: settings_params[:regulation_id],
            measure_type_id: settings_params[:measure_type_id],
            reduction_indicator: settings_params[:reduction_indicator],
            geographical_area_id: settings_params[:geographical_area_id]
          }

          if mode == :commodity_codes
            ops[:goods_nomenclature_code] = code
          else
            ops[:additional_code] = code
          end

          ::Measures::AttributesNormalizer.new(
            ActiveSupport::HashWithIndifferentAccess.new(ops)
          ).normalized_params
        end

        def errors_translator(key)
          I18n.t(:create_measures)[:errors][key]
        end
    end
  end
end
