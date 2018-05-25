class MeasureGroup < Sequel::Model

  STATUS_LIST = [
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

  one_to_many :measures, key: :measure_group_id

  validates do
    presence_of :name,
                :status,
                :added_by_id,
                :last_update_by_id

    uniqueness_of :name

    inclusion_of :status, in: STATUS_LIST.map(&:to_s)
  end
end
