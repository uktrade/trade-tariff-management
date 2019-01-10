class CertificateDecorator < ApplicationDecorator
  def title
    "#{object.certificate_type_code} #{object.certificate_code}"
  end

  def certificate_type_description
    "#{object.certificate_type_code} #{object.certificate_type.description}"
  end

  def code
    object.certificate_code
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
