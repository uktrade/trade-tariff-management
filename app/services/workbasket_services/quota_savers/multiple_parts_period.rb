module WorkbasketServices
  module QuotaSavers
    class MultiplePartsPeriod < ::WorkbasketServices::QuotaSavers::BasePeriod

      attr_accessor :saver_class,
                    :attrs_parser,
                    :all_settings,
                    :order_number,
                    :section_ops,
                    :target_key,
                    :balance_ops,
                    :quota_definition,
                    :start_point,
                    :end_point

      def initialize(saver_class, target_key, section_ops, balance_ops)
        @saver_class = saver_class
        @attrs_parser = saver_class.attrs_parser
        @all_settings = saver_class.settings
                                   .settings
        @order_number = saver_class.order_number
        @section_ops = section_ops
        @target_key = target_key
        @balance_ops = balance_ops
        @start_point = balance_ops[:start_point]
        @end_point = balance_ops[:end_point]
      end

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
