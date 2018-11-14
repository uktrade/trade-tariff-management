module Quotas
  class BulkItemsController < Measures::BulksBaseController

    before_action :require_to_be_workbasket_owner!, only: [
      :remove_items
    ]

    expose(:workbasket_item) do
      workbasket_items.where(row_id: params[:row_id])
          .first
    end

    expose(:candidates_to_remove) do
      workbasket_items.where(record_id: params["_json"])
                      .all
    end

    def remove_items
      candidates_to_remove.map(&:delete)

      render json: {
        number_of_removed_measures: candidates_to_remove.size
      }, head: :ok
    end
  end
end
