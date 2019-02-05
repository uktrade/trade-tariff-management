module WorkbasketInteractions
  module CreateMeasures
    class SettingsSaver
      WORKBASKET_TYPE = "CreateMeasures".freeze
      REQUIRED_PARAMS = %w(
        start_date
      ).freeze

      ATTRS_PARSER_METHODS = %w(
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
      ).freeze

      ASSOCIATION_LIST = %w(
        measure_components
        conditions
        footnotes
        excluded_geographical_areas
      ).freeze

      attr_accessor :current_step,
                    :save_mode,
                    :settings,
                    :workbasket,
                    :settings_params,
                    :step_pointer,
                    :attrs_parser,
                    :errors,
                    :candidates_with_errors

      def initialize(workbasket, current_step, save_mode, settings_ops = {})
        @workbasket = workbasket
        @save_mode = save_mode
        @current_step = current_step
        @settings = workbasket.settings
        @settings_params = ActiveSupport::HashWithIndifferentAccess.new(settings_ops)

        setup_system_pointers!
        clear_cached_sequence_number!
      end

      def valid?
        check_required_params!

        if @errors.blank? && candidates.present?
          validate!
          candidates_with_errors.blank?
        end

        @errors.blank?
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

      def persist!
        @persist = true
        @do_not_rollback_transactions = true
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

      ASSOCIATION_LIST.map do |name|
        define_method("#{name}_errors") do |measure|
          get_association_errors(name, measure)
        end
      end

      def check_required_params!
        general_errors = {}

        REQUIRED_PARAMS.map do |k|
          if public_send(k).blank?
            general_errors[k.to_sym] = "#{k.to_s.capitalize.split('_').join(' ')} can't be blank!"
          end
        end

        if workbasket_name.blank?
          general_errors[:workbasket_name] = errors_translator(:blank_workbasket_name)
        end

        if candidates.flatten.compact.blank?
          general_errors[:commodity_codes] = errors_translator(:blank_commodity_and_additional_codes)
        end

        if commodity_codes.blank? && commodity_codes_exclusions.present?
          general_errors[:commodity_codes_exclusions] = errors_translator(:commodity_codes_exclusions)
        end

        if commodity_codes.present?
          invalid_commodity_codes = get_invalid_commodity_codes(CodeParsingService.csv_string_to_array(commodity_codes))
          if invalid_commodity_codes.present?
            general_errors[:commodity_codes] = "The following commodity codes are incorrect, please check: #{invalid_commodity_codes}"
          end
        end

        if commodity_codes_exclusions.present?
          invalid_commodity_codes = get_invalid_commodity_codes(commodity_codes_exclusions)
          if invalid_commodity_codes.present?
            general_errors[:exclusion_commodity_codes] = "The following Exception commodity codes are incorrect, please check: #{invalid_commodity_codes}"
          end
        end

        if additional_codes.present?
          invalid_additional_codes = get_invalid_additional_codes(CodeParsingService.csv_string_to_array(additional_codes))
          if invalid_additional_codes.present?
            general_errors[:additional_codes] = "The following additional codes are incorrect, please check: #{invalid_additional_codes}"
          end
        end

        if settings_params['start_date'].present? && (
            commodity_codes.present? ||
            additional_codes.present?
          ) && candidates.flatten.compact.blank?

          @errors[:commodity_codes] = errors_translator(:commodity_codes_invalid)
        end

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
        @persist = true
        @measure_sids = []

        Sequel::Model.db.transaction(@do_not_rollback_transactions.present? ? {} : { rollback: :always }) do
          validate_candidates!
        end

        get_unique_errors_from_candidates!
      end

      def validate_candidates!
        candidates.map do |gn_and_additional_codes|
          candidate_errors = candidate_validation_errors(gn_and_additional_codes)

          if candidate_errors.present?
            @candidates_with_errors[gn_and_additional_codes.to_s] = candidate_errors
          end
        end
      end

      def current_admin
        workbasket.user
      end

      def get_unique_errors_from_candidates!
        summarizer = ::WorkbasketValueObjects::Shared::CandidatesValidationsSummarizer.new(
          current_step, candidates_with_errors
        )
        summarizer.summarize!

        summarizer.errors.map do |k, v|
          @errors[k] = v
        end
      end

      def errors_translator(key)
        I18n.t(
          self.class::WORKBASKET_TYPE.titleize
                                     .tr(' ', '_')
                                     .downcase
        )[:errors][key]
      end

      def setup_system_pointers!
        @step_pointer = "#{workbasket_type_prefix}::StepPointer".constantize.new(current_step)
        @attrs_parser = "#{workbasket_type_prefix}::AttributesParser".constantize.new(
          settings,
          current_step,
          settings_params
        )
        @errors = {}
        @candidates_with_errors = {}
      end

      def clear_cached_sequence_number!
        Rails.cache.delete("#{workbasket.id}_sequence_number")
      end

      begin :measures_related_methods
            def candidate_validation_errors(gn_and_additional_codes)
              errors_collection = {}

              measure = generate_new_measure!(gn_and_additional_codes)

              m_errors = measure_errors(measure)
              errors_collection[:measure] = m_errors if m_errors.present?

              ASSOCIATION_LIST.map do |name|
                if public_send(name).present?
                  association_errors = send("#{name}_errors", measure)
                  errors_collection[name] = association_errors if association_errors.present?
                end
              end

              errors_collection
            end

            def get_association_errors(name, measure)
              klass_name = name.split("_").map(&:capitalize).join('')

              "::WorkbasketServices::MeasureAssociationSavers::#{klass_name}".constantize.errors_in_collection(
                measure, system_ops.merge(type_of: name), public_send(name)
              )
            end

            def get_invalid_commodity_codes(codes)
              codes.reject do |code|
                GoodsNomenclature.by_code(code).declarable.first.present?
              end
            end

            def get_invalid_additional_codes(additional_codes)
              additional_codes.reject do |code|
                AllAdditionalCode.by_code(code).present?
              end
            end

            def generate_new_measure!(gn_and_additional_codes)
              measure = Measure.new(
                attrs_parser.measure_params(gn_and_additional_codes)
              )

              measure.measure_sid = Measure.max(:measure_sid).to_i + 1
              if measure.measure_type_id.present?
                measure_type = MeasureType.where(measure_type_id: measure.measure_type_id).first
                measure.measure_type = measure_type
              end

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
              ::WorkbasketValueObjects::Shared::ConformanceErrorsParser.new(
                measure, MeasureValidator, {}
              ).errors
            end

            def system_ops
              {
                workbasket_id: workbasket.id,
                operation_date: operation_date,
                current_admin_id: current_admin.id
              }
            end

            def assign_system_ops!(measure)
              system_ops_assigner = ::WorkbasketValueObjects::Shared::SystemOpsAssigner.new(
                measure, system_ops
              )
              system_ops_assigner.assign!

              system_ops_assigner.record
            end

            def workbasket_type_prefix
              "::WorkbasketValueObjects::#{self.class::WORKBASKET_TYPE}"
            end
      end
    end
  end
end
