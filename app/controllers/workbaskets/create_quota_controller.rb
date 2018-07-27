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
  end
end
