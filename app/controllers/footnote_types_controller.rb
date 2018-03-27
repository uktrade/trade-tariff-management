class FootnoteTypesController < ApplicationController
  respond_to :json

  def index
    types = FootnoteType.all
    json = []

    types.each do |type|

      json << {
        footnote_type_id: type.footnote_type_id,
        description: type.description
      }
    end

    render json: json
  end
end
