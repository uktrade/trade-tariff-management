module WorkbasketValueObjects
  module CreateQuota
    class PeriodNextDateGenerator
      attr_accessor :mode,
                    :start_date,
                    :end_date

      def initialize(mode, start_date)
        @mode = mode
        @start_date = start_date + 1.day
        @end_date = start_date + self.class.period_length(mode)
      end

      def date_range
        [
          start_date, end_date
        ]
      end

      class << self
        def period_length(period_type)
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

    private

      def step_range_period(step_number)
        step_range = position * step_number
        @start_date = start_date + (step_range - step_number).months
        @end_date = start_date + step_range.months
      end
    end
  end
end
