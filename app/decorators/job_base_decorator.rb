class JobBaseDecorator < ApplicationDecorator
  def status
    case object.state
    when "P"
      "Pending"
    when "G"
      "Generation in progress"
    when "C"
      "Completed"
    when "E"
      "Empty"
    when "F"
      "Failed"
    end
  end

  def date_range
    base = object.date_filters[:start_date].to_formatted_s(:uk)
    end_date = object.date_filters[:end_date]
    base += " - #{end_date.to_formatted_s(:uk)}" if end_date.present?

    base
  end

  def issue_date
    to_readable_date_time(:issue_date)
  end
end
