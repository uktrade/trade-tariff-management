module Workbaskets
  module CreateMeasures
    class SettingsSaver

      REQUIRED_PARAMS = %w(
        start_date
        operation_date
      )

      ATTRS_PARSER_METHODS = %w(
        workbasket_name
        operation_date
        commodity_codes
        commodity_codes_exclusions
        additional_codes
        candidates
        measure_components
        conditions
        footnotes
      )

      attr_accessor :current_step,
                    :settings,
                    :workbasket,
                    :settings_params,
                    :step_pointer,
                    :attrs_parser,
                    :errors,
                    :candidates_with_errors

      def initialize(workbasket, current_step, settings_ops={})
        @workbasket = workbasket
        @current_step = current_step
        @settings = workbasket.create_measures_settings
        @settings_params = ActiveSupport::HashWithIndifferentAccess.new(settings_ops)

        @step_pointer = ::CreateMeasures::StepPointer.new(current_step)
        @attrs_parser = ::CreateMeasures::AttributesParser.new(
          settings,
          current_step,
          settings_params
        )
        @errors = {}
        @candidates_with_errors = {}

        clear_cached_sequence_number!
      end

      def save!
        if step_pointer.main_step?
          workbasket.title = workbasket_name
          workbasket.operation_date = operation_date.try(:to_date)
          workbasket.save
        end

        settings.set_settings_for!(
          current_step,
          step_pointer.step_settings(settings_params)
        )
      end

      def valid?
        if step_pointer.main_step?
          check_required_params!
          return false if @errors.present?
        end

        validate!
        candidates_with_errors.blank?
      end

      def persist!
        @persist = true
        @measure_sids = []

        validate!

        settings.measure_sids_jsonb = @measure_sids.to_json

        if settings.save
          settings.set_searchable_data_for_created_measures!
        end
      end

      def success_ops
        ops = {}
        ops[:next_step] = step_pointer.next_step if step_pointer.has_next_step?

        ops
      end

      ATTRS_PARSER_METHODS.map do |option|
        define_method(option) do
          attrs_parser.public_send(option)
        end
      end

      private

        def check_required_params!
          REQUIRED_PARAMS.map do |k|
            if settings_params[k.to_s].blank?
              @errors[k.to_sym] = "#{k.to_s.capitalize.split('_').join(' ')} can't be blank!"
            end
          end

          if workbasket_name.blank?
            @errors[:workbasket_name] = errors_translator(:blank_workbasket_name)
          end

          if commodity_codes.blank? && additional_codes.blank?
            @errors[:commodity_codes] = errors_translator(:blank_commodity_and_additional_codes)
          end

          if commodity_codes.blank? && commodity_codes_exclusions.present?
            @errors[:commodity_codes_exclusions] = errors_translator(:commodity_codes_exclusions)
          end

          if settings_params['start_date'].present? && (
              commodity_codes.present? ||
              additional_codes.present?
            ) && candidates.blank?

            @errors[:commodity_codes] = errors_translator(:commodity_codes_invalid)
          end
        end

        def validate!
          validate_candidates!
          get_unique_errors_from_candidates!
        end

        def validate_candidates!
          candidates.map do |code|
            candidate_errors = candidate_validation_errors(code, validation_mode)

            if candidate_errors.present?
              @candidates_with_errors[code.to_s] = candidate_errors
            end
          end
        end

        def validation_mode
          commodity_codes.present? ? :commodity_codes : :additional_codes
        end

        def candidate_validation_errors(code, mode)
          errors_collection = {}

          measure = generate_new_measure!(code, mode)

          m_errors = measure_errors(measure)
          errors_collection[:measure] = m_errors if m_errors.present?

          ::CreateMeasures::StepPointer::DUTIES_CONDITIONS_FOOTNOTES_STEP_SETTINGS.map do |name|
            if public_send(name).present?
              association_errors = send("#{name}_errors", measure)
              errors_collection[name] = association_errors if association_errors.present?
            end
          end

          errors_collection
        end

        def generate_new_measure!(code, mode)
          measure = Measure.new(
            attrs_parser.measure_params(code, mode)
          )
          measure.measure_sid = Measure.max(:measure_sid).to_i + 1

          if @persist.present?
            measure = assign_system_ops!(measure)
            measure.save
            @measure_sids << measure.measure_sid

            Measure.where(measure_sid: measure.measure_sid)
                   .first
          else
            measure
          end
        end

        def measure_errors(measure)
          ::Measures::ConformanceErrorsParser.new(
            measure, MeasureValidator, {}
          ).errors
        end

        ::CreateMeasures::StepPointer::DUTIES_CONDITIONS_FOOTNOTES_STEP_SETTINGS.map do |name|
          define_method("#{name}_errors") do |measure|
            klass_name = name.split("_").map(&:capitalize).join('')

            "CreateMeasures::ValidationHelpers::#{klass_name}".constantize.errors_in_collection(
              measure, system_ops, public_send(name)
            )
          end
        end

        def assign_system_ops!(measure)
          system_ops_assigner = ::CreateMeasures::ValidationHelpers::SystemOpsAssigner.new(
            measure, system_ops
          )
          system_ops_assigner.assign!

          system_ops_assigner.record
        end

        def system_ops
          {
            workbasket_id: workbasket.id,
            operation_date: operation_date,
            current_admin_id: current_admin.id
          }
        end

        def current_admin
          workbasket.user
        end

        def get_unique_errors_from_candidates!
          summarizer = ::CreateMeasures::ValidationHelpers::CandidatesValidationsSummarizer.new(
            current_step, candidates_with_errors
          )
          summarizer.summarize!

          summarizer.errors.map do |k, v|
            @errors[k] = v
          end
        end

        def errors_translator(key)
          I18n.t(:create_measures)[:errors][key]
        end

        def clear_cached_sequence_number!
          Rails.cache.delete("#{workbasket_id}_sequence_number")
        end
    end
  end
end
