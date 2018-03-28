class MeasuresController < ApplicationController
  def index
    @measures = Measure.paginate(params[:page] || 1, 25)
  end

  def new
    @form = MeasureForm.new(Measure.new)
  end

  def create
    Rails.logger.info ""
    Rails.logger.info "-" * 100
    Rails.logger.info ""
    Rails.logger.info " #{params[:measure].to_yaml}"
    Rails.logger.info ""
    Rails.logger.info "-" * 100
    Rails.logger.info ""

    render nothing: true
  end
end
