module WorkbasketValueObjects
  class StepPointerBase

    attr_accessor :current_step

    def initialize(current_step)
      @current_step = current_step
    end

    def current_step_is_form_step?
      form_steps.include?(current_step)
    end

    def main_step?
      current_step == 'main'
    end

    def review_and_submit_step?
      current_step == "review_and_submit"
    end

    def has_next_step?
      next_step.present?
    end

    def has_previous_step?
      previous_step.present?
    end

    def next_step
      step_transitions[current_step.to_sym]
    end

    def previous_step
      step_transitions.select do |k, v|
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
      public_send("#{current_step}_step_settings")
    end
  end
end
