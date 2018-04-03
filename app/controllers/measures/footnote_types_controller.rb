module Measures
  class FootnoteTypesController < ::Measures::BaseController

    def collection
      FootnoteType.actual
    end
  end
end
