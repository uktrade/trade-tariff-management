module Footnotes
  class FootnotesController < ::BaseController

    def collection
      Footnote.q_search(params)
    end
  end
end
