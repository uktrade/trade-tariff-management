class GeographicalAreaDecorator < ApplicationDecorator
  def title
    "#{object.geographical_area_id} #{object.description}"
  end

  def type
    case object.geographical_code.to_s
    when '0'
      'Country'
    when '1'
      'Group'
    when '2'
      'Region'
    end
  end

  def start_date
    to_date(object.validity_start_date)
  end

  def end_date
    to_date(object.validity_end_date)
  end

  def area
    object.geographical_area_description
  end

  def current_description
    if area
      area.description
    else
      area_description = GeographicalAreaDescription.where(geographical_area_sid: object.geographical_area_sid).last
      area_description.description if area_description
    end
  end

  def current_description_valid_from
    if area
      to_date(area.try(:validity_start_date))
    else
      area_description = GeographicalAreaDescription.where(geographical_area_sid: object.geographical_area_sid).last
      to_date(area_description.geographical_area_description_period.validity_start_date) if area_description
    end
  end

  def current_description_valid_to
    if area
      to_date(area.try(:validity_end_date))
    else
      area_description = GeographicalAreaDescription.where(geographical_area_sid: object.geographical_area_sid).last
      to_date(area_description.geographical_area_description_period.validity_end_date) if area_description && area_description.geographical_area_description_period.validity_end_date
    end
  end

  def locked?
    false # TODO
  end

  def memberships
    if type == "Group"
      object.currently_contains.map {|country| "#{country.geographical_area_id} - #{country.geographical_area_description.description}" }.join(' ')
    else
      object.currently_member_of.map {|group| "#{group.geographical_area_id} - #{group.geographical_area_description.description}" }.join(' ')
    end
  end

private

  def to_date(value)
    value.try(:strftime, "%d %B %Y") || '-'
  end
end
