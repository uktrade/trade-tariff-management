class QuotaSuspensions::QuotaSuspensionsController < ApplicationController
  def index
    @quota_suspensions = QuotaSuspensionPeriod.all
  end
end
