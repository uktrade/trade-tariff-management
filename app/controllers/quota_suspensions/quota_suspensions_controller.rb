class QuotaSuspensions::QuotaSuspensionsController < ApplicationController
  def index
    @quota_suspensions = QuotaSuspensionPeriod.where('suspension_end_date > ?', Date.today)
  end
end
