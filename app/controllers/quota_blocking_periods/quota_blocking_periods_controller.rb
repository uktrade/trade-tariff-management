class QuotaBlockingPeriods::QuotaBlockingPeriodsController < ApplicationController
  def index
    @quota_blocking_periods = QuotaBlockingPeriod.where('blocking_end_date > ? AND status = ?', Date.yesterday, 'published')
     .all.select { |blocking_period| blocking_period.definition }
      .sort_by { |blocking_period| [blocking_period.definition.quota_order_number_id, blocking_period.blocking_start_date] }
  end
end
