module WorkbasketInteractions
  module EditNomenclatureDates
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
                    :persist,
                    :records

      def initialize(workbasket, current_step, save_mode, settings_ops = {})
        @workbasket = workbasket
        @save_mode = save_mode
        @current_step = current_step
        @settings = workbasket.settings
        @settings_params = ActiveSupport::HashWithIndifferentAccess.new(settings_ops)

        clear_cached_sequence_number!

        @persist = true
        @errors = {}
        @errors_summary = {}
        @conformance_errors = {}
      end

      def save!
        workbasket.settings.validity_start_date = @settings_params[:validity_start_date]
        workbasket.settings.validity_end_date = @settings_params[:validity_end_date]

        workbasket.settings.save
        if valid?
          edit_nomenclature_dates!
        else
          false
        end
      end

      def valid?
        validate!
        errors.blank? && conformance_errors.blank?
      end

      private

      def set_date
        Date.new(@settings_params["validity_start_date_year"].to_i, @settings_params["validity_start_date_month"].to_i, @settings_params["validity_start_date_day"].to_i)
      rescue ArgumentError
        nil
      end

      def validate!
        check_initial_validation_rules!
        check_conformance_rules! if @errors.blank?
      end

      def check_initial_validation_rules!
        @initial_validator = ::WorkbasketInteractions::EditNomenclatureDates::InitialValidator.new(
          workbasket.settings
        )

        @errors = initial_validator.fetch_errors
        @errors_summary = initial_validator.errors_summary
      end


      def edit_nomenclature_dates!
        @records = []
        original_nomenclature = GoodsNomenclature.find(goods_nomenclature_sid: workbasket.settings.original_nomenclature)

        if original_nomenclature.validity_start_date != workbasket.settings.validity_start_date
          edit_nomenclature_description_period!
          edit_nomenclature_indents!
        end

        #GoodsNomenclatureDescription.unrestrict_primary_key
        @edited_goods_nomenclature = original_nomenclature
        @edited_goods_nomenclature.validity_start_date = workbasket.settings.validity_start_date
        @edited_goods_nomenclature.validity_end_date = workbasket.settings.validity_end_date
        @records << @edited_goods_nomenclature

        operation_date = workbasket.settings.validity_start_date
        save_nomenclature!

      end

      def edit_nomenclature_description_period!
        desc_period = GoodsNomenclatureDescriptionPeriod.where(goods_nomenclature_sid: workbasket.settings.original_nomenclature).first
        desc_period.validity_start_date = workbasket.settings.validity_start_date
        @records << desc_period
      end

      def edit_nomenclature_indents!
        indent = GoodsNomenclatureIndent.where(goods_nomenclature_sid: workbasket.settings.original_nomenclature).first
        indent.validity_start_date = workbasket.settings.validity_start_date
        @records << indent
      end

      def check_conformance_rules!
        Sequel::Model.db.transaction(@do_not_rollback_transactions.present? ? {} : { rollback: :always }) do
          edit_nomenclature_dates!

          parse_and_format_conformance_rules
        end
      end

      def parse_and_format_conformance_rules
        @conformance_errors = {}

        unless @edited_goods_nomenclature.conformant?
          @conformance_errors.merge!(get_conformance_errors(@edited_goods_nomenclature))
        end

        if conformance_errors.present?
          @errors_summary = initial_validator.errors_translator(:summary_conformance_rules)
        end
      end

      def get_conformance_errors(record)
        res = {}

        record.conformance_errors.map do |k, v|
          message = if v.is_a?(Array)
                      v.flatten.join(' ')
                    else
                      v
                    end

          res[k.to_s] = "<strong class='workbasket-conformance-error-code'>#{k}</strong>: #{message}".html_safe
        end

        res
      end

      def save_nomenclature!
        records.each do |record|
          ::WorkbasketValueObjects::Shared::SystemOpsAssigner.new(
            record, system_ops.merge(operation: "U")
          ).assign!(false)
          record.save
        end
      end
    end
  end
end
