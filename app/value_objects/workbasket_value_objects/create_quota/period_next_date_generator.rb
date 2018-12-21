module WorkbasketValueObjects
  module CreateQuota
    class PeriodNextDateGenerator
      attr_accessor :mode,
                    :start_date,
                    :end_date

      def initialize(mode, start_date)
        @mode = mode
        @start_date = start_date
        @end_date = start_date + self.class.period_length(mode)
      end

      def date_range
        [
          start_date, end_date
        ]
      end

      class << self
        def period_length(period_type)
          base_period_length(period_type) - 1.day
        end

        private def base_period_length(period_type)
          case period_type
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
end
