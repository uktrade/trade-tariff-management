module WorkbasketInteractions
  module EditRegulation
    class InitialValidator
      ALLOWED_OPS = %w(
                    original_regulation
                    base_regulation_id
                    base_regulation_role
                    validity_start_date
                    validity_end_date
      ).freeze

      VALIDITY_PERIOD_ERRORS_KEYS = %i[
        validity_start_date
        validity_end_date
      ].freeze

      attr_accessor :settings,
                    :errors,
                    :errors_summary,
                    :validity_start_date,
                    :validity_end_date

      def initialize(settings)
        @errors = {}
        @settings = settings

      end

      ALLOWED_OPS.map do |option_name|
        define_method(option_name) do
          settings[option_name]
        end
      end

      def fetch_errors
        # check_description!
        check_validity_period!

        errors
      end

      def errors_translator(key)
        I18n.t(:edit_nomenclature)[key]
      end

    private

      # def check_description!
      #   if settings.description.blank? || (
      #       settings.description.present? &&
      #       settings.description.squish.split.size.zero?
      #     )
      #
      #     @errors[:description] = errors_translator(:description_blank)
      #     @errors_summary = errors_translator(:summary_minimal_required_fields)
      #   end
      # end

      def check_validity_period!
        if settings.validity_start_date.present?
        elsif @errors[:validity_start_date].blank?
          @errors[:validity_start_date] = errors_translator(:validity_start_date_blank)
        end

        if VALIDITY_PERIOD_ERRORS_KEYS.any? do |error_key|
             errors.has_key?(error_key)
           end

          @errors_summary = errors_translator(:summary_invalid_validity_period) if @errors_summary.blank?
        end
      end

    end
  end
end
