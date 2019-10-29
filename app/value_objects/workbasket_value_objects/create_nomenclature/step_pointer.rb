module WorkbasketValueObjects
  module CreateNomenclature
    class StepPointer < ::WorkbasketValueObjects::StepPointerBase
      def has_next_step?
        false
      end

      def form_steps
        %w(
          main
        )
      end

      def main_step_settings
        %w(
          new_code
          description
          description_validity_start_date
          producline_suffix
          indents
          origin_code
          origin_producline_suffix
        )
      end
    end
  end
end
