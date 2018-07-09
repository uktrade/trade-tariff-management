module Workbaskets
  class CreateMeasuresController < Measures::BulksBaseController

    before_action :require_to_be_workbasket_owner!, only: [
      :edit, :update
    ]

    expose(:create_measures_settings) do
      workbasket.create_measures_settings
    end

    def create
      self.workbasket = Workbaskets::Workbasket.new(
        status: :new,
        type: :create_measures,
        user: current_user
      )
      workbasket.save

      redirect_to edit_create_measure_url(workbasket)
    end

    def update
      workbasket.
    end
  end
end
