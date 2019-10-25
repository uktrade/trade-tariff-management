class QuotaSuspensions::QuotaSuspensionsController < ApplicationController
  def index
    @quota_suspensions = QuotaSuspensionPeriod.where('suspension_end_date > ?', Date.tomorrow)
     .all.sort_by { |suspension_period| [suspension_period.definition.quota_order_number_id, suspension_period.suspension_start_date] }
  end
end
