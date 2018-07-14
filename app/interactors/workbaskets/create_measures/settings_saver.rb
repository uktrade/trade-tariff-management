#
# Example of params:
#
# {
#   "step"=>"main",
#   "measure" => {
#     "operation_date"=>"25/07/2018",
#     "start_date"=>"17/07/2018",
#     "end_date"=>"31/07/2018",
#     "regulation_id"=>"C1501512",
#     "measure_type_series_id"=>"C",
#     "measure_type_id"=>"143",
#     "workbasket_name"=>"TEST WORKBASKET",
#     "reduction_indicator"=>"3",
#     "additional_codes"=>"2550, 2551",
#     "commodity_codes"=>"1,2,3,4",
#     "commodity_codes_exclusions"=>"1,2",
#     "geographical_area_id"=>"1011",
#     "excluded_geographical_areas"=>["AD", "AR", "AS"]
#   },
#   "id"=>"317"
# }
#

module Workbaskets
  module CreateMeasures
    class SettingsSaver

      FORM_STEPS = %w(main duties_conditions_footnotes)
      NEXT_STEP_POINTERS = %w(main duties_conditions_footnotes)
      PREVIOUS_STEP_POINTERS = %w(duties_conditions_footnotes review_and_submit)

      attr_accessor :step,
                    :settings,
                    :workbasket,
                    :settings_params,
                    :candidates_with_errors

      def initialize(workbasket, params={})
        @workbasket = workbasket
        @settings = workbasket.create_measures_settings

        @step = params[:step]
        @settings_params = ActiveSupport::HashWithIndifferentAccess.new(params[:settings])
        @candidates_with_errors = []
      end

      def save!
        workbasket.title = settings_params[:workbasket_name]
        workbasket.save

        settings.settings_jsonb = settings_params.to_json
        settings.save
      end

      def valid?
        validate_candidates!
        candidates_with_errors.blank?
      end

      def success_ops

      end

      def errors
        candidates_with_errors.to_json
      end

      private

        def validate_candidates!
          if commodity_codes.present?
            commodity_codes.map do |commodity_code|
              validate_candidate!(commodity_codes, :commodity_codes)
            end
          else
            additional_codes.map do |additional_code|
              validate_candidate!(additional_code, :additional_codes)
            end
          end
        end

        def validate_candidate!(code, mode)
          measure = Measure.new(
            measure_params(code, mode)
          )
          measure.measure_sid = Measure.max(:measure_sid).to_i + 1

          ::Measures::ValidationHelper.new(
            measure, {}
          ).measure
        end

        def commodity_codes
          settings_params[:commodity_codes]
        end

        def additional_codes
          settings_params[:additional_codes]
        end

        def measure_params(code, mode)
          ops = {}

          if mode == :commodity_codes
            set_commodity_code_ops()
          else
            set_additional_code_ops()
          end

          ops
        end
    end
  end
end
