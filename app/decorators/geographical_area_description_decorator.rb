class GeographicalAreaDescriptionDecorator < ApplicationDecorator
  def start_date
    to_date(object.validity_start_date)
  end

  def end_date
    to_date(object.validity_end_date)
  end

private

  def to_date(value)
    value.try(:strftime, "%d %B %Y") || '-'
  end
end
