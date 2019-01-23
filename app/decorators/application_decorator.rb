class ApplicationDecorator < Draper::Decorator
  delegate_all

  def to_readable_date_time(field_name)
    object.public_send(field_name).strftime("%e %b %Y, %H:%M")
  end

  def date_format(date)
    date.try(:strftime, "%d/%m/%Y")
  end
end
