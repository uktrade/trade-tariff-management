module AdditionalCodes
  class AdditionalCodesController < ::BaseController

    expose(:filter_ops) do
      ops = {}

      if params[:additional_code_type_id].present?
        ops[:additional_code_type_id] = params[:additional_code_type_id]
      end
      ops[:q] = params[:q] if params[:q].present?

      ops
    end

    def collection
      AdditionalCode.q_search(filter_ops)
    end
  end
end
