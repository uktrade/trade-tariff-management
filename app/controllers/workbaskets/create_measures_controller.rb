module Workbaskets
  class CreateMeasuresController < Measures::BulksBaseController

    before_action :require_to_be_workbasket_owner!, only: [
      :edit, :update
    ]

    expose(:current_step) { params[:step] }

    expose(:workbasket_settings) do
      workbasket.create_measures_settings
    end

    expose(:workbasket_step_settings) do
      workbasket_settings.step_settings(current_step)
    end

    expose(:workbasket_has_previous_step?) do
      step_in?(saver_class::PREVIOUS_STEP_POINTERS)
    end

    expose(:workbasket_has_next_step?) do
      step_in?(saver_class::NEXT_STEP_POINTERS)
    end

    expose(:saver_class) do
      Workbaskets::CreateMeasures::SettingsSaver
    end

    expose(:settings_params) do
      ops = params[:settings]
      ops.send("permitted=", true)
      ops = ops.to_h

      ops
    end

    expose(:saver) do
      saver_class.new(
        workbasket,
        current_step,
        settings_params
      )
    end

    expose(:form) do
      Workbaskets::CreateMeasures::Form.new(
        Measure.new
      )
    end

    expose(:workbasket_items) do
       Workbaskets::Item.all.select { |i| i.new_data_parsed.present? }[0..15].map do |item|
        item.new_data_parsed
      end
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
      saver.save!

      if saver.valid?
        render json: saver.success_ops,
               status: :ok
      else
        render json: {
          errors: saver.errors,
          candidates_with_errors: saver.candidates_with_errors
        }, status: :unprocessable_entity
      end
    end

    private

      def step_in?(list)
        current_step.in?(list)
      end
  end
end
