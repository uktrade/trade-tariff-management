module Workbaskets
  class SettingsSaverBase

    attr_accessor :current_step,
                  :save_mode,
                  :settings,
                  :workbasket,
                  :settings_params,
                  :step_pointer,
                  :attrs_parser,
                  :errors,
                  :candidates_with_errors

    def initialize(workbasket, current_step, save_mode, settings_ops={})
      @workbasket = workbasket
      @save_mode = save_mode
      @current_step = current_step
      @settings = workbasket.create_measures_settings
      @settings_params = ActiveSupport::HashWithIndifferentAccess.new(settings_ops)

      setup_system_pointers!
      clear_cached_sequence_number!
    end

    def save!
      if step_pointer.main_step?
        workbasket.title = workbasket_name
        workbasket.operation_date = operation_date.try(:to_date)
        workbasket.save
      end

      settings.set_settings_for!(
        current_step,
        step_pointer.step_settings(settings_params)
      )
    end

    def success_ops
      ops = {}
      ops[:next_step] = step_pointer.next_step if step_pointer.has_next_step?

      ops
    end

    attrs_parser_methods.map do |option|
      define_method(option) do
        attrs_parser.public_send(option)
      end
    end

    private

      def system_ops
        {
          workbasket_id: workbasket.id,
          operation_date: operation_date,
          current_admin_id: current_admin.id
        }
      end

      def current_admin
        workbasket.user
      end

      associations_list.map do |name|
        define_method("#{name}_errors") do |measure|
          klass_name = name.split("_").map(&:capitalize).join('')

          "::Workbaskets::Shared::#{klass_name}".constantize.errors_in_collection(
            measure, system_ops, public_send(name)
          )
        end
      end

      def get_unique_errors_from_candidates!
        summarizer = ::Workbaskets::Shared::CandidatesValidationsSummarizer.new(
          current_step, candidates_with_errors
        )
        summarizer.summarize!

        summarizer.errors.map do |k, v|
          @errors[k] = v
        end
      end

      def errors_translator(key)
        I18n.t(
          workbasket_type.titleize
                         .gsub(' ', '_')
                         .downcase
        )[:errors][key]
      end

      def setup_system_pointers!
        @step_pointer = "#{workbasket_type_prefix}::StepPointer".constantize.new(current_step)
        @attrs_parser = "#{workbasket_type_prefix}::AttributesParser".constantize.new(
          settings,
          current_step,
          settings_params
        )
        @errors = {}
        @candidates_with_errors = {}
      end

      def clear_cached_sequence_number!
        Rails.cache.delete("#{workbasket.id}_sequence_number")
      end
  end
end
