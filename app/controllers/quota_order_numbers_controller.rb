class QuotaOrderNumbersController < ::BaseController
  def collection
    QuotaOrderNumber.actual
                    .q_search(params[:q])
  end
end
