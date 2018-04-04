module Footnotes
  class FootnoteTypesController < ::BaseController

    def collection
      FootnoteType.actual
    end
  end
end
