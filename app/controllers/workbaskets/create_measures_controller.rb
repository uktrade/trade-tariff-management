module Workbaskets
  class CreateMeasuresController < Measures::BulksBaseController

    before_action :require_to_be_workbasket_owner!, only: [
      :edit, :update
    ]

    expose(:saver_class) do
      Workbaskets::CreateMeasures::Saver
    end

    expose(:workbasket_has_previous_step?) do
      step_in?(saver_class::PREVIOUS_STEP_POINTERS)
    end

    expose(:workbasket_has_next_step?) do
      step_in?(saver_class::NEXT_STEP_POINTERS)
    end

    expose(:saver) do
      saver_class.new(
        params[:measure]
      )
    end

    expose(:form) do
      Workbaskets::CreateMeasures::Form.new(
        Measure.new
      )
    end

    def new
      self.workbasket = Workbaskets::Workbasket.buld_new_workbasket!(
        :create_measures, current_user
      )

      redirect_to edit_create_measure_url(
        workbasket.id,
        step: :main
      )
    end

    def update
      saver.persist!

      if saver.valid?
        render json: { next_step: saver.next_step },
               status: :ok
      else
        render json: { errors: saver.errors },
               status: :unprocessable_entity
      end
    end

    private

      def step_in?(list)
        params[:step].in?(list)
      end
  end
end
