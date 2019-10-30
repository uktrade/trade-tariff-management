module WorkbasketHelpers
  module Association
    extend ActiveSupport::Concern

    included do
      many_to_one :workbasket, key: :workbasket_id,
                               foreign_key: :id,
                               class_name: "Workbaskets::Workbasket"

      dataset_module do
        def by_workbasket(workbasket_id)
          where(workbasket_id: workbasket_id)
        end
      end
    end

    def move_status_to!(new_status)
      self.manual_add = true
      self.status = new_status

      mark_deleted if pending_deletion?(new_status)

      save
    end

    def already_end_dated?
      validity_end_date.present? &&
        validity_end_date <= Date.today.midnight
    end

    private def pending_deletion?(new_status)
      # Updates for Quota Associations are actually deletions.
      self.class == QuotaAssociation && self.operation == :update && new_status == 'published'
    end

    private def mark_deleted
      self.operation = 'D'
    end
  end
end
