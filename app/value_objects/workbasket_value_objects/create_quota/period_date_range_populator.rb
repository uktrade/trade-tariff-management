module WorkbasketValueObjects
  module CreateQuota
    class PeriodDateRangePopulator

      attr_accessor :mode,
                    :start_date,
                    :end_date,
                    :position

      def initialize(mode, start_date, position)
        @mode = mode
        @start_date = start_date
        @position = position
      end

      def run
        case mode
        when "annual"
          @start_date = start_date
          @end_date = start_date + 1.year
        when "bi_annual"
          step_range_period(6)
        when "monthly"
          @start_date = start_date + (position - 1).months
          @end_date = start_date + position.months
        when "quarterly"
          step_range_period(3)
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
