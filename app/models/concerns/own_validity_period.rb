module OwnValidityPeriod
  extend ActiveSupport::Concern

  def own_validity_period(own = true)
    if self[:validity_start_date].present?
      start_date, end_date = if own
                               [self[:validity_start_date], self[:validity_end_date]]
                             else
                               [self.validity_start_date, self.validity_end_date]
                             end

      "#{start_date&.strftime('%d-%m-%Y')} - #{end_date&.strftime('%d-%m-%Y').inspect}"
    else
      "Model doesn't support validity period"
    end
  end
end
