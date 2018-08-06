module Workbaskets
  class CreateQuotaController < Workbaskets::BaseController

    expose(:sub_klass) { "CreateQuota" }
    expose(:settings_type) { :create_quota }

    expose(:initial_step_url) do
      edit_create_quotum_url(
        workbasket.id,
        step: :main
      )
    end

    expose(:previous_step_url) do
      edit_create_quotum_url(
        workbasket.id,
        step: previous_step
      )
    end

    expose(:read_only_section_url) do
      create_quotum_url(workbasket.id)
    end

    private

      def check_if_action_is_permitted!
        if !step_pointer.main_step? &&
           !workbasket_settings.validations_passed?(previous_step)

          redirect_to previous_step_url
          return false
        end
      end

      def workbasket_data_can_be_persisted?
        step_pointer.conditions_footnotes? &&
        saver_mode == 'continue'
      end
  end
end
