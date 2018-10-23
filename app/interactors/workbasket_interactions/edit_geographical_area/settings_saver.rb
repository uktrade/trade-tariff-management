module WorkbasketInteractions
  module EditGeographicalArea
    class SettingsSaver

      include ::WorkbasketHelpers::SettingsSaverHelperMethods

      ATTRS_PARSER_METHODS = %w(
        reason_for_changes
        operation_date
        description
        description_validity_start_date
        parent_geographical_area_group_id
        validity_start_date
        validity_end_date
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
                    :original_geographical_area,
                    :geographical_area,
                    :geographical_area_description,
                    :geographical_area_description_period,
                    :next_geographical_area_description,
                    :next_geographical_area_description_period,
                    :persist

      def initialize(workbasket, current_step, save_mode, settings_ops={})
        @workbasket = workbasket
        @save_mode = save_mode
        @current_step = current_step
        @settings = workbasket.settings
        @original_geographical_area = settings.original_geographical_area.decorate
        @settings_params = ActiveSupport::HashWithIndifferentAccess.new(settings_ops)

        setup_attrs_parser!
        clear_cached_sequence_number!

        @persist = true # For now it always true
        @errors = {}
        @conformance_errors = {}
      end

      def save!
        workbasket.title = original_geographical_area.title
        workbasket.operation_date = (Date.strptime(operation_date, "%d/%m/%Y") rescue nil)
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
          @initial_validator = ::WorkbasketInteractions::EditGeographicalArea::InitialValidator.new(
            original_geographical_area, settings_params
          )

          @errors = initial_validator.fetch_errors
          @errors_summary = initial_validator.errors_summary
        end

        def check_conformance_rules!
          Sequel::Model.db.transaction(@do_not_rollback_transactions.present? ? {} : { rollback: :always }) do
            end_date_existing_geographical_area!

            add_geographical_area!
            add_geographical_area_description_period!
            add_geographical_area_description!

            if description_validity_start_date.present?
              add_next_geographical_area_description_period!
              add_next_geographical_area_description!
            end

            parse_and_format_conformance_rules
          end
        end

        def parse_and_format_conformance_rules
          @conformance_errors = {}

          unless geographical_area.conformant?
            @conformance_errors.merge!(get_conformance_errors(geographical_area))
          end

          unless geographical_area_description_period.conformant?
            @conformance_errors.merge!(get_conformance_errors(geographical_area_description_period))
          end

          unless geographical_area_description.conformant?
            @conformance_errors.merge!(get_conformance_errors(geographical_area_description))
          end

          if description_validity_start_date.present?
            unless next_geographical_area_description_period.conformant?
              @conformance_errors.merge!(get_conformance_errors(next_geographical_area_description_period))
            end

            unless next_geographical_area_description.conformant?
              @conformance_errors.merge!(get_conformance_errors(next_geographical_area_description))
            end
          end

          if conformance_errors.present?
            @errors_summary = initial_validator.errors_translator(:summary_conformance_rules)
          end
        end

        def end_date_existing_geographical_area!
          unless original_geographical_area.already_end_dated?
            original_geographical_area.validity_end_date = validity_start_date

            ::WorkbasketValueObjects::Shared::SystemOpsAssigner.new(
              original_geographical_area, system_ops.merge(operation: "U")
            ).assign!(false)

            original_geographical_area.save
          end
        end

        def add_geographical_area!
          @geographical_area = GeographicalArea.new(
            validity_start_date: validity_start_date,
            validity_end_date: validity_end_date
          )

          geographical_area.geographical_area_code = original_geographical_area.geographical_area_code
          geographical_area.geographical_area_type_code = original_geographical_area.geographical_area_type_code

          assign_system_ops!(geographical_area)

          geographical_area.save if persist_mode?
        end

        def add_geographical_area_description_period!
          @geographical_area_description_period = GeographicalAreaDescriptionPeriod.new(
            validity_start_date: validity_start_date,
            validity_end_date: (description_validity_start_date || validity_end_date)
          )

          geographical_area_description_period.geographical_area_code = geographical_area.geographical_area_code
          geographical_area_description_period.geographical_area_type_code = geographical_area.geographical_area_type_code

          assign_system_ops!(geographical_area_description_period)
          set_primary_key!(geographical_area_description_period)

          geographical_area_description_period.save if persist_mode?
        end

        def add_geographical_area_description!
          @geographical_area_description = GeographicalAreaDescription.new(
            description: original_geographical_area.description,
            language_id: "EN"
          )

          geographical_area_description.geographical_area_code = geographical_area.geographical_area_code
          geographical_area_description.geographical_area_type_code = geographical_area.geographical_area_type_code
          geographical_area_description.geographical_area_description_period_sid = geographical_area_description_period.geographical_area_description_period_sid

          assign_system_ops!(geographical_area_description)
          set_primary_key!(geographical_area_description)

          geographical_area_description.save if persist_mode?
        end

        def add_next_geographical_area_description_period!
          @next_geographical_area_description_period = GeographicalAreaDescriptionPeriod.new(
            validity_start_date: description_validity_start_date,
            validity_end_date: validity_end_date
          )

          next_geographical_area_description_period.geographical_area_code = geographical_area.geographical_area_code
          next_geographical_area_description_period.geographical_area_type_code = geographical_area.geographical_area_type_code

          assign_system_ops!(next_geographical_area_description_period)
          set_primary_key!(next_geographical_area_description_period)

          next_geographical_area_description_period.save if persist_mode?
        end

        def add_next_geographical_area_description!
          @next_geographical_area_description = GeographicalAreaDescription.new(
            description: description,
            language_id: "EN"
          )

          next_geographical_area_description.geographical_area_code = geographical_area.geographical_area_code
          next_geographical_area_description.geographical_area_type_code = geographical_area.geographical_area_type_code
          next_geographical_area_description.geographical_area_description_period_sid = next_geographical_area_description_period.geographical_area_description_period_sid

          assign_system_ops!(next_geographical_area_description)

          next_geographical_area_description.save if persist_mode?
        end

        def persist_mode?
          @persist.present?
        end

        def setup_attrs_parser!
          @attrs_parser = ::WorkbasketValueObjects::EditGeographicalArea::AttributesParser.new(
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
