module Workbaskets
  module CreateMeasures
    class AttributesParser < Workbaskets::AttributesParserBase

      def simple_ops
        %w(
          start_date
          end_date
          operation_date
          workbasket_name
          commodity_codes
          additional_codes
        )
      end

      private

        def prepare_ops
          if step.in?(["configure_quota", "conditions_footnotes"])
            @ops = ops.merge(workbasket_settings.main_step_settings)
          end

          if step == "conditions_footnotes"
            @ops = ops.merge(workbasket_settings.configure_quota_step_settings)
          end
        end
    end
  end
end
