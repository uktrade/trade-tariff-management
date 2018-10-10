module WorkbasketInteractions
  module CreateGeographicalArea
    class SettingsSaver

      include ::WorkbasketHelpers::SettingsSaverHelperMethods

      attr_accessor :current_step,
                    :save_mode,
                    :settings,
                    :workbasket,
                    :settings_params,
                    :errors

      def initialize(workbasket, current_step, save_mode, settings_ops={})
        @workbasket = workbasket
        @save_mode = save_mode
        @current_step = current_step
        @settings = workbasket.settings
        @settings_params = ActiveSupport::HashWithIndifferentAccess.new(settings_ops)

        clear_cached_sequence_number!
      end

      def valid?
        validate!
        @errors.blank?
      end

      def save!
        workbasket.title = settings_params[:geographical_area_id]
        workbasket.operation_date = settings_params[:operation_date].try(:to_date)
        workbasket.save

        settings.set_settings_for!(current_step, settings_params)
      end

      def persist!
        @persist = true
        validate!

        settings.save
      end

      def success_ops
        {}
      end

      private

        def validate!
          check_initial_validation_rules!
          check_conformance_rules!
        end

        def check_initial_validation_rules!
          @errors = ::WorkbasketInteractions::CreateGeographicalArea::InitialValidator.new(
            settings_params
          ).fetch_errors
        end

        def check_conformance_rules!
          add_geographical_area!
          add_geographical_area_description_period!
          add_geographical_area_description!
        end

        def add_geographical_area!
          @geographical_area = GeographicalArea.new(
            geographical_area_id: '2WAW',
            geographical_code: "0",
            validity_start_date: Date.today,
            validity_end_date: Date.today + 3.days
          )

          @geographical_area.parent_geographical_area_group_sid = parent_geographical_area_sid
        end

        def add_geographical_area_description_period!
          @geographical_area_description_period = GeographicalAreaDescriptionPeriod.new(
            geographical_area_id: geographical_area.geographical_area_id,
            validity_start_date: geographical_area.validity_start_date,
            validity_end_date: geographical_area.validity_end_date
          )

          @geographical_area_description_period.geographical_area_sid = geographical_area.geographical_area_sid
        end

        def add_geographical_area_description!
          @geographical_area_description = GeographicalAreaDescription.new(
            geographical_area_id: geographical_code.geographical_area_id,
            validity_start_date: validity_start_date,
            validity_end_date: validity_end_date
          )

          @geographical_area_description.geographical_area_sid = geographical_area.geographical_area_sid
          @geographical_area_description.geographical_area_description_period_sid = geographical_area_description_period.geographical_area_description_period_sid
        end
    end
  end
end
