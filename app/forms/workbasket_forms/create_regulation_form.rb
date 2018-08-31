module WorkbasketForms
  class CreateRegulationForm < ::WorkbasketForms::BaseForm

    attr_accessor :role,
                  :base_regulation_role

    def regulation_roles
      RegulationRoleTypeDescription.all.map do |role|
        [ role.regulation_role_type_id, role.description ]
      end
    end

  end
end