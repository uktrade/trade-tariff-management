module WorkbasketServices
  module QuotaSavers
    class CustomPeriod < ::WorkbasketServices::QuotaSavers::BasePeriod

      private

        def source(key)
          balance_ops
        end

        def balance
          balance_ops["balance"].to_i
        end

        def measurement_unit_code
          balance_ops["measurement_unit_code"]
        end

        def measurement_unit_qualifier_code
          balance_ops["measurement_unit_qualifier_code"]
        end
    end
  end
end
