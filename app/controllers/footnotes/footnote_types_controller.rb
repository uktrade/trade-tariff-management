module Footnotes
  class FootnoteTypesController < ::BaseController
    def collection
      FootnoteType.q_search(params[:q]).eager(:footnote_type_description).all
    end
  end
end
