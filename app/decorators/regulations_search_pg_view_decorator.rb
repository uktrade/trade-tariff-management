class RegulationsSearchPgViewDecorator < ApplicationDecorator
  def regulation_type
    return "Full Temporary Stop" if object.role.to_s == "8"

    ::WorkbasketForms::CreateRegulationForm.new(nil).regulation_roles
                  .detect do |role_ops|
      role_ops[0] == object.role.to_s
    end[1]
  end

  def regulation_group_name
    return "" if object.regulation_group_id.blank?

    ::RegulationGroup.by_group_id(object.regulation_group_id)
                     .first
                     .try(:description)
  end

  def start_date
    date_format(object.start_date)
  end

  def end_date
    date_format(object.end_date)
  end

  def published_date
    date_format(object.published_date)
  end
end
