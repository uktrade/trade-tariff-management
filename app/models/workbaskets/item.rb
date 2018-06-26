module Workbaskets
  class Item < Sequel::Model(:workbasket_items)

    STATES = [
      :in_progress,
      :submitted,
      :rejected
    ]

    many_to_one :workbasket, key: :workbasket_id,
                             foreign_key: :id

    validates do
      presence_of :status,
                  :workbasket_id,
                  :record_id,
                  :record_key,
                  :record_type

      inclusion_of :status, in: STATES.map(&:to_s)
    end

    def hash_data
      JSON.parse(data)
    end

    def record
      record_type.constantize
                 .where(record_key.to_sym => record_id)
                 .first
    end
  end
end
