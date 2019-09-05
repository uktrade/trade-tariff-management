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
        parent_geographical_area_group_sid
        remove_parent_group_association
        validity_start_date
        validity_end_date
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
                    :original_geographical_area,
                    :geographical_area,
                    :geographical_area_description,
                    :geographical_area_description_period,
                    :next_geographical_area_description,
                    :next_geographical_area_description_period,
                    :persist

      def initialize(workbasket, current_step, save_mode, settings_ops = {})
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
        @errors_summary = {}
        @conformance_errors = {}
      end

      def save!
        workbasket.title = description
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
        check_if_nothing_changed! if @errors.blank?
        edit_memberships! if @errors.blank? && only_memberships_changed?
        edit_geographical_area! if @errors.blank? && !only_memberships_changed?
      end

      def check_initial_validation_rules!
        @initial_validator = ::WorkbasketInteractions::EditGeographicalArea::InitialValidator.new(
          original_geographical_area, settings_params
        )

        @errors = initial_validator.fetch_errors
        @errors_summary = initial_validator.errors_summary
      end

      def check_if_nothing_changed!
        if nothing_changed?
          @errors[:general] = "Nothing changed"
          @errors_summary = initial_validator.errors_translator(:nothing_changed)
        end
      end

      def nothing_changed?
        original_geographical_area.description.to_s.squish == description.to_s.squish &&
          original_geographical_area.validity_start_date.strftime("%Y-%m-%d") == validity_start_date.try(:strftime, "%Y-%m-%d") &&
          original_geographical_area.validity_end_date.try(:strftime, "%Y-%m-%d") == validity_end_date.try(:strftime, "%Y-%m-%d") &&
          original_geographical_area.parent_geographical_area_group_sid.to_s == parent_geographical_area_group_sid.to_s &&
          memberships_have_no_changes?
      end

      def only_memberships_changed?
        original_geographical_area.description.to_s.squish == description.to_s.squish &&
          original_geographical_area.validity_start_date.strftime("%Y-%m-%d") == validity_start_date.try(:strftime, "%Y-%m-%d") &&
          original_geographical_area.validity_end_date.try(:strftime, "%Y-%m-%d") == validity_end_date.try(:strftime, "%Y-%m-%d") &&
          original_geographical_area.parent_geographical_area_group_sid.to_s == parent_geographical_area_group_sid.to_s &&
          !memberships_have_no_changes?
      end

      def description_changed?
        original_geographical_area.description.to_s.squish != description.to_s.squish
      end

      def memberships_have_no_changes?
        return false if membership_removed?
        if original_geographical_area.geographical_code == '1'
          original_member_ids = original_geographical_area.currently_contains.map { |area| area.geographical_area_id }
          new_member_ids = settings_params["geographical_area_memberships"] ? settings_params["geographical_area_memberships"].values.map{|area| area['geographical_area_id']} : []
          original_member_ids == new_member_ids
        else
          original_membership_ids = original_geographical_area.currently_member_of.map { |area| area.geographical_area_id }
          new_membership_ids = settings_params["geographical_area_memberships"] ? settings_params["geographical_area_memberships"].values.map{|area| area["geographical_area_id"]} : []
          original_membership_ids == new_membership_ids
        end
      end

      def new_membership_ids
        return [] unless settings_params["geographical_area_memberships"]
        if original_geographical_area.geographical_code == '1'
          original_member_ids = original_geographical_area.currently_contains.map { |area| area.geographical_area_id }
          new_member_ids = settings_params["geographical_area_memberships"].values.map{|area| GeographicalArea.find(geographical_area_id: area["geographical_area_id"]).geographical_area_id}
          new_ids = new_member_ids.select { |m| !original_member_ids.include?(m) }
        else
          original_membership_ids = original_geographical_area.currently_member_of.map { |area| area.geographical_area_id }
          new_membership_ids = settings_params["geographical_area_memberships"].values.map{|area| area["geographical_area_id"]}
          new_ids = new_membership_ids.select { |m| !original_membership_ids.include?(m) }
        end
        new_ids
      end

      def edit_geographical_area!
        Sequel::Model.db.transaction(@do_not_rollback_transactions.present? ? {} : { rollback: :always }) do
          if it_is_just_description_changed?
            if existing_description_period_on_same_day.empty?
              end_date_existing_geographical_area_description_period!
              add_next_geographical_area_description_period!
              add_next_geographical_area_description!
            else
              update_existing_description!(existing_description_period_on_same_day)
            end
          else
            update_geographical_area! if settings_params['validity_end_date']
            if description_validity_start_date.present? && description_changed?
              if existing_description_period_on_same_day.empty?
                add_geographical_area_description_period!
                add_geographical_area_description!
                add_next_geographical_area_description_period!
                add_next_geographical_area_description!
              else
                update_existing_description!(existing_description_period_on_same_day)
              end
            end

            edit_memberships! unless memberships_have_no_changes?
          end

          parse_and_format_conformance_rules
        end
      end

      def update_existing_description!(same_day_description_period)
        description = same_day_description_period.first.geographical_area_description
        description.description = settings_params['description']

        ::WorkbasketValueObjects::Shared::SystemOpsAssigner.new(
          description, system_ops.merge(operation: "U")
        ).assign!(false)

        description.save
      end

      def existing_description_period_on_same_day
        GeographicalAreaDescriptionPeriod.where(geographical_area_sid: original_geographical_area.geographical_area_sid).all.select {|period| period.validity_start_date === settings_params['description_validity_start_date']}
      end

      def edit_memberships!
        add_new_memberships! unless new_membership_ids.empty?
        handle_removing_of_memberships if membership_removed?
      end

      def membership_removed?
        settings_params['removed_memberships']
      end

      def handle_removing_of_memberships
        if original_geographical_area.geographical_code == '1'
          end_date_existing_memberships_for_group!
        else
          end_date_existing_memberships_for_non_group!
        end
      end

      def add_new_memberships!
        new_ids = new_membership_ids
        if original_geographical_area.geographical_code == '1'
          add_membership_for_group(new_ids)
        else
          add_membership_for_region_or_country(new_ids)
        end
      end

      def add_membership_for_group(new_ids)
        new_memberships = GeographicalArea.where(geographical_area_id: new_ids).all
        new_memberships.each do |m|
          @membership = add_country_to_group(m)
          assign_system_ops!(@membership)
          set_primary_key!(@membership)
          @membership.save if persist_mode?
        end
      end

      def add_membership_for_region_or_country(new_ids)
        new_memberships = GeographicalArea.where(geographical_area_id: new_ids).all
        new_memberships.each do |m|
          @membership = add_group_to_country(m)
          assign_system_ops!(@membership)
          set_primary_key!(@membership)
          @membership.save if persist_mode?
        end
      end

      def add_group_to_country(member)
        GeographicalAreaMembership.unrestrict_primary_key
        GeographicalAreaMembership.new(
          geographical_area_sid: original_geographical_area.geographical_area_sid,
          geographical_area_group_sid: member.geographical_area_sid,
          validity_start_date: settings_params["operation_date"],
          validity_end_date: nil,
          workbasket_id: workbasket.id
        )
      end

      def add_country_to_group(member)
        GeographicalAreaMembership.unrestrict_primary_key
        GeographicalAreaMembership.new(
          geographical_area_sid: member.geographical_area_sid,
          geographical_area_group_sid: original_geographical_area.geographical_area_sid,
          validity_start_date: settings_params["operation_date"],
          validity_end_date: nil,
          workbasket_id: workbasket.id
        )
      end

      def parse_and_format_conformance_rules
        @conformance_errors = {}
        @geographical_area ||= original_geographical_area

        if it_is_just_description_changed? && existing_description_period_on_same_day.empty?
          check_for_description_only_conformance_errors
        elsif it_is_just_description_changed?
          check_for_updated_description_conformance_errors
        else
          check_for_full_conformance_errors
        end

        if conformance_errors.present?
          @errors_summary = initial_validator.errors_translator(:summary_conformance_rules)
        end
      end

      def check_for_description_only_conformance_errors
        unless next_geographical_area_description_period.conformant?
          @conformance_errors.merge!(get_conformance_errors(next_geographical_area_description_period))
        end

        unless next_geographical_area_description.conformant?
          @conformance_errors.merge!(get_conformance_errors(next_geographical_area_description))
        end
      end

      def check_for_updated_description_conformance_errors
        existing_description = existing_description_period_on_same_day.first.geographical_area_description
        @conformance_errors.merge!(get_conformance_errors(existing_description))
      end

      def check_for_full_conformance_errors
        check_geo_area_conformance

        if description_changed?
          if existing_description_period_on_same_day.empty?
            @conformance_errors.merge!(get_conformance_errors(geographical_area_description_period)) unless geographical_area_description_period.conformant?
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
          else
            check_for_updated_description_conformance_errors
          end
        end
      end

      def check_geo_area_conformance
        unless geographical_area.conformant?
          @conformance_errors.merge!(get_conformance_errors(geographical_area))
        end
      end

      def it_is_just_description_changed?
        @it_is_just_description_changed ||= begin
          original_geographical_area.description.to_s.squish != description.to_s.squish &&
            original_geographical_area.validity_start_date.strftime("%Y-%m-%d") == validity_start_date.try(:strftime, "%Y-%m-%d") &&
            original_geographical_area.validity_end_date.try(:strftime, "%Y-%m-%d") == validity_end_date.try(:strftime, "%Y-%m-%d") &&
            original_geographical_area.parent_geographical_area_group_sid.to_s == parent_geographical_area_group_sid.to_s &&
            memberships_have_no_changes?
        end
      end

      def update_geographical_area!
        g_area = GeographicalArea.find(geographical_area_id: original_geographical_area.geographical_area_id)
        return if g_area.validity_end_date == validity_end_date
        g_area.validity_end_date = validity_end_date

        ::WorkbasketValueObjects::Shared::SystemOpsAssigner.new(
          original_geographical_area, system_ops.merge(operation: "U")
        ).assign!(false)

        g_area.save
      end

      def end_date_existing_memberships_for_non_group!
        settings_params['removed_memberships'].values.each do |area|
          existing_membership = GeographicalAreaMembership.find(geographical_area_sid: original_geographical_area.geographical_area_sid, geographical_area_group_sid: area['geographical_area_sid'].to_i)
          existing_membership.validity_end_date = operation_date

          ::WorkbasketValueObjects::Shared::SystemOpsAssigner.new(
            existing_membership, system_ops.merge(operation: "U")
          ).assign!(false)

          existing_membership.save
        end
      end

      def end_date_existing_memberships_for_group!
        settings_params['removed_memberships'].values.each do |area|
          existing_membership = GeographicalAreaMembership.find(geographical_area_sid: area['geographical_area_sid'].to_i, geographical_area_group_sid: original_geographical_area.geographical_area_sid)
          existing_membership.validity_end_date = operation_date

          ::WorkbasketValueObjects::Shared::SystemOpsAssigner.new(
            existing_membership, system_ops.merge(operation: "U")
          ).assign!(false)

          existing_membership.save
        end
      end

      def end_date_existing_geographical_area_description_period!
        geographical_area_description_period = original_geographical_area.geographical_area_description
                                                                         .geographical_area_description_period

        unless geographical_area_description_period.already_end_dated?
          geographical_area_description_period.validity_end_date = (description_validity_start_date || validity_start_date)

          ::WorkbasketValueObjects::Shared::SystemOpsAssigner.new(
            geographical_area_description_period, system_ops.merge(operation: "U")
          ).assign!(false)

          geographical_area_description_period.save
        end
      end

      def add_geographical_area_description_period!
        @geographical_area_description_period = GeographicalAreaDescriptionPeriod.new(
          validity_start_date: validity_start_date,
          validity_end_date: (description_validity_start_date || validity_end_date)
        )

        geographical_area_description_period.geographical_area_id = original_geographical_area.geographical_area_id
        geographical_area_description_period.geographical_area_sid = original_geographical_area.geographical_area_sid

        assign_system_ops!(geographical_area_description_period)
        set_primary_key!(geographical_area_description_period)

        geographical_area_description_period.save if persist_mode?
      end

      def add_geographical_area_description!
        @geographical_area_description = GeographicalAreaDescription.new(
          description: original_geographical_area.description,
          language_id: "EN"
        )

        geographical_area_description.geographical_area_id = original_geographical_area.geographical_area_id
        geographical_area_description.geographical_area_sid = original_geographical_area.geographical_area_sid
        geographical_area_description.geographical_area_description_period_sid = geographical_area_description_period.geographical_area_description_period_sid

        assign_system_ops!(geographical_area_description)

        geographical_area_description.save if persist_mode?
      end

      def add_next_geographical_area_description_period!
        @next_geographical_area_description_period = GeographicalAreaDescriptionPeriod.new(
          validity_start_date: (description_validity_start_date || validity_start_date),
          validity_end_date: validity_end_date
        )

        next_geographical_area_description_period.geographical_area_id = (geographical_area || original_geographical_area).geographical_area_id
        next_geographical_area_description_period.geographical_area_sid = (geographical_area || original_geographical_area).geographical_area_sid

        assign_system_ops!(next_geographical_area_description_period)
        set_primary_key!(next_geographical_area_description_period)

        next_geographical_area_description_period.save if persist_mode?
      end

      def add_next_geographical_area_description!
        @next_geographical_area_description = GeographicalAreaDescription.new(
          description: description,
          language_id: "EN"
        )

        next_geographical_area_description.geographical_area_id = (geographical_area || original_geographical_area).geographical_area_id
        next_geographical_area_description.geographical_area_sid = (geographical_area || original_geographical_area).geographical_area_sid
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

          res[k.to_s] = "<strong class='workbasket-conformance-error-code'>#{k}</strong>: #{message}".html_safe
        end

        res
      end

      def validator_class(record)
        "#{record.class.name}Validator".constantize
      end
    end
  end
end
