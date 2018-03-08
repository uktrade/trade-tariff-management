class ApplicationDecorator < Draper::Decorator

  delegate_all

  def to_readable_date(field_name)
    object.public_send(field_name).strftime("%e %b %Y")
  end

  def to_readable_date_time(field_name)
    object.public_send(field_name).strftime("%e %b %Y, %H:%M")
  end
end
