module WorkbasketValueObjects
  module CreateQuota
    class StepPointer < ::WorkbasketValueObjects::StepPointerBase
      def step_transitions
        {
          main: :configure_quota,
          configure_quota: :conditions_footnotes,
          conditions_footnotes: :review_and_submit
        }
      end

      def form_steps
        %w(
          main
          configure_quota
          conditions_footnotes
        )
      end

      def main_step_settings
        %w(
          start_date
          end_date
          regulation_id
          quota_ordernumber
          quota_precision
          quota_description
          quota_is_licensed
          quota_licence
          operation_date
          measure_type_id
          commodity_codes
          commodity_codes_exclusions
          additional_codes
          reduction_indicator
          geographical_area_id
          excluded_geographical_areas
        )
      end

      def configure_quota_step_settings
        %w(
           quota_periods
         )
      end

      def conditions_footnotes_step_settings
        %w(
          conditions
          footnotes
          sub_quotas
        )
      end

      def configure_quota?
        current_step == "configure_quota"
      end

      def conditions_footnotes?
        current_step == "conditions_footnotes"
      end
    end
  end
end
