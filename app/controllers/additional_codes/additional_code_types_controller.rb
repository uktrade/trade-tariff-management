module AdditionalCodes
  class AdditionalCodeTypesController < ::BaseController
    expose(:measure_type) do
      MeasureType.actual
                 .where(measure_type_id: params[:measure_type_id])
                 .first
    end

    def collection
      scope = if measure_type.present?
                measure_type.additional_code_types
              else
                AdditionalCodeType.actual.order(:additional_code_type_id).all
              end

      if params[:q].present?
        q_rule = params[:q].strip.downcase

        scope = scope.select do |ac_type|
          ilike?(ac_type.additional_code_type_id, q_rule) ||
            ilike?(ac_type.description, q_rule)
        end
      end

      scope
    end
  end
end
