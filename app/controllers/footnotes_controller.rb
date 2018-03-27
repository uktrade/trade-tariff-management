class FootnotesController < ApplicationController
  respond_to :json

  def index
    footnotes = Footnote.join_table(:inner, :footnote_descriptions, footnote_id: Sequel[:footnotes][:footnote_id], footnote_type_id: params[:footnote_type_id])
                        .where(Sequel[:footnotes][:footnote_type_id] => params[:footnote_type_id])
                        .where(Sequel.like(:description, params[:description] + "%"))
                        .limit(20)
    json = []

    puts footnotes.sql

    footnotes.each do |footnote|

      json << {
        footnote_type_id: footnote.footnote_type_id,
        footnote_id: footnote.footnote_id,
        description: footnote.description
      }
    end

    render json: json
  end
end
