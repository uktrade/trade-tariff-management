module WorkbasketForms
  class CreateAdditionalCodeForm < ::WorkbasketForms::BaseForm
    def additional_code_types
      AdditionalCodeType.actual.order(:additional_code_type_id).all.map do |c|
        {
            additional_code_type_id: c.additional_code_type_id,
            description: c.formatted_description
        }
      end
    end
  end
end
