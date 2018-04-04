module Footnotes
  class FootnotesController < ::BaseController

    def collection
      Footnote.actual
              .q_search(params[:footnote_type_id], params[:description])
    end
  end
end
