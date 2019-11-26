class QuotaBlockingPeriods::QuotaBlockingPeriodsController < ApplicationController
  def index
    @quota_blocking_periods = QuotaBlockingPeriod.where('blocking_end_date > ?', Date.yesterday).all
  end
end
