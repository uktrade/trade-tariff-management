module Workbaskets
  class CreateMeasuresController < Measures::BulksBaseController

    before_action :require_to_be_workbasket_owner!, only: [
      :edit, :update
    ]

    expose(:create_measures_settings) do
      workbasket.create_measures_settings
    end

    expose(:saver) do
      Workbaskets::CreateMeasures::Saver.new(
        params[:measure]
      )
    end

    expose(:form) do
      Workbaskets::CreateMeasures::Form.new(Measure.new)
    end

    def create
      self.workbasket = Workbaskets::Workbasket.new(
        type: :create_measures,
        user: current_user
      )
      workbasket.save

      redirect_to edit_create_measure_url(workbasket.id)
    end

    def update
      create_measures_settings.update(params)
    end
  end
end
