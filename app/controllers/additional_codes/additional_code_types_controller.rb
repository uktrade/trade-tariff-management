module AdditionalCodes
  class AdditionalCodeTypesController < ::BaseController

    expose(:measure_type) do
      MeasureType.actual
                 .where(measure_type_id: params[:measure_type_id])
                 .first
    end

    def collection
      if measure_type.present?
        scope = measure_type.additional_code_types
      else
        scope = AdditionalCodeType.actual.order(:additional_code_type_id)
      end

      if params[:q].present?
        q_rule = params[:q].strip.downcase

        debugger

        scope = scope.select do |ac_type|
          ilike?(:additional_code_type_id, q_rule) ||
          ilike?(:description, q_rule)
        end
      end

      scope
    end
  end
end
