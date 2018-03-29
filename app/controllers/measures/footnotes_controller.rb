module Measures
  class FootnotesController < ::Measures::BaseController

    def collection
      Footnote.actual
              .q_search(params[:footnote_type_id], params[:description])
              .limit(20)
    end
  end
end
