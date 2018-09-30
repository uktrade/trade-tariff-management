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
                    :attrs_parser,
                    :errors,
                    :candidates_with_errors

      def initialize(workbasket, current_step, save_mode, settings_ops={})
        @workbasket = workbasket
        @save_mode = save_mode
        @current_step = current_step
        @settings = workbasket.settings
        @settings_params = ActiveSupport::HashWithIndifferentAccess.new(settings_ops)
        @errors = {}

        clear_cached_sequence_number!
      end

      def valid?
        validate!
        @errors.blank?
      end

      def save!
        workbasket.title = workbasket_name
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
          general_errors = {}

          if general_errors.present?
            general_errors.map do |k, v|
              @errors[k] = v
            end
          end
        end
    end
  end
end
