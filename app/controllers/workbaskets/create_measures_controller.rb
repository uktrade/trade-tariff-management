module Workbaskets
  class CreateMeasuresController < Measures::BulksBaseController

    before_action :require_to_be_workbasket_owner!, only: [
      :edit, :update
    ]

    expose(:workbasket_has_previous_step?) do
      step_in?(
        %w(duties_conditions_footnotes review_and_submit)
      )
    end

    expose(:workbasket_has_next_step?) do
      step_in?(
        %w(main duties_conditions_footnotes)
      )
    end

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

      redirect_to edit_create_measure_url(workbasket.id, step: :main)
    end

    def update
      create_measures_settings.update(params)
    end

    private

      def step_in?(list)
        params[:step].in? list
      end
  end
end
