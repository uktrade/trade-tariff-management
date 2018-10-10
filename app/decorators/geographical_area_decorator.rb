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
end
