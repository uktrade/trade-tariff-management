module WorkbasketInteractions
  module EditFootnote
    class SettingsSaver

      include ::WorkbasketHelpers::SettingsSaverHelperMethods

      ATTRS_PARSER_METHODS = %w(
        reason_for_changes
        operation_date
        description
        description_validity_start_date
        validity_start_date
        validity_end_date
        commodity_codes
        measure_sids
      )

      attr_accessor :current_step,
                    :save_mode,
                    :settings,
                    :workbasket,
                    :settings_params,
                    :errors,
                    :conformance_errors,
                    :errors_summary,
                    :attrs_parser,
                    :initial_validator,
                    :original_footnote,
                    :footnote,
                    :footnote_description,
                    :footnote_description_period,
                    :persist

      def initialize(workbasket, current_step, save_mode, settings_ops={})
        @workbasket = workbasket
        @save_mode = save_mode
        @current_step = current_step
        @settings = workbasket.settings
        @original_footnote = settings.original_footnote.decorate
        @settings_params = ActiveSupport::HashWithIndifferentAccess.new(settings_ops)

        setup_attrs_parser!
        clear_cached_sequence_number!

        @persist = true # For now it always true
        @errors = {}
        @conformance_errors = {}
      end

      def save!
        workbasket.title = original_footnote.title
        workbasket.operation_date = operation_date
        workbasket.save

        settings.set_settings_for!(current_step, settings_params)
      end

      def valid?
        validate!
        errors.blank? && conformance_errors.blank?
      end

      def persist!
        @do_not_rollback_transactions = true
        validate!
      end

      def success_ops
        {}
      end

      ATTRS_PARSER_METHODS.map do |option|
        define_method(option) do
          attrs_parser.public_send(option)
        end
      end

      private

        def validate!
          check_initial_validation_rules!
          check_conformance_rules! if @errors.blank?
        end

        def check_initial_validation_rules!
          @initial_validator = ::WorkbasketInteractions::EditFootnote::InitialValidator.new(
            original_footnote, settings_params
          )

          @errors = initial_validator.fetch_errors
          @errors_summary = initial_validator.errors_summary
        end

        def check_conformance_rules!
          Sequel::Model.db.transaction(@do_not_rollback_transactions.present? ? {} : { rollback: :always }) do
            end_date_existing_footnote! if @do_not_rollback_transactions.present?

            add_footnote!
            add_footnote_description_period!
            add_footnote_description!

            parse_and_format_conformance_rules
          end
        end

        def parse_and_format_conformance_rules
          @conformance_errors = {}

          unless footnote.conformant?
            @conformance_errors.merge!(get_conformance_errors(footnote))
          end

          unless footnote_description_period.conformant?
            @conformance_errors.merge!(get_conformance_errors(footnote_description_period))
          end

          unless footnote_description.conformant?
            @conformance_errors.merge!(get_conformance_errors(footnote_description))
          end

          if conformance_errors.present?
            @errors_summary = initial_validator.errors_translator(:summary_conformance_rules)
          end
        end

        def end_date_existing_footnote!
          original_footnote.validity_end_date = operation_date

          ::WorkbasketValueObjects::Shared::SystemOpsAssigner.new(
            original_footnote, system_ops.merge(operation: "U")
          ).assign!

          original_footnote.save
        end

        def add_footnote!
          @footnote = Footnote.new(
            validity_start_date: validity_start_date,
            validity_end_date: validity_end_date
          )

          footnote.footnote_type_id = footnote_type_id

          assign_system_ops!(footnote)
          set_primary_key!(footnote)

          footnote.save if persist_mode?
        end

        def add_footnote_description_period!
          @footnote_description_period = FootnoteDescriptionPeriod.new(
            validity_start_date: validity_start_date,
            validity_end_date: validity_end_date
          )

          footnote_description_period.footnote_id = footnote.footnote_id
          footnote_description_period.footnote_type_id = footnote_type_id

          assign_system_ops!(footnote_description_period)
          set_primary_key!(footnote_description_period)

          footnote_description_period.save if persist_mode?
        end

        def add_footnote_description!
          @footnote_description = FootnoteDescription.new(
            description: description
          )

          footnote_description.footnote_id = footnote.footnote_id
          footnote_description.footnote_type_id = footnote_type_id

          assign_system_ops!(footnote_description)
          set_primary_key!(footnote_description)

          footnote_description.footnote_description_period_sid = footnote_description_period.footnote_description_period_sid

          footnote_description.save if persist_mode?
        end

        def persist_mode?
          @persist.present?
        end

        def setup_attrs_parser!
          @attrs_parser = ::WorkbasketValueObjects::EditFootnote::AttributesParser.new(
            settings_params
          )
        end

        def get_conformance_errors(record)
          res = {}

          record.conformance_errors.map do |k, v|
            message = if v.is_a?(Array)
              v.flatten.join(' ')
            else
              v
            end

            res[k.to_s] = "<strong class='workbasket-conformance-error-code'>#{k.to_s}</strong>: #{message}".html_safe
          end

          res
        end

        def validator_class(record)
          "#{record.class.name}Validator".constantize
        end
    end
  end
end
