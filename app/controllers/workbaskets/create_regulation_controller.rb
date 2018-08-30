module Workbaskets
  class CreateRegulationController < Workbaskets::BaseController

    expose(:sub_klass) { "CreateRegulation" }
    expose(:settings_type) { :create_regulation }

    expose(:initial_step_url) do
      edit_create_regulation_url(
          workbasket.id,
          step: :main
      )
    end

    private

    def check_if_action_is_permitted!
      true
    end

    def workbasket_data_can_be_persisted?
      saver_mode == 'continue'
    end

  end
end
