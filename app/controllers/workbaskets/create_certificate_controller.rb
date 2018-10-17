# frozen_string_literal: true

module Workbaskets
  class CreateCertificateController < Workbaskets::BaseController

    expose(:sub_klass) { "CreateCertificate" }
    expose(:settings_type) { :create_certificate }

    expose(:initial_step_url) do
      edit_create_certificate_url(
        workbasket.id,
        step: :main
      )
    end

    expose(:read_only_section_url) do
      create_certificate_url(workbasket.id)
    end

    expose(:submitted_url) do
      submitted_for_cross_check_create_certificate_url(workbasket.id)
    end

    expose(:form) do
      Workbaskets::CreateCertificateForm.new
    end

    expose(:certificate) do
      workbasket_settings.collection.first
    end

    def update
      saver.save!

      if saver.valid?
        handle_success_saving!
      else
        workbasket_settings.track_step_validations_status!(current_step, false)

        render json: {
          step: current_step,
          errors: saver.errors
        }, status: :unprocessable_entity
      end
    end
  end
end
