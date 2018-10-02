module Workbaskets
  class CreateGeographicalAreaController < Workbaskets::BaseController

    expose(:sub_klass) { "CreateGeographicalArea" }
    expose(:settings_type) { :create_geographical_area }

    expose(:initial_step_url) do
      edit_create_geographical_area_url(
        workbasket.id,
        step: :main
      )
    end

    expose(:read_only_section_url) do
      create_geographical_area_url(workbasket.id)
    end

    expose(:submitted_url) do
      submitted_for_cross_check_create_geographical_area_url(workbasket.id)
    end

    expose(:form) do
      WorkbasketForms::CreateGeographicalAreaForm.new
    end

    expose(:geographical_area) do
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

    def validate_group_memberships
      handle_validate_request!(
        ::WorkbasketServices::GeographicalAreaSavers::GroupMemberships
      )
    end

    def validate_country_or_region_memberhips
      handle_validate_request!(
        ::WorkbasketServices::GeographicalAreaSavers::CountryOrRegionMemberships
      )
    end

    def validate_membership
      handle_validate_request!(
        ::WorkbasketServices::GeographicalAreaSavers::Membership
      )
    end

    private

      def handle_validate_request!(validator)
        if validator.valid?
          render json: {},
                 status: :ok
        else
          render json: {
            step: :main,
            errors: validator.errors
          }, status: :unprocessable_entity
        end
      end

      def check_if_action_is_permitted!
        true
      end

      def workbasket_data_can_be_persisted?
        true
      end
  end
end
