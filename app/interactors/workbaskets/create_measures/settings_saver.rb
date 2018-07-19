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
      end

      def save!
        if step_pointer.main_step?
          workbasket.title = workbasket_name
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

      def success_ops
        ops = {}
        ops[:next_step] = step_pointer.next_step if step_pointer.has_next_step?

        ops
      end

      ATTRS_PARSER_METHODS.map do |option|
        define_method("#{option}") do
          attrs_parser.public_send(option)
        end
      end

      def summarized_errors
        res = {}

        errors[:measure].map do |k, v|
          res[k] = v
        end

        if errors[:footnotes].present?
          errors[:footnotes].map do |position, hash_of_errors|
            hash_of_errors.map do |k, v|
              res[k] = v
            end
          end
        end

        res
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

          if footnotes.present?
            f_errors = footnotes_errors(measure)
            errors_collection[:footnotes] = f_errors if f_errors.present?
          end

          errors_collection
        end

        def generate_new_measure!(code, mode)
          measure = Measure.new(
            attrs_parser.measure_params(code, mode)
          )

          measure.measure_sid = Measure.max(:measure_sid).to_i + 1
          measure
        end

        def measure_errors(measure)
          ::Measures::ConformanceErrorsParser.new(
            measure, MeasureValidator, {}
          ).errors
        end

        def footnotes_errors(measure)
          ::CreateMeasures::ValidationHelpers::Footnotes.errors_in_collection(
            measure, system_ops, footnotes
          )
        end

        def system_ops
          {
            operation_date: operation_date,
            current_admin: workbasket.user
          }
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
    end
  end
end
