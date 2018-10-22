module Measures
  class BulkItemsController < Measures::BulksBaseController

    before_action :require_to_be_workbasket_owner!, only: [
      :remove_items
    ]

    expose(:workbasket_item) do
      workbasket_items.detect do |item|
        params[:measure_sid].in?([item.record_id.to_s, item.row_id])
      end
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
