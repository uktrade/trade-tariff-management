module Footnotes
  class FootnotesController < ::BaseController

    expose(:filter_ops) do
      ops = {}

      if params[:footnote_type_id].present?
        ops[:footnote_type_id] = params[:footnote_type_id]
      end
      ops[:description] = params[:description] if params[:description].present?

      ops
    end

    def collection
      Footnote.q_search(filter_ops)
    end
  end
end
