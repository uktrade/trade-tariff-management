class RegulationsSearchPgViewDecorator < ApplicationDecorator

  TYPES = {
    1 => "Base regulation",
    2 => "Provisional anti-dumping/countervailing duty",
    3 => "Definitive anti-dumping/countervailing duty",
    4 => "Modification",
    5 => "Prorogation",
    6 => "Complete abrogation",
    7 => "Explicit abrogation",
    8 => "FTS - Full Temporary Stop"
  }

  def regulation_type
    TYPES[object.role.to_i]
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


