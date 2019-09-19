module WorkbasketInteractions
  module EditRegulation
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

                    :original_regulation,
                    :base_regulation_id,
                    :base_regulation_role,
                    :validity_start_date,
                    :validity_end_date,

                    :persist,
                    :operation_date,
                    :records

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
        workbasket.settings.workbasket_name = @settings_params[:workbasket_name]
        workbasket.settings.reason_for_changes = @settings_params[:reason_for_changes]
        workbasket.settings.base_regulation_id = @settings_params[:base_regulation_id]
        workbasket.settings.validity_start_date = @settings_params[:validity_start_date]
        workbasket.settings.validity_end_date = @settings_params[:validity_end_date]
        workbasket.settings.regulation_group_id = @settings_params[:regulation_group_id]

        workbasket.settings.save
        if valid?
          true
          # create_nomenclature_description!
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
        @initial_validator = ::WorkbasketInteractions::EditRegulation::InitialValidator.new(
          workbasket.settings
        )

        @errors = initial_validator.fetch_errors
        @errors_summary = initial_validator.errors_summary
      end


      # def create_nomenclature_description!
      #   @records = []
      #   original_nomenclature = GoodsNomenclature.find(goods_nomenclature_sid: workbasket.settings.original_nomenclature)
      #
      #
      #   @goods_nomenclature_description_period = find_existing_description_period(original_nomenclature, workbasket.settings.validity_start_date)
      #   description_operation = "U"
      #   if goods_nomenclature_description_period.nil?
      #     @records << create_description_period(original_nomenclature)
      #     description_operation = "C"
      #   end
      #
      #   GoodsNomenclatureDescription.unrestrict_primary_key
      #   @goods_nomenclature_description = GoodsNomenclatureDescription.new(
      #     language_id: 'EN',
      #     goods_nomenclature_description_period_sid: goods_nomenclature_description_period.goods_nomenclature_description_period_sid,
      #     goods_nomenclature_sid: original_nomenclature.goods_nomenclature_sid,
      #     goods_nomenclature_item_id: original_nomenclature.goods_nomenclature_item_id,
      #     productline_suffix: original_nomenclature.producline_suffix,
      #     operation: description_operation,
      #     description: workbasket.settings.description
      #   )
      #   @records << @goods_nomenclature_description
      #
      #   operation_date = workbasket.settings.validity_start_date
      #   save_nomenclature_description!
      # end

      # def find_existing_description_period(original_nomenclature, validity_start_date)
      #   GoodsNomenclatureDescriptionPeriod.find(goods_nomenclature_sid: original_nomenclature.goods_nomenclature_sid, validity_start_date: validity_start_date)
      # end

      # def create_description_period(original_nomenclature)
      #   GoodsNomenclatureDescriptionPeriod.unrestrict_primary_key
      #   @goods_nomenclature_description_period = GoodsNomenclatureDescriptionPeriod.new(
      #     goods_nomenclature_sid: original_nomenclature.goods_nomenclature_sid,
      #     goods_nomenclature_item_id: original_nomenclature.goods_nomenclature_item_id,
      #     productline_suffix: original_nomenclature.producline_suffix,
      #     validity_start_date: workbasket.settings.validity_start_date
      #   )
      #   ::WorkbasketValueObjects::Shared::PrimaryKeyGenerator.new(goods_nomenclature_description_period).assign!
      #   @goods_nomenclature_description_period
      # end

      def check_conformance_rules!
        Sequel::Model.db.transaction(@do_not_rollback_transactions.present? ? {} : { rollback: :always }) do
          # create_nomenclature_description!

          parse_and_format_conformance_rules
        end
      end

      def parse_and_format_conformance_rules
        @conformance_errors = {}

        # unless goods_nomenclature_description_period.conformant?
        #   @conformance_errors.merge!(get_conformance_errors(goods_nomenclature_description_period))
        # end

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

      # def save_nomenclature_description!
      #   records.each do |record|
      #     ::WorkbasketValueObjects::Shared::SystemOpsAssigner.new(
      #       record, system_ops.merge(operation: record[:operation])
      #     ).assign!
      #     record.save
      #   end
      # end
    end
  end
end
