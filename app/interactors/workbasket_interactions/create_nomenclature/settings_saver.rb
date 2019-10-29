module WorkbasketInteractions
  module CreateNomenclature
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
                    :goods_nomenclature_item_id,
                    :producline_suffix,
                    :validity_start_date,
                    :original_nomenclature,
                    :goods_nomenclature,
                    :number_indents,
                    :goods_nomenclature_description,
                    :goods_nomenclature_description_period,
                    :origin_code,
                    :origin_suffix,
                    :next_goods_nomenclature_description,
                    :next_goods_nomenclature_description_period,
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

        @goods_nomenclature_item_id = @settings_params[:goods_nomenclature_item_id]
        @producline_suffix = @settings_params[:producline_suffix]
        @validity_start_date = date_from_params("validity_start_date", @settings_params)
        @number_indents = @settings_params[:number_indents]
        @goods_nomenclature_description = @settings_params[:description]
        @origin_code = @settings_params[:origin_code]
        @origin_suffix = @settings_params[:origin_producline_suffix]

        @persist = true # For now it always true
        @errors = {}
        @errors_summary = {}
        @conformance_errors = {}
      end

      def save!
        workbasket.settings.description = @goods_nomenclature_description
        workbasket.settings.validity_start_date = set_date
        workbasket.settings.goods_nomenclature_item_id = @goods_nomenclature_item_id
        workbasket.settings.producline_suffix = @producline_suffix
        workbasket.settings.number_indents = @number_indents
        workbasket.settings.origin_nomenclature = @origin_code
        workbasket.settings.origin_producline_suffix = @origin_suffix

        workbasket.settings.save
        # valid?
        persist!
      end

      def valid?
        validate!
        errors.blank? && conformance_errors.blank?
      end

      def persist!
        @do_not_rollback_transactions = true
        validate!
        workbasket.save
      end

      private

      def set_date
        Date.new(@settings_params["validity_start_date_year"].to_i, @settings_params["validity_start_date_month"].to_i, @settings_params["validity_start_date_day"].to_i)
      rescue ArgumentError
        nil
      end

      def validate!
        check_initial_validation_rules!
        check_conformance_rules! if errors.blank?
      end

      def check_initial_validation_rules!
        @initial_validator = ::WorkbasketInteractions::CreateNomenclature::InitialValidator.new(
          workbasket.settings
        )

        @errors = initial_validator.fetch_errors
        @errors_summary = initial_validator.errors_summary
      end


      def check_conformance_rules!
        Sequel::Model.db.transaction(@do_not_rollback_transactions.present? ? {} : { rollback: :always }) do
          add_goods_nomenclature!
          add_goods_nomenclature_indent!
          add_goods_nomenclature_description!
          add_goods_nomenclature_origin!

          parse_and_format_conformance_rules
        end
      end

      def add_goods_nomenclature!
        GoodsNomenclature.unrestrict_primary_key
        @goods_nomenclature = GoodsNomenclature.new(
          goods_nomenclature_item_id: @goods_nomenclature_item_id,
          producline_suffix: @producline_suffix,
          validity_start_date: @validity_start_date,
          statistical_indicator: 0
        )

        assign_system_ops!(@goods_nomenclature)
        set_primary_key!(@goods_nomenclature)

        @goods_nomenclature.save #if persist_mode?
      end

      def add_goods_nomenclature_indent!
        GoodsNomenclatureIndent.unrestrict_primary_key
        goods_nomenclature_indent = GoodsNomenclatureIndent.new(
          goods_nomenclature_sid: @goods_nomenclature.goods_nomenclature_sid,
          validity_start_date: @validity_start_date,
          number_indents: @number_indents,
          goods_nomenclature_item_id: @goods_nomenclature_item_id,
          productline_suffix: @producline_suffix
        )

        assign_system_ops!(goods_nomenclature_indent)
        set_primary_key!(goods_nomenclature_indent)

        goods_nomenclature_indent.save #if persist_mode?
      end

      def add_goods_nomenclature_description!
        GoodsNomenclatureDescriptionPeriod.unrestrict_primary_key
        goods_nomenclature_description_period = GoodsNomenclatureDescriptionPeriod.new(
          goods_nomenclature_sid: @goods_nomenclature.goods_nomenclature_sid,
          validity_start_date: @validity_start_date,
          productline_suffix: @producline_suffix,
          goods_nomenclature_item_id: @goods_nomenclature_item_id,
          productline_suffix: @producline_suffix,
          )

        assign_system_ops!(goods_nomenclature_description_period)
        set_primary_key!(goods_nomenclature_description_period)

        goods_nomenclature_description_period.save #if persist_mode?

        GoodsNomenclatureDescription.unrestrict_primary_key
        goods_nomenclature_description = GoodsNomenclatureDescription.new(
          goods_nomenclature_description_period_sid: goods_nomenclature_description_period.goods_nomenclature_description_period_sid,
          language_id: 'EN',
          goods_nomenclature_sid: @goods_nomenclature.goods_nomenclature_sid,
          goods_nomenclature_item_id: @goods_nomenclature_item_id,
          productline_suffix: @producline_suffix,
          description: @goods_nomenclature_description
        )

        assign_system_ops!(goods_nomenclature_description)

        goods_nomenclature_description.save #if persist_mode?
      end

      def add_goods_nomenclature_origin!
        GoodsNomenclatureOrigin.unrestrict_primary_key
        goods_nomenclature_origin = GoodsNomenclatureOrigin.new(
          goods_nomenclature_sid: @goods_nomenclature.goods_nomenclature_sid,
          derived_goods_nomenclature_item_id: @origin_code,
          derived_productline_suffix: @origin_suffix,
          goods_nomenclature_item_id: @goods_nomenclature_item_id,
          productline_suffix: @producline_suffix
        )

        assign_system_ops!(goods_nomenclature_origin)
        # set_primary_key!(goods_nomenclature_origin)

        goods_nomenclature_origin.save #if persist_mode?
      end

      def parse_and_format_conformance_rules
        @conformance_errors = {}

        unless goods_nomenclature.conformant?
          @conformance_errors.merge!(get_conformance_errors(goods_nomenclature))
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

      def save_nomenclature_description!
        records.each do |record|
          ::WorkbasketValueObjects::Shared::SystemOpsAssigner.new(
            record, system_ops.merge(operation: record[:operation])
          ).assign!
          record.save
        end
      end

      private def date_from_params(field, params)
        if params["#{field}_year"].present?
          Date.new(params["#{field}_year"].to_i, params["#{field}_month"].to_i, params["#{field}_day"].to_i)
        end
      end
    end
  end
end
