module Measures
  class AttributesNormalizer

    include ::CustomLogger

    ALIASES = {
      start_date: :validity_start_date,
      end_date: :validity_end_date,
      quota_ordernumber: :ordernumber,
      goods_nomenclature_code: :method_goods_nomenclature_item_values,
      additional_code: :method_additional_code_values,
      regulation_id: :method_regulation_values,
      geographical_area_id: :method_geographical_area_values
    }

    WHITELIST_PARAMS = %w(
      start_date
      end_date
      goods_nomenclature_code
      quota_ordernumber
      measure_type_id
      regulation_id
      geographical_area_id
      additional_code
    )

    attr_accessor :normalized_params, :measure_params

    def initialize(measure_params)
      @measure_params = measure_params
      @normalized_params = {}

      whitelist = measure_params.select do |k, v|
        WHITELIST_PARAMS.include?(k) && v.present?
      end

      whitelist.map do |k, v|
        if ALIASES.keys.include?(k.to_sym)
          if ALIASES[k.to_sym].to_s.starts_with?("method_")
            @normalized_params.merge!(
              send(ALIASES[k.to_sym], measure_params[k])
            )
          else
            @normalized_params[ALIASES[k.to_sym]] = v
          end
        else
          @normalized_params[k] = v
        end
      end

      @normalized_params
    end

    private

      def method_additional_code_values(additional_code_id)
        additional_code = AdditionalCode.actual.where(
          additional_code: additional_code_id,
          additional_code_type_id: measure_params[:additional_code_type_id]
        ).first

        {
          additional_code_type_id: additional_code.additional_code_type_id,
          additional_code_sid: additional_code.additional_code_sid,
          additional_code_id: additional_code_id
        }
      end

      def method_regulation_values(base_regulation_id)
        regulation = BaseRegulation.actual
                                   .not_replaced_and_partially_replaced
                                   .where(base_regulation_id: base_regulation_id).first

        if regulation.present?
          role = regulation.base_regulation_role
        else
          regulation = ModificationRegulation.actual
                                             .not_replaced_and_partially_replaced
                                             .where(modification_regulation_id: base_regulation_id).first
          role = regulation.modification_regulation_role
        end

        ops = {
          measure_generating_regulation_id: base_regulation_id,
          measure_generating_regulation_role: role
        }

        if normalized_params[:validity_end_date].present?
          ops[:justification_regulation_id] = base_regulation_id
          ops[:justification_regulation_role] = role
        end

        ops
      end

      def method_geographical_area_values(geographical_area_id)
        geographical_area = GeographicalArea.actual
                                            .where(geographical_area_id: geographical_area_id).first

        {
          geographical_area_id: geographical_area_id,
          geographical_area_sid: geographical_area.geographical_area_sid
        }
      end

      def method_goods_nomenclature_item_values(goods_nomenclature_item_id)
        goods_nomenclature = GoodsNomenclature.actual
                                              .where(goods_nomenclature_item_id: goods_nomenclature_item_id)
                                              .first
                                              .try(:sti_instance)

        {
          goods_nomenclature_item_id: goods_nomenclature_item_id,
          goods_nomenclature_sid: goods_nomenclature.goods_nomenclature_sid
        }
      end
  end
end