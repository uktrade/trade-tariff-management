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
        handle_errors!
      end
    end

    def validate_group_memberships
      handle_validate_request!(
        ::WorkbasketServices::GeographicalArea::GroupMembershipsValidator
      )
    end

    def validate_country_or_region_memberhips
      handle_validate_request!(
        ::WorkbasketServices::GeographicalArea::CountryOrRegionMembershipsValidator
      )
    end

    def validate_membership
      handle_validate_request!(
        ::WorkbasketServices::GeographicalArea::MembershipValidator
      )
    end

    private

      def check_if_action_is_permitted!
        true
      end

      def workbasket_data_can_be_persisted?
        true
      end

      def handle_validate_request!(validator)
        if validator.valid?
          render json: {},
                 status: :ok
        else
          render json: {
            step: current_step,
            errors: validator.errors
          }, status: :unprocessable_entity
        end
      end
  end
end
