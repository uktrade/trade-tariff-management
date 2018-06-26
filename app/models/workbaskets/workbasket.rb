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

    plugin :timestamps

    one_to_many :events, key: :workbasket_id,
                         class_name: "Workbaskets::Event"

    one_to_many :items, key: :workbasket_id,
                        class_name: "Workbaskets::Item"

    many_to_one :user, key: :user_id,
                       foreign_key: :id,
                       class_name: "User"

    validates do
      presence_of :status,
                  :user_id

      inclusion_of :status, in: STATUS_LIST.map(&:to_s)
    end
  end
end
