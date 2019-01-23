module WorkbasketValueObjects
  module CreateQuota
    class PeriodGenerator
      attr_accessor :mode,
                    :start_date,
                    :end_date

      def initialize(mode, start_date)
        @mode = mode
        @start_date = start_date
        @end_date = calculate_end_date
      end

      def current_period
        date_range
      end

      def increment_period!
        @start_date = end_date + 1.day
        @end_date = calculate_end_date
        date_range
      end

      private def calculate_end_date
        start_date + period_length
      end

      private def date_range
        [start_date, end_date]
      end

      private def period_length
        base_period_length - 1.day
      end

      private def base_period_length
        case mode
        when 'annual'
          1.year
        when 'bi_annual'
          6.months
        when 'quarterly'
          3.months
        when 'monthly'
          1.month
        end
      end

    end
  end
end
