module Workbaskets
  class Workbasket < Sequel::Model

    TYPES = [
      :create_measures,
      :bulk_edit_of_measures,
      :create_quota,
      :create_regulation,
      :create_additional_code,
      :bulk_edit_of_additional_codes
    ]

    STATUS_LIST = [
      :new_in_progress,                # "New - in progress"
      :editing,                        # "Editing"
      :awaiting_cross_check,           # "Awaiting cross-check"
      :cross_check_rejected,           # "Cross-check rejected"
      :ready_for_approval,             # "Ready for approval"
      :awaiting_approval,              # "Awaiting approval"
      :approval_rejected,              # "Approval rejected"
      :ready_for_export,               # "Ready for export"
      :awaiting_cds_upload_create_new, # "Awaiting CDS upload - create new"
      :awaiting_cds_upload_edit,       # "Awaiting CDS upload - edit"
      :awaiting_cds_upload_overwrite,  # "Awaiting CDS upload - overwrite"
      :awaiting_cds_upload_delete,     # "Awaiting CDS upload - delete"
      :sent_to_cds,                    # "Sent to CDS"
      :sent_to_cds_delete,             # "Sent to CDS - delete"
      :published,                      # "Published"
      :cds_error                       # "CDS error"
    ]

    EDITABLE_STATES = [
      :new_in_progress,  # "New - in progress"
      :editing,          # "Editing"
      :approval_rejected # "Approval rejected"
    ]

    SENT_TO_CDS_STATES = [
      :sent_to_cds,
      :sent_to_cds_delete,
      :published
    ]

    STATES_WITH_ERROR = [
      :cross_check_rejected,
      :approval_rejected,
      :cds_error
    ]

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

    many_to_one :user, key: :user_id,
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

      def custom_field_order(sort_by_field, sort_direction)
        if sort_direction.to_sym == :desc
          reverse_order(sort_by_field.to_sym)
        else
          order(sort_by_field.to_sym)
        end
      end

      def for_author(current_user)
        where(user_id: current_user.id)
      end

      def q_search(keyword)
        underscored_keywords = keyword.squish.parameterize.underscore + "%"

        where("
          title ilike ? OR
          status ilike ? OR
          type ilike ?",
          "#{keyword}%",
          underscored_keywords,
          underscored_keywords
        )
      end

      def xml_export_collection(start_date, end_date)
        by_date_range(
          start_date, end_date
        ).in_status(["awaiting_cross_check", "ready_for_export"])
         .order(:operation_date)
      end

      def by_date_range(start_date, end_date)
        if end_date.present?
          where(
            "operation_date >= ? AND operation_date <= ?", start_date, end_date
          )
        else
          where(
            "operation_date = ?", start_date
          )
        end
      end

      def in_status(status_name)
        where(status: status_name)
      end

      def by_type(type_name)
        where(type: type_name)
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

    def decorate
      Workbaskets::WorkbasketDecorator.decorate(self)
    end

    def editable?
      status.to_sym.in?(EDITABLE_STATES)
    end

    def submitted?
      !status.to_sym.in? [:new_in_progress, :editing]
    end

    def move_status_to!(current_user, new_status, description=nil)
      event = Workbaskets::Event.new(
        workbasket_id: self.id,
        user_id: current_user.id,
        event_type: new_status,
        description: description
      )
      event.save

      self.status = new_status
      self.last_update_by_id = current_user.id
      self.last_status_change_at = Time.zone.now

      save
    end

    def settings
      case type.to_sym
      when :create_measures
        create_measures_settings
      when :bulk_edit_of_measures
        bulk_edit_of_measures_settings
      when :create_quota
        create_quota_settings
      when :create_regulation
        create_regulation_settings
      when :create_additional_code
        create_additional_code_settings
      when :bulk_edit_of_additional_codes
        bulk_edit_of_additional_codes_settings
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
          "#{el.description}"
        when "FootnoteDescriptionPeriod"
          "#{el.footnote_description_period_sid}"
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

      def buld_new_workbasket!(type, current_user)
        workbasket = Workbaskets::Workbasket.new(
          type: type,
          user: current_user
        )
        workbasket.save

        workbasket
      end

      def clean_up!
        %w(
          bulk_edit_of_measures
          create_measures
          create_quota
          create_regulation
          create_additional_code
          bulk_edit_of_additional_codes
        ).map do |type_name|
          by_type(type_name).map do |w|
            w.clean_up_workbasket!
          end
        end
      end
    end

    private

      def build_related_settings_table!
        settings = case type.to_sym
        when :create_measures
          ::Workbaskets::CreateMeasuresSettings.new(
            workbasket_id: id
          )
        when :bulk_edit_of_measures
          ::Workbaskets::BulkEditOfMeasuresSettings.new(
            workbasket_id: id
          )
        when :create_quota
          ::Workbaskets::CreateQuotaSettings.new(
            workbasket_id: id
          )
        when :create_regulation
          ::Workbaskets::CreateRegulationSettings.new(
            workbasket_id: id
          )
        when :create_additional_code
          ::Workbaskets::CreateAdditionalCodeSettings.new(
            workbasket_id: id
          )
        when :bulk_edit_of_additional_codes
          ::Workbaskets::BulkEditOfAdditionalCodesSettings.new(
            workbasket_id: id
          )
        end

        settings.save if settings.present?
      end
  end
end
