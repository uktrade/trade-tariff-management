#
# Example of params:
#
# {
#   "step"=>"main",
#   "settings" => {
#     "operation_date"=>"25/07/2018",
#     "start_date"=>"17/07/2018",
#     "end_date"=>"31/07/2018",
#     "regulation_id"=>"C1501512",
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

      attr_accessor :current_step,
                    :settings,
                    :workbasket,
                    :settings_params,
                    :candidates_with_errors

      def initialize(workbasket, params={})
        @workbasket = workbasket
        @settings = workbasket.create_measures_settings

        @current_step = params[:step]
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
        validate!
        candidates_with_errors.blank?
      end

      def success_ops
        ops = {}
        ops[:next_step] = true if next_step?

        ops
      end

      def errors
        candidates_with_errors.to_json
      end

      private

        def next_step?
          FORM_STEPS.include?(current_step)
        end

        def validate!
          candidates.map do |code|
            record = validate_candidate!(code, :commodity_codes)

            if record.errors.present?
              @candidates_with_errors << [
                code: record.errors.full_messages
              ]
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

        def candidates
          if commodity_codes.present?
            commodity_codes
          else
            additional_codes
          end
        end

        def commodity_codes
          settings_params[:commodity_codes]
        end

        def additional_codes
          settings_params[:additional_codes]
        end

        def measure_params(code, mode)
          ops = {
            start_date: settings_params[:start_date],
            end_date: settings_params[:end_date],
            regulation_id: settings_params[:regulation_id],
            measure_type_id: settings_params[:measure_type_id],
            reduction_indicator: settings_params[:reduction_indicator],
            geographical_area_id: settings_params[:geographical_area_id]
          }

          if mode == :commodity_codes
            ops[:goods_nomenclature_code] = code
          else
            ops[:additional_code] = code
          end

          ::Measures::AttributesNormalizer.new(
            ActiveSupport::HashWithIndifferentAccess.new(ops)
          ).normalized_params
        end
    end
  end
end
