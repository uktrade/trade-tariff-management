class QuotaSuspensions::QuotaSuspensionsController < ApplicationController
  def index
    @quota_suspensions = QuotaSuspensionPeriod.where('suspension_end_date > ?', Date.yesterday)
     .all.select { |suspension_period| suspension_period.definition }
      .sort_by { |suspension_period| [suspension_period.definition.quota_order_number_id, suspension_period.suspension_start_date] }
  end
end
