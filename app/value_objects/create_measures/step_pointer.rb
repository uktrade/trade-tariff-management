module CreateMeasures
  class StepPointer

    FORM_STEPS = %w(main duties_conditions_footnotes)

    STEP_TRANSITIONS = {
      main: :duties_conditions_footnotes,
      duties_conditions_footnotes: :review_and_submit
    }

    MAIN_STEP_SETTINGS = %w(
      regulation_id
      start_date
      end_date
      measure_type_id
      operation_date
      commodity_codes
      commodity_codes_exclusions
      additional_codes
      reduction_indicator
      geographical_area_id
      excluded_geographical_areas
    )

    DUTIES_CONDITIONS_FOOTNOTES_STEP_SETTINGS = %w(
      measure_components
      conditions
      footnotes
    )

    attr_accessor :current_step

    def initialize(current_step)
      @current_step = current_step
    end

    def current_step_is_form_step?
      FORM_STEPS.include?(current_step)
    end

    def main_step?
      current_step == 'main'
    end

    def has_next_step?
      next_step.present?
    end

    def has_previous_step?
      previous_step.present?
    end

    def next_step
      STEP_TRANSITIONS[current_step.to_sym]
    end

    def previous_step
      STEP_TRANSITIONS.select do |k, v|
        v == current_step.to_sym
      end.try(:keys)
         .try(:first)
    end

    def step_settings(settings_params)
      res = {}

      keys_for_step.map do |key|
        res[key] = settings_params[key]
      end

      res
    end

    def keys_for_step
      self.class.const_get("#{current_step.upcase}_STEP_SETTINGS")
    end
  end
end
