module Measures
  class BulkItemsController < Measures::BulksBaseController

    before_action :require_to_be_workbasket_owner!, only: [
      :remove_items
    ]

    expose(:workbasket_item) do
      workbasket_items.where(record_id: params[:measure_sid])
                      .first
    end

    def remove_items
      # TODO

      render json: {}, head: :ok
    end
  end
end
