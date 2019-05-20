module WorkbasketInteractions
  module CreateGeographicalArea
    class SettingsSaver
      include ::WorkbasketHelpers::SettingsSaverHelperMethods

      ATTRS_PARSER_METHODS = %w(
        geographical_code
        geographical_area_id
        parent_geographical_area_group_id
        parent_geographical_area_group_sid
        description
        validity_start_date
        validity_end_date
        operation_date
      ).freeze

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
                    :geographical_area,
                    :geographical_area_description,
                    :geographical_area_description_period,
                    :persist

      def initialize(workbasket, current_step, save_mode, settings_ops = {})
        @workbasket = workbasket
        @save_mode = save_mode
        @current_step = current_step
        @settings = workbasket.settings
        @settings_params = ActiveSupport::HashWithIndifferentAccess.new(settings_ops)

        setup_attrs_parser!
        clear_cached_sequence_number!

        @persist = true # For now it always true
        @errors = {}
        @errors_summary = {}
        @conformance_errors = {}
      end

      def save!
        workbasket.title = geographical_area_id
        workbasket.operation_date = operation_date
        workbasket.save

        settings.set_settings_for!(current_step, settings_params)
      end

      def valid?
        validate!
        @errors.blank?
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

      def memberships
        settings.main_step_settings['geographical_area_memberships']
      end

      def validate!
        check_initial_validation_rules!
        check_conformance_rules! if @errors.blank?
      end

      def check_initial_validation_rules!
        @initial_validator = ::WorkbasketInteractions::CreateGeographicalArea::InitialValidator.new(
          settings_params
        )

        @errors = initial_validator.fetch_errors
        @errors_summary = initial_validator.errors_summary
      end

      def check_conformance_rules!
        Sequel::Model.db.transaction(@do_not_rollback_transactions.present? ? {} : { rollback: :always }) do
          add_geographical_area!
          add_geographical_area_description_period!
          add_geographical_area_description!
          add_membership!

          parse_and_format_conformance_rules
        end
      end

      def add_membership!
        GeographicalAreaMembership.unrestrict_primary_key

        if memberships
          memberships.each do |m|
            membership_data = m.last['geographical_area']
            @membership = new_membership(membership_data)
            @membership.save if persist_mode?
          end
        end
      end

      def new_membership(membership_data)
        if geographical_code == 'group'
          geographical_area = GeographicalArea.where(geographical_area_id: membership_data['geographical_area_id']).first
          group = GeographicalArea.find(geographical_area_id: settings.main_step_settings['geographical_area_id'])
        else
          group = GeographicalArea.where(geographical_area_id: membership_data['geographical_area_id']).first
          geographical_area = GeographicalArea.find(geographical_area_id: settings.main_step_settings['geographical_area_id'])
        end

        GeographicalAreaMembership.new(
          geographical_area_sid: geographical_area.geographical_area_sid,
          geographical_area_group_sid: group[:geographical_area_sid],
          validity_start_date: membership_data['validity_start_date'],
          validity_end_date: membership_data['validity_end_date']
        )
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

        if conformance_errors.present?
          @errors_summary = initial_validator.errors_translator(:summary_conformance_rules)
        end
      end

      def add_geographical_area!
        @geographical_area = GeographicalArea.new(
          geographical_area_id: geographical_area_id,
          geographical_code: geo_code_number(geographical_code),
          validity_start_date: validity_start_date,
          validity_end_date: validity_end_date
        )

        if geographical_code == "group" && parent_geographical_area_group_id.present?
          geographical_area.parent_geographical_area_group_sid = parent_geographical_area_group_sid
        end

        assign_system_ops!(geographical_area)
        set_primary_key!(geographical_area)

        geographical_area.save if persist_mode?
      end

      def add_geographical_area_description_period!
        @geographical_area_description_period = GeographicalAreaDescriptionPeriod.new(
          geographical_area_id: geographical_area_id,
          validity_start_date: validity_start_date,
          validity_end_date: validity_end_date
        )
        geographical_area_description_period.geographical_area_sid = geographical_area.geographical_area_sid

        assign_system_ops!(geographical_area_description_period)
        set_primary_key!(geographical_area_description_period)

        geographical_area_description_period.save if persist_mode?
      end

      def add_geographical_area_description!
        @geographical_area_description = GeographicalAreaDescription.new(
          geographical_area_id: geographical_area_id,
          description: description,
          language_id: "EN"
        )

        assign_system_ops!(geographical_area_description)
        set_primary_key!(geographical_area_description)

        geographical_area_description.geographical_area_sid = geographical_area.geographical_area_sid
        geographical_area_description.geographical_area_description_period_sid = geographical_area_description_period.geographical_area_description_period_sid

        geographical_area_description.geographical_area = geographical_area
        geographical_area_description.geographical_area_description_period = geographical_area_description_period

        geographical_area_description.save if persist_mode?
      end

      def persist_mode?
        @persist.present?
      end

      def setup_attrs_parser!
        @attrs_parser = ::WorkbasketValueObjects::CreateGeographicalArea::AttributesParser.new(
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

          res[k.to_s] = "<strong class='workbasket-conformance-error-code'>#{k}</strong>: #{message}".html_safe
        end

        res
      end

      def geo_code_number(geographical_code)
        case geographical_code.to_s
        when 'country'
          '0'
        when 'group'
          '1'
        when 'region'
          '2'
        end
      end
    end
  end
end
