module Workbaskets
  class Workbasket < Sequel::Model

    STATUS_LIST = [
      :new,
      :draft_incomplete,
      :draft_ready_for_cross_check,
      :submitted_for_cross_check,
      :cross_check_rejected,
      :ready_for_approval,
      :submitted_for_approval,
      :approval_rejected,
      :ready_for_export,
      :export_pending,
      :sent_to_cds,
      :cds_import_error,
      :already_in_cds
    ]

    TYPES = [
      :create_measures,
      :bulk_edit_of_measures,
      :create_quota
    ]

    SENT_TO_CDS_STATES = [
      :sent_to_cds,
      :already_in_cds
    ]

    one_to_many :events, key: :workbasket_id,
                         class_name: "Workbaskets::Event"

    one_to_many :items, key: :workbasket_id,
                        class_name: "Workbaskets::Item"

    one_to_one :create_measures_settings, key: :workbasket_id,
                                          class_name: "Workbaskets::CreateMeasuresSettings"

    many_to_one :user, key: :user_id,
                       foreign_key: :id,
                       class_name: "User"

    plugin :timestamps
    plugin :association_dependencies, events: :destroy,
                                      items: :destroy

    validates do
      presence_of :status,
                  :user_id,
                  :search_code,
                  :type

      inclusion_of :status, in: STATUS_LIST.map(&:to_s)
      inclusion_of :type, in: TYPES.map(&:to_s)
    end

    begin :callbacks
      def after_create
        build_related_settings_table!
      end
    end

    def track_current_page_loaded!(current_page)
      res = JSON.parse(batches_loaded)
      res[current_page] = true

      self.batches_loaded = res.to_json
    end

    def batches_loaded_pages
      JSON.parse(batches_loaded)
    end

    def get_item_by_id(target_id)
      items.detect do |i|
        i.record_id.to_s == target_id
      end
    end

    class << self
      def validate_measure!(measure_params={})
        return { validity_start_date: "Start date can't be blank!" } if measure_params[:validity_start_date].blank?

        errors = {}

        measure = Measure.new(
          ::Measures::BulkParamsConverter.new(
            measure_params
          ).converted_ops
        )

        measure.measure_sid = Measure.max(:measure_sid).to_i + 1

        ::Measures::ValidationHelper.new(
          measure, {}
        ).errors
      end
    end

    private

      def build_related_settings_table!
        settings = case type
        when :create_measures
          ::Workbaskets::CreateMeasuresSettings.new(
            workbasket_id: id
          )

        when :bulk_edit_of_measures
          # TODO: need to refactor Bulk Edit stuff
          #       to store settings, specific for Bulk Edit of measures
          #       in separated DB table
          #
        when :create_quota
          # TODO
        end

        settings.try(:save)
      end
  end
end
