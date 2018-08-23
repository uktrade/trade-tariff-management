module WorkbasketServices
  module QuotaSavers
    class MultiplePartsPeriod < ::WorkbasketServices::QuotaSavers::BasePeriod

      private

        def balance
          if section_ops["staged"] == "true"
            balance_ops["balance"]
          else
            section_ops["balance"][target_key]
          end.to_i
        end
    end
  end
end
