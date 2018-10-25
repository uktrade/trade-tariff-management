module WorkbasketServices
  module QuotaSavers
    class AnnualPeriod < ::WorkbasketServices::QuotaSavers::BasePeriod

        def balance
          source("staged")["balance"].to_i
        end
    end
  end
end
