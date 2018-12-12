class FootnoteDecorator < ApplicationDecorator
  def title
    "#{object.footnote_type_id} #{object.footnote_id}"
  end

  def footnote_type_description
    "#{object.footnote_type_id} #{object.footnote_type.description}"
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
