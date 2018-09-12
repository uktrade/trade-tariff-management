module Workbaskets
  class Workbasket < Sequel::Model

    TYPES = [
      :create_measures,
      :bulk_edit_of_measures,
      :create_quota,
      :create_regulation
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

    many_to_one :user, key: :user_id,
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

    validates do
      presence_of :status,
                  :user_id,
                  :type

      inclusion_of :status, in: STATUS_LIST.map(&:to_s)
      inclusion_of :type, in: TYPES.map(&:to_s)
    end

    dataset_module do
      def xml_export_collection(start_date, end_date)
        by_date_range(
          start_date, end_date
        ).in_status("awaiting_cross_check")
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
      def after_create
        build_related_settings_table!
      end
    end

    def editable?
      status.to_sym.in?(EDITABLE_STATES)
    end

    def move_status_to!(new_status)
      self.status = new_status
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
      end
    end

    def generate_next_sequence_number
      @sequence_number = (@sequence_number || 0) + 1
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
        end

        settings.save if settings.present?
      end
  end
end
