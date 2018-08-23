module WorkbasketServices
  module QuotaSavers
    class CustomPeriod < ::WorkbasketServices::QuotaSavers::BasePeriod

      private

        def source(key)
          balance_ops
        end
    end
  end
end
