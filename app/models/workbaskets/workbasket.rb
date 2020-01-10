module Workbaskets
  class Workbasket < Sequel::Model
    TYPES = %i[
      create_measures
      bulk_edit_of_measures
      create_quota
      clone_quota
      create_regulation
      create_additional_code
      bulk_edit_of_additional_codes
      bulk_edit_of_quotas
      create_geographical_area
      create_footnote
      edit_footnote
      create_certificate
      edit_certificate
      edit_geographical_area
      edit_nomenclature
      edit_nomenclature_dates
      create_nomenclature
      edit_regulation
      create_quota_association
      delete_quota_association
      create_quota_suspension
      edit_quota_suspension
      delete_quota_suspension
      create_quota_blocking_period
      edit_quota_blocking_period
      delete_quota_blocking_period
    ].freeze

    STATUS_LIST = [
      :new_in_progress,                # New - in progress
                                       # Newly started, but not yet submitted into workflow
                                       #
      :editing,                        # Editing
                                       # Existing item, already on CDS, being edited but not yet submitted into workflow
                                       #
      :awaiting_cross_check,           # Awaiting cross-check
                                       # Check Submitted into workflow, not yet cross-checked
                                       #
      :cross_check_rejected,           # Failed cross-check
                                       # Did not pass cross-check, returned to submitter
                                       #
      :awaiting_approval,              # Awaiting approval
                                       # Submitted for approval, pending response from Approver
                                       #
      :approval_rejected,              # Failed approval
                                       # Was not approved, returned to submitter
                                       #
      :ready_for_export,               # Ready for export
                                       # Approved but not yet scheduled for sending to CDS
                                       #
      :awaiting_cds_upload_create_new, # Awaiting CDS upload - create new
                                       # New item approved and scheduled for sending to CDS
                                       #
      :awaiting_cds_upload_edit,       # Awaiting CDS upload - edit
                                       # Edited item approved and scheduled for sending to CDS,
                                       # existing version will be end-dated and replaced
                                       #
      :awaiting_cds_upload_overwrite,  # Awaiting CDS upload - overwrite
                                       # Edited item approved and scheduled for sending to CDS,
                                       # existing version will be updated
                                       #
      :awaiting_cds_upload_delete,     # Awaiting CDS upload - delete
                                       # Delete instruction approved and scheduled for sending to CDS
                                       #
      :sent_to_cds,                    # Sent to CDS
                                       # Sent to CDS, waiting for response
                                       #
      :sent_to_cds_delete,             # Sent to CDS - delete
                                       # Delete instruction sent to CDS, waiting for response
                                       #
      :published,                      # Published
                                       # On CDS, may or may not have taken effect
                                       #
      :cds_error                       # CDS error
                                       # Sent to CDS, but CDS returned an error
                                       #
    ].freeze

    EDITABLE_STATES = [
      :new_in_progress, # "New - in progress"
      :editing # "Editing"
    ].freeze

    SENT_TO_CDS_STATES = %i[
      sent_to_cds
      sent_to_cds_delete
      published
    ].freeze

    STATES_WITH_ERROR = %i[
      cross_check_rejected
      approval_rejected
      cds_error
    ].freeze

    APPROVER_SCOPE = %i[
      awaiting_cross_check
      awaiting_approval
    ].freeze

    CREATE_WORKBASKETS = %w(
      create_measures
      create_quota
      clone_quota
      create_regulation
      create_geographical_area
      create_additional_code
      create_footnote
      create_nomenclature
      create_certificate
    ).freeze

    EDIT_WORKABSKETS = %w(
      bulk_edit_of_measures
      bulk_edit_of_quotas
      bulk_edit_of_additional_codes
      edit_footnote
      edit_certificate
      edit_geographical_area
      edit_nomenclature
      edit_nomenclature_dates
      edit_regulation
    ).freeze

    one_to_many :events, key: :workbasket_id,
                         class_name: "Workbaskets::Event"

    one_to_many :items, key: :workbasket_id,
                        class_name: "Workbaskets::Item"

    one_to_one :bulk_edit_of_measures_settings, key: :workbasket_id,
                                                class_name: "Workbaskets::BulkEditOfMeasuresSettings"

    one_to_one :create_measures_settings, key: :workbasket_id,
                                          class_name: "Workbaskets::CreateMeasuresSettings"

    one_to_one :create_quota_settings, key: :workbasket_id,
                                       class_name: "Workbaskets::CreateQuotaSettings"

    one_to_one :create_regulation_settings, key: :workbasket_id,
                                            class_name: "Workbaskets::CreateRegulationSettings"

    one_to_one :create_additional_code_settings, key: :workbasket_id,
                                                 class_name: "Workbaskets::CreateAdditionalCodeSettings"

    one_to_one :bulk_edit_of_additional_codes_settings, key: :workbasket_id,
                                                        class_name: "Workbaskets::BulkEditOfAdditionalCodesSettings"

    one_to_one :bulk_edit_of_quotas_settings, key: :workbasket_id,
                                              class_name: "Workbaskets::BulkEditOfQuotasSettings"

    one_to_one :create_geographical_area_settings, key: :workbasket_id,
                                                   class_name: "Workbaskets::CreateGeographicalAreaSettings"
    one_to_one :create_footnote_settings, key: :workbasket_id,
                                          class_name: "Workbaskets::CreateFootnoteSettings"

    one_to_one :create_certificate_settings, key: :workbasket_id,
                                                   class_name: "Workbaskets::CreateCertificateSettings"

    one_to_one :edit_footnote_settings, key: :workbasket_id,
                                        class_name: "Workbaskets::EditFootnoteSettings"

    one_to_one :edit_certificate_settings, key: :workbasket_id,
                                           class_name: "Workbaskets::EditCertificateSettings"

    one_to_one :edit_geographical_area_settings, key: :workbasket_id,
                                                 class_name: "Workbaskets::EditGeographicalAreaSettings"

    one_to_one :edit_nomenclature_settings, key: :workbasket_id,
               class_name: "Workbaskets::EditNomenclatureSettings"

    one_to_one :edit_nomenclature_dates_settings, key: :workbasket_id,
               class_name: "Workbaskets::EditNomenclatureDatesSettings"

    one_to_one :create_nomenclature_settings, key: :workbasket_id,
               class_name: "Workbaskets::CreateNomenclatureSettings"

    one_to_one :edit_regulation_settings, key: :workbasket_id,
               class_name: "Workbaskets::EditRegulationSettings"

    one_to_one :create_quota_association_settings, key: :workbasket_id,
               class_name: "Workbaskets::CreateQuotaAssociationSettings"

    one_to_one :delete_quota_association_settings, key: :workbasket_id,
               class_name: "Workbaskets::DeleteQuotaAssociationSettings"

    one_to_one :delete_quota_suspension_settings, key: :workbasket_id,
               class_name: "Workbaskets::DeleteQuotaSuspensionSettings"

    one_to_one :create_quota_suspension_settings, key: :workbasket_id,
               class_name: "Workbaskets::CreateQuotaSuspensionSettings"

    one_to_one :edit_quota_suspension_settings, key: :workbasket_id,
               class_name: "Workbaskets::EditQuotaSuspensionSettings"

    one_to_one :create_quota_blocking_period_settings, key: :workbasket_id,
               class_name: "Workbaskets::CreateQuotaBlockingPeriodSettings"

    one_to_one :edit_quota_blocking_period_settings, key: :workbasket_id,
               class_name: "Workbaskets::EditQuotaBlockingPeriodSettings"

    one_to_one :delete_quota_blocking_period_settings, key: :workbasket_id,
               class_name: "Workbaskets::DeleteQuotaBlockingPeriodSettings"

    many_to_one :user, key: :user_id,
                       foreign_key: :id,
                       class_name: "User"

    many_to_one :cross_checker, key: :cross_checker_id,
                                foreign_key: :id,
                                class_name: "User"

    many_to_one :approver, key: :approver_id,
                           foreign_key: :id,
                           class_name: "User"

    many_to_one :last_update_by, key: :last_update_by_id,
                                 foreign_key: :id,
                                 class_name: "User"

    plugin :timestamps
    plugin :validation_helpers
    plugin :enumerize
    plugin :association_dependencies, events: :destroy,
                                      items: :destroy

    enumerize :type, in: TYPES,
                     predicates: true

    enumerize :status, in: STATUS_LIST,
                       default: :new_in_progress,
                       predicates: true

    delegate :collection, :collection_by_type, to: :settings

    validates do
      presence_of :status,
                  :user_id,
                  :type

      inclusion_of :status, in: STATUS_LIST.map(&:to_s)
      inclusion_of :type, in: TYPES.map(&:to_s)
    end

    dataset_module do
      def default_order
        reverse_order(:last_status_change_at)
      end

      def default_filter
        where("title IS NOT NULL AND title != ''")
      end

      def custom_field_order(sort_by_field, sort_direction)
        if sort_direction.to_sym == :desc
          reverse_order(sort_by_field.to_sym)
        else
          order(sort_by_field.to_sym)
        end
      end

      def relevant_for_manager(current_user)
        if current_user.approver?
          where(
            "user_id = ? OR status IN ('new_in_progress', 'editing', 'awaiting_cross_check', 'awaiting_approval', 'awaiting_cds_upload_create_new', 'ready_for_export', 'awaiting_cds_upload_edit')",
            current_user.id
          )
        else
          where(
            "user_id = ? OR status = ?",
            current_user.id, "awaiting_cross_check"
          )
        end
      end

      def all_relevant(status, id)
        where("status = ? and id != ?", status, id)
      end

      def q_search(keyword)
        underscored_keywords = keyword.squish.parameterize.underscore + "%"

        where("
          title ilike ? OR
          status ilike ? OR
          type ilike ?",
          "#{keyword}%",
          underscored_keywords,
          underscored_keywords)
      end

      def by_date_range(start_date, end_date)
        if end_date.present?
          where(
            "operation_date >= ? AND operation_date <= ?", start_date, end_date
          ).or(operation_date: nil)
        else
          where(
            "operation_date = ?", start_date
          )
        end
      end

      def first_operation_date
        exclude(operation_date: nil).order(:operation_date).limit(1).first&.operation_date
      end

      def in_status(status_name)
        where(status: status_name)
      end

      def by_type(type_name)
        where(type: type_name)
      end

      def cross_check_can_be_started
        where("cross_checker_id IS NULL and status = 'awaiting_cross_check'")
      end

      def approve_can_be_started
        where("approver_id IS NULL and status = 'awaiting_approval'")
      end
    end

    begin :callbacks
          def before_create
            self.last_update_by_id = user_id
            self.last_status_change_at = Time.zone.now
          end

          def after_create
            build_related_settings_table!
          end
    end

    def class_name
      type.split('_')
          .map(&:capitalize)
          .join('')
    end

    def decorate
      Workbaskets::WorkbasketDecorator.decorate(self)
    end

    begin :workflow_related_helpers
          def cds_error!
            move_status_to!(nil, :cds_error)

            settings.collection.map do |item|
              item.move_status_to!(:cds_error)
            end
          end

          def published!
            move_status_to!(nil, :published)

            settings.collection.map do |item|
              item.move_status_to!(:published)
            end
          end

          def submit_for_cross_check!(current_admin:)
            submit_for_approval!(current_admin: current_admin)
          end

          def move_to_editing!(current_admin:)
            move_status_to!(current_admin, "editing")

            clean_up_draft_measures! if type == "bulk_edit_of_measures"
            clean_up_drafts! if (type == "edit_regulation" ||
                                 type == 'edit_footnote' ||
                                 type == 'create_quota_association' ||
                                 type == 'delete_quota_association' ||
                                 type == 'edit_nomenclature_dates' ||
                                 type == 'edit_quota_blocking_period'
                                 type == 'create_nomenclature')

            settings.collection.map do |item|
              item.move_status_to!(:editing)
            end
          end

          def submit_for_approval!(current_admin:)
            move_status_to!(current_admin, :awaiting_approval)

            settings.collection.map do |item|
              item.move_status_to!(:awaiting_approval)
            end
          end

          def reject_cross_check!(current_admin:)
            settings.collection.map do |item|
              item.move_status_to!(:cross_check_rejected)
            end
          end

          def confirm_approval!(current_admin:)
            settings.collection.map do |item|
              item.move_status_to!(possible_approved_status)
            end
          end

          def reject_approval!(current_admin:)
            settings.collection.map do |item|
              item.move_status_to!(:approval_rejected)
            end
          end

          def testing_status_backdoor!(current_admin:, status:)
            if status == :published
              published!
            else
              move_status_to!(current_admin, status, 'Tester backdoor')

              settings.collection.map do |item|
                item.move_status_to!(status)
              end
            end
          end

          def confirm_sent_to_cds!(current_admin:)
            move_status_to!(current_admin, :sent_to_cds)

            settings.collection.map do |item|
              item.move_status_to!(:sent_to_cds)
            end
          end

          def clean_up_drafts!
            settings.collection.each(&:delete)
          end

          def clean_up_draft_measures!
            delete_draft_measures
            remove_references_to_drafts_in_settings
          end

          def remove_references_to_drafts_in_settings
            settings.measure_sids_jsonb = [].to_json
            settings.quota_period_sids_jsonb = [].to_json if defined?(quota_period_sids_jsonb)

            settings.save
          end

          def delete_draft_measures
            get_draft_measures.map(&:destroy)
          end

          def get_draft_measures
            measures = settings.collection.select { |item| item.class == Measure }
            sorted_measures = measures.sort_by{ |m| m.measure_sid }.reverse
            sorted_measures.slice!(0, measures.count/2)
          end

          def edit_type?
            EDIT_WORKABSKETS.include?(type)
          end

          def possible_approved_status
            edit_type? ? "awaiting_cds_upload_edit" : "awaiting_cds_upload_create_new"
          end

          def editable?
            status.to_sym.in?(EDITABLE_STATES) && (type != :delete_quota_association && type != :delete_quota_suspension && type != :delete_quota_blocking_period)
          end

          def submitted?
            !editable?
          end

          def can_withdraw?
            (rejected? || waiting_for_cross_check_or_approval?)
          end

          def rejected?
            status.to_sym.in?(STATES_WITH_ERROR)
          end

          def waiting_for_cross_check_or_approval?
            status.to_sym.in?(APPROVER_SCOPE)
          end

          def cross_check_process_can_be_started?
            awaiting_cross_check? &&
              cross_checker_id.blank?
          end

          def cross_check_process_can_not_be_started?
            !cross_check_process_can_be_started?
          end

          def can_continue_cross_check?(current_user)
            return false if current_user.approver_user
            return false if current_user.author_of_workbasket?(self)
            return false unless awaiting_cross_check?
            true
          end

          def approve_process_can_not_be_started?
            !approve_process_can_be_started?
          end

          def awaiting_cds_upload_new_or_edit_item?
            awaiting_cds_upload_create_new? ||
              awaiting_cds_upload_edit?
          end

          def operation_date_can_be_rescheduled?
            awaiting_cds_upload_new_or_edit_item? &&
              operation_date.present? &&
              operation_date > Date.today + 1.day
          end
    end

    def author_name
      user.name
    end

    def ready_for_upload
      status == :awaiting_cds_upload_create_new || status == :awaiting_cds_upload_edit
    end

    def ordered_events
      events.sort_by(&:created_at)
    end

    def submitted?
      !status.to_sym.in? %i[new_in_progress editing]
    end

    def is_bulk_edit?
      type.start_with?("bulk_edit")
    end

    def move_status_to!(current_user, new_status, description = nil)
      reload
      add_event!(current_user, new_status, description)

      self.status = new_status
      self.last_update_by_id = current_user&.id
      self.last_status_change_at = Time.zone.now

      reset_settings_step_validations if new_status.to_sym == :editing

      save
    end

    def add_event!(current_user, new_status, description = nil)
      event = Workbaskets::Event.new(
        workbasket_id: self.id,
        user_id: current_user&.id,
        event_type: new_status,
        description: description
      )

      event.save
    end

    def reset_settings_step_validations
      settings.reset_step_validations
    end

    def settings
      case type.to_sym
      when :create_measures
        create_measures_settings
      when :bulk_edit_of_measures
        bulk_edit_of_measures_settings
      when :create_quota, :clone_quota
        create_quota_settings
      when :create_regulation
        create_regulation_settings
      when :create_additional_code
        create_additional_code_settings
      when :bulk_edit_of_additional_codes
        bulk_edit_of_additional_codes_settings
      when :bulk_edit_of_quotas
        bulk_edit_of_quotas_settings
      when :create_geographical_area
        create_geographical_area_settings
      when :create_footnote
        create_footnote_settings
      when :create_certificate
        create_certificate_settings
      when :edit_footnote
        edit_footnote_settings
      when :edit_certificate
        edit_certificate_settings
      when :edit_geographical_area
        edit_geographical_area_settings
      when :edit_nomenclature
        edit_nomenclature_settings
      when :edit_nomenclature_dates
        edit_nomenclature_dates_settings
      when :create_nomenclature
        create_nomenclature_settings
      when :edit_regulation
        edit_regulation_settings
      when :create_quota_association
        create_quota_association_settings
      when :delete_quota_association
        delete_quota_association_settings
      when :delete_quota_suspension
        delete_quota_suspension_settings
      when :create_quota_suspension
        create_quota_suspension_settings
      when :edit_quota_suspension
        edit_quota_suspension_settings
      when :create_quota_blocking_period
        create_quota_blocking_period_settings
      when :edit_quota_blocking_period
        edit_quota_blocking_period_settings
      when :delete_quota_blocking_period
        delete_quota_blocking_period_settings
      end
    end

    def generate_next_sequence_number
      @sequence_number = (@sequence_number || 0) + 1
    end

    def to_json
      {
        title: title,
        type: type,
        status: status,
        user: user.try(:to_json),
        last_update_by: last_update_by.try(:to_json),
        last_status_change_at: last_status_change_at.try(:strftime, "%d %b %Y") || "-",
        updated_at: updated_at.try(:strftime, "%d %b %Y") || "-",
        created_at: created_at.try(:strftime, "%d %b %Y") || "-"
      }
    end

    def debug_collection
      #
      # TODO: remove me after finishing of active development phase
      #
      settings.collection
              .map.with_index do |el, index|

        puts " [#{index}] Class: #{el.class.name}"
        puts "             Workbasket ID: #{el.workbasket_id}"
        puts "             Sequence number: #{el.workbasket_sequence_number}"
        puts "             Status: #{el.status}"

        custom_note = case el.class.name
                      when "Measure"
                        el.measure_sid
                      when "MeasureComponent"
                        el.formatted_duty_expression
                      when "MeasureCondition"
                        el.short_abbreviation
                      when "MeasureConditionComponent"
                        el.formatted_duty_expression
                      when "Footnote"
                        "#{el.footnote_type_id} - #{el.footnote_id}"
                      when "FootnoteDescription"
                        el.description.to_s
                      when "FootnoteDescriptionPeriod"
                        el.footnote_description_period_sid.to_s
                      when "FootnoteAssociationMeasure"
                        "footnote_type_id: #{el.footnote_type_id}, footnote_id: #{el.footnote_id}, measure_sid: #{el.measure_sid}"
        end

        puts "             #{custom_note}"
      end
    end

    def clean_up_workbasket!
      if settings.present?
        settings.collection.map do |item|
          item.manual_add = true
          item.destroy
        end

        settings.destroy
      end
      clean_up_related_cache!
      destroy
    end

    def clean_up_related_cache!
      Rails.cache.write("#{id}_sequence_number", nil)
    end

    class << self
      def max_per_page
        10
      end

      def default_per_page
        10
      end

      def max_pages
        999
      end

      def clean_up!
        %w(
          bulk_edit_of_measures
          create_measures
          create_quota
          clone_quota
          create_regulation
          create_additional_code
          bulk_edit_of_additional_codes
          bulk_edit_of_quotas
          create_geographical_area
          create_footnote
          create_certificate
          edit_footnote
          edit_certificate
          edit_geographical_area
          edit_nomenclature
          edit_nomenclature_dates
          create_nomenclature
          edit_regulation
          create_quota_association
          delete_quota_association
          create_quota_suspension
          edit_quota_suspension
          delete_quota_suspension
          create_quota_blocking_period
          edit_quota_blocking_period
        ).map do |type_name|
          by_type(type_name).map(&:clean_up_workbasket!)
        end
      end
    end

  private

    def build_related_settings_table!
      target_class = case type.to_sym
                     when :create_measures
                       ::Workbaskets::CreateMeasuresSettings
                     when :bulk_edit_of_measures
                       ::Workbaskets::BulkEditOfMeasuresSettings
                     when :create_quota, :clone_quota
                       ::Workbaskets::CreateQuotaSettings
                     when :bulk_edit_of_quotas
                       ::Workbaskets::BulkEditOfQuotasSettings
                     when :create_regulation
                       ::Workbaskets::CreateRegulationSettings
                     when :create_additional_code
                       ::Workbaskets::CreateAdditionalCodeSettings
                     when :bulk_edit_of_additional_codes
                       ::Workbaskets::BulkEditOfAdditionalCodesSettings
                     when :create_geographical_area
                       ::Workbaskets::CreateGeographicalAreaSettings
                     when :create_footnote
                       ::Workbaskets::CreateFootnoteSettings
                     when :create_certificate
                       ::Workbaskets::CreateCertificateSettings
                     when :edit_footnote
                       ::Workbaskets::EditFootnoteSettings
                     when :edit_certificate
                       ::Workbaskets::EditCertificateSettings
                     when :edit_geographical_area
                       ::Workbaskets::EditGeographicalAreaSettings
                     when :edit_nomenclature
                       ::Workbaskets::EditNomenclatureSettings
                     when :edit_nomenclature_dates
                       ::Workbaskets::EditNomenclatureDatesSettings
                     when :create_nomenclature
                       ::Workbaskets::CreateNomenclatureSettings
                     when :edit_regulation
                       ::Workbaskets::EditRegulationSettings
                     when :create_quota_association
                       ::Workbaskets::CreateQuotaAssociationSettings
                     when :delete_quota_association
                       ::Workbaskets::DeleteQuotaAssociationSettings
                     when :delete_quota_suspension
                       ::Workbaskets::DeleteQuotaSuspensionSettings
                     when :create_quota_suspension
                       ::Workbaskets::CreateQuotaSuspensionSettings
                     when :edit_quota_suspension
                       ::Workbaskets::EditQuotaSuspensionSettings
                     when :create_quota_blocking_period
                       ::Workbaskets::CreateQuotaBlockingPeriodSettings
                     when :edit_quota_blocking_period
                       ::Workbaskets::EditQuotaBlockingPeriodSettings
                     when :delete_quota_blocking_period
                       ::Workbaskets::DeleteQuotaBlockingPeriodSettings
      end

      target_class.unrestrict_primary_key

      settings = target_class.new(
        workbasket_id: id
      )
      settings.save if settings.present?
    end
  end
end
