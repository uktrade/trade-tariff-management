module WorkbasketInteractions
  module EditNomenclature
    class SettingsSaver
      include ::WorkbasketHelpers::SettingsSaverHelperMethods

      attr_accessor :current_step,
                    :save_mode,
                    :settings,
                    :workbasket,
                    :settings_params,
                    :errors,
                    :conformance_errors,
                    :errors_summary,
                    :attrs_parser,
                    :initial_validator,
                    :original_nomenclature,
                    :goods_nomenclature,
                    :goods_nomenclature_description,
                    :goods_nomenclature_description_period,
                    :next_goods_nomenclature_description,
                    :next_goods_nomenclature_description_period,
                    :persist

      def initialize(workbasket, current_step, save_mode, settings_ops = {})
        @workbasket = workbasket
        @save_mode = save_mode
        @current_step = current_step
        @settings = workbasket.settings
        @settings_params = ActiveSupport::HashWithIndifferentAccess.new(settings_ops)

        clear_cached_sequence_number!

        @persist = true # For now it always true
        @errors = {}
        @errors_summary = {}
        @conformance_errors = {}
      end

      def save!

        workbasket.save
        workbasket.settings.description = @settings_params[:description]
        workbasket.settings.save
      end

    end
  end
end
