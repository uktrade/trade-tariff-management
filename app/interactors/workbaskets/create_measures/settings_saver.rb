module Workbaskets
  module CreateMeasures
    class SettingsSaver < ::Workbaskets::SettingsSaverBase

      workbasket_type = "CreateMeasures"
      workbasket_type_prefix = "::Workbaskets::#{workbasket_type}"

      required_params = %w(
        start_date
        operation_date
      )

      attrs_parser_methods = %w(
        start_date
        end_date
        workbasket_name
        operation_date
        commodity_codes
        commodity_codes_exclusions
        additional_codes
        candidates
        measure_components
        conditions
        footnotes
        excluded_geographical_areas
      )

      associations_list = %w(
        measure_components
        conditions
        footnotes
        excluded_geographical_areas
      )

      def valid?
        check_required_params!

        if candidates.present?
          validate!
          candidates_with_errors.blank?
        end

        @errors.blank?
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

      private

        def check_required_params!
          general_errors = {}

          required_params.map do |k|
            if public_send(k).blank?
              general_errors[k.to_sym] = "#{k.to_s.capitalize.split('_').join(' ')} can't be blank!"
            end
          end

          if workbasket_name.blank?
            general_errors[:workbasket_name] = errors_translator(:blank_workbasket_name)
          end

          #
          # We have to disable some validations below, because these cases also are
          # covered by conformance rules.
          # However, we will probably return them back soon.
          #

          if candidates.blank?
            general_errors[:commodity_codes] = errors_translator(:blank_commodity_and_additional_codes)
          end

          if commodity_codes.blank? && commodity_codes_exclusions.present?
            general_errors[:commodity_codes_exclusions] = errors_translator(:commodity_codes_exclusions)
          end

          # if settings_params['start_date'].present? && (
          #     commodity_codes.present? ||
          #     additional_codes.present?
          #   ) && candidates.blank?

          #   @errors[:commodity_codes] = errors_translator(:commodity_codes_invalid)
          # end

          if general_errors.present?
            if step_pointer.main_step?
              general_errors.map do |k, v|
                @errors[k] = v
              end

            else
              @errors[:general] = general_errors
            end
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

          associations_list.map do |name|
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

        def assign_system_ops!(measure)
          system_ops_assigner = ::Workbaskets::Shared::SystemOpsAssigner.new(
            measure, system_ops
          )
          system_ops_assigner.assign!

          system_ops_assigner.record
        end
    end
  end
end
