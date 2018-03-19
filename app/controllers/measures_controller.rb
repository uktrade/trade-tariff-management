class MeasuresController < ApplicationController
  def index
    @measures = Measure.paginate(params[:page] || 1, 25)
  end

  def new
    @form = MeasureForm.new(Measure.new)
  end
end
