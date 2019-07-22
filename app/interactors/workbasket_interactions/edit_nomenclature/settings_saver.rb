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
        workbasket.save
        workbasket.settings.description = @settings_params[:description]
        workbasket.settings.save

        create_nomenclature_description!
      end

      private

      def create_nomenclature_description!
        @records = []
        original_nomenclature = Commodity.find(goods_nomenclature_sid: workbasket.settings.original_nomenclature)

        GoodsNomenclatureDescriptionPeriod.unrestrict_primary_key
        goods_nomenclature_description_period = GoodsNomenclatureDescriptionPeriod.new(
          goods_nomenclature_sid: original_nomenclature.goods_nomenclature_sid,
          goods_nomenclature_item_id: original_nomenclature.goods_nomenclature_item_id,
          productline_suffix: original_nomenclature.producline_suffix,
          validity_start_date: workbasket.settings.validity_start_date
        )
        ::WorkbasketValueObjects::Shared::PrimaryKeyGenerator.new(goods_nomenclature_description_period).assign!
        goods_nomenclature_description_period_sid = goods_nomenclature_description_period.goods_nomenclature_description_period_sid
        @records << goods_nomenclature_description_period

        GoodsNomenclatureDescription.unrestrict_primary_key
        goods_nomenclature_description = GoodsNomenclatureDescription.new(
          language_id: 'EN',
          goods_nomenclature_description_period_sid: goods_nomenclature_description_period.goods_nomenclature_description_period_sid,
          goods_nomenclature_sid: original_nomenclature.goods_nomenclature_sid,
          goods_nomenclature_item_id: original_nomenclature.goods_nomenclature_item_id,
          productline_suffix: original_nomenclature.producline_suffix,
          description: workbasket.settings.description
        )
        @records << goods_nomenclature_description

        operation_date = workbasket.settings.validity_start_date
        save_nomenclature_description!
      end

      def save_nomenclature_description!
        records.each do |record|
          assign_system_ops!(record)
          record.save
        end
      end

    end
  end
end
