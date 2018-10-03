module WorkbasketInteractions
  module CreateGeographicalArea
    class SettingsSaver

      WORKBASKET_TYPE = "CreateGeographicalArea"

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
        workbasket.title = geographical_area_id
        workbasket.operation_date = operation_date.try(:to_date)
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
          @errors = ::WorkbasketInteractions::CreateGeographicalArea::InlineValidator.new(
            settings_params
          ).fetch_errors
        end
    end
  end
end
