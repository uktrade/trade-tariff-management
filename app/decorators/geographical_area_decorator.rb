class GeographicalAreaDecorator < ApplicationDecorator

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

  def locked?
    false # TODO
  end

  private

    def to_date(value)
      value.try(:strftime, "%d %B %Y") || '-'
    end
end
