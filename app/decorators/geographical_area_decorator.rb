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
    area.try(:description)
  end

  def current_description_valid_from
    to_date(area.try(:validity_start_date))
  end

  def current_description_valid_to
    to_date(area.try(:validity_end_date))
  end

  def locked?
    false # TODO
  end

private

  def to_date(value)
    value.try(:strftime, "%d %B %Y") || '-'
  end
end
