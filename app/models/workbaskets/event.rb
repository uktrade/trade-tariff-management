module Workbaskets
  class Event < Sequel::Model(:workbaskets_events)

    EVENT_TYPES = [
      :draft_ready_for_cross_check,
      :submitted_for_cross_check,
      :cross_check_rejected,
      :ready_for_approval,
      :submitted_for_approval,
      :approval_rejected,
      :ready_for_export,
      :export_pending,
      :sent_to_cds,
      :cds_import_error
    ]

    many_to_one :workbasket, key: :workbasket_id,
                             foreign_key: :id

    many_to_one :user, key: :user_id,
                       foreign_key: :id,
                       class_name: "User"

    validates do
      presence_of :event_type,
                  :user_id,
                  :workbasket_id

      inclusion_of :event_type, in: EVENT_TYPES.map(&:to_s)
    end
  end
end
