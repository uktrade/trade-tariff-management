module WorkbasketForms
  class CreateRegulationForm < ::WorkbasketForms::BaseForm

    attr_accessor :role

    def regulation_roles
      RegulationRoleTypeDescription.all.map do |role|
        [ role.regulation_role_type_id, role.description ]
      end
    end

  end
end