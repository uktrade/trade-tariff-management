module AdditionalCodes
  class AdditionalCodeTypesController < ::BaseController

    expose(:measure_type) do
      MeasureType.actual
                 .where(measure_type_id: params[:measure_type_id])
                 .first
    end

    def collection
      scope = measure_type.additional_code_types

      if params[:q].present?
        scope = scope.select do |ac_type|
          ac_type.additional_code_type_id.starts_with?(params[:q].strip)
        end
      end

      scope
    end
  end
end
