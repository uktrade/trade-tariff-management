module Footnotes
  class FootnoteTypesController < ::BaseController
    def collection
      FootnoteType.q_search(params[:q])
    end
  end
end
