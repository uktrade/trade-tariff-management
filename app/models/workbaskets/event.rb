module Workbaskets
  class Event < Sequel::Model(:workbaskets_events)

    plugin :timestamps

    many_to_one :workbasket, key: :workbasket_id,
                             foreign_key: :id

    many_to_one :user, key: :user_id,
                       foreign_key: :id,
                       class_name: "User"

    validates do
      presence_of :event_type,
                  :user_id,
                  :workbasket_id

      inclusion_of :event_type, in: ::Workbaskets::Workbasket::STATUS_LIST.map(&:to_s)
    end
  end
end
