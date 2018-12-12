module WorkbasketValueObjects
  module CreateRegulation
    class StepPointer < ::WorkbasketValueObjects::StepPointerBase
      def step_transitions
        {
            main: :review_and_submit,
        }
      end

      def form_steps
        %w(
          main
        )
      end

      def main_step_settings
        %w(
            role
            prefix
            publication_year
            regulation_number
            number_suffix
            information_text
            effective_end_date
            regulation_group_id
            base_regulation_id
            base_regulation_role
            replacement_indicator
            community_code
            officialjournal_number
            officialjournal_page
            antidumping_regulation_role
            related_antidumping_regulation_id
            start_date
            end_date
            operation_date
            published_date
            abrogation_date
        )
      end
    end
  end
end
