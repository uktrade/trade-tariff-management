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

    expose(:quota_periods) do
      start = Date.today + 1.day

      [
        OpenStruct.new(
          validity_start_date: start,
          validity_end_date: start + 1.year,
          initial_volume: "4325 Kilogram Net",
          critical_state: true,
          critical_threshold: "90%"
        ),
        OpenStruct.new(
          validity_start_date: start + 1.year + 1.day,
          validity_end_date: start + 2.years,
          initial_volume: "1000 Kilogram Net",
          critical_state: true,
          critical_threshold: "90%"
        ),
        OpenStruct.new(
          validity_start_date: start + 2.year + 1.day,
          validity_end_date: start + 3.years,
          initial_volume: "1325 Kilogram Net",
          critical_state: true,
          critical_threshold: "90%"
        ),
        OpenStruct.new(
          validity_start_date: start + 3.year + 1.day,
          validity_end_date: start + 4.years,
          initial_volume: "2220 Kilogram Net",
          critical_state: true,
          critical_threshold: "90%"
        ),
        OpenStruct.new(
          validity_start_date: start + 4.year + 1.day,
          validity_end_date: start + 5.years,
          initial_volume: "1567 Kilogram Net",
          critical_state: true,
          critical_threshold: "90%"
        ),
        OpenStruct.new(
          validity_start_date: start + 5.year + 1.day,
          validity_end_date: start + 6.years,
          initial_volume: "3450 Kilogram Net",
          critical_state: true,
          critical_threshold: "90%"
        ),
      ]
    end

    private

      def check_if_action_is_permitted!
        # if !step_pointer.main_step? &&
        #    !workbasket_settings.validations_passed?(previous_step)

        #   redirect_to previous_step_url
        #   return false
        # end
      end

      def workbasket_data_can_be_persisted?
        step_pointer.conditions_footnotes? &&
        saver_mode == 'continue'
      end
  end
end
