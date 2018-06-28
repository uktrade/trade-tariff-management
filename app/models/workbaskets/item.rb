module Workbaskets
  class Item < Sequel::Model(:workbasket_items)

    STATES = [
      :in_progress,
      :submitted,
      :rejected
    ]

    plugin :timestamps

    many_to_one :workbasket, key: :workbasket_id,
                             foreign_key: :id

    validates do
      presence_of :status,
                  :workbasket_id,
                  :record_id,
                  :record_key,
                  :record_type

      inclusion_of :status, in: STATES.map(&:to_s)

      uniqueness_of [
        :workbasket_id,
        :record_id,
        :record_key,
        :record_type
      ]
    end

    dataset_module do
      def by_workbasket(workbasket)
        where(workbasket_id: workbasket.id)
      end

      include ::BulkEditHelpers::OrderByIdsQuery
    end

    def hash_data
      JSON.parse(data)
    end

    def record
      record_type.constantize
                 .where(record_key.to_sym => record_id)
                 .first
    end

    class << self
      def create_from_target_record(workbasket, target_record)
        item = new(workbasket_id: workbasket.id)

        key = target_record.primary_key
        item.record_key = key
        item.record_id = target_record.public_send(key)
        item.record_type = target_record.class.to_s
        item.data = target_record.to_json.to_json
        item.status = "in_progress"

        item.save
      end
    end
  end
end
