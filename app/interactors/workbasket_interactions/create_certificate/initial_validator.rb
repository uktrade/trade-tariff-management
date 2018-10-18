module WorkbasketInteractions
  module CreateCertificate
    class InitialValidator

      ALLOWED_OPS = %w(
        certificate_type_code
        certificate_code
        description
        validity_start_date
        validity_end_date
        operation_date
      )

      VALIDITY_PERIOD_ERRORS_KEYS = [
        :validity_start_date,
        :validity_end_date
      ]

      attr_accessor :settings,
                    :errors,
                    :errors_summary,
                    :start_date,
                    :end_date

      def initialize(settings)
        @settings = settings

        @start_date = parse_date(:validity_start_date)
        @end_date = parse_date(:validity_end_date)

        @errors = {}
      end

      ALLOWED_OPS.map do |option_name|
        define_method(option_name) do
          settings[option_name]
        end
      end

      def fetch_errors
        check_certificate_type_code!
        certificate_code!
        check_description!
        check_validity_period!
        check_operation_date!

        if !minimal_required_fields_present?
          @errors_summary = errors_translator(:summary_minimal_required_fields)
        end

        if @errors_summary.blank? && VALIDITY_PERIOD_ERRORS_KEYS.any? { |error_key| errors.has_key?(error_key) }
          @errors_summary = errors_translator(:summary_invalid_validity_period)
        end

        errors
      end

      private

        def minimal_required_fields_present?
          certificate_type_code.present?
            certificate_code.present? &&
            (description.present? && !(description.present? && description.squish.split.size.zero?)) &&
            start_date.present? &&
            operation_date.present?
        end

        def check_certificate_type_code!
          if certificate_type_code.blank?
            @errors[:certificate_type_code] = errors_translator(:certificate_type_code_blank)
          end
        end

        def certificate_code!
          if certificate_code.blank?
            @errors[:certificate_code] = errors_translator(:certificate_code_blank)
          end
        end

        def check_description!
          if description.blank? || ( description.present? && description.squish.split.size.zero?)
            @errors[:description] = errors_translator(:description_blank)
          end
        end

        def check_validity_period!
          if start_date.present?
            if end_date.present? && start_date > end_date
              @errors[:validity_start_date] = errors_translator(:validity_start_date_later_than_until_date)
            end
          elsif
            @errors[:validity_start_date] = errors_translator(:validity_start_date_blank)
          end
          if start_date.present? && end_date.present? && end_date < start_date
            @errors[:validity_end_date] = errors_translator(:validity_end_date_earlier_than_start_date)
          end
        end

        def check_operation_date!
          if operation_date.blank?
            @errors[:operation_date] = errors_translator(:operation_date_blank)
          end
        end

        def errors_translator(key)
          I18n.t(:create_certificate)[key]
        end

        def parse_date(option_name)
          date_in_string = public_send(option_name)
          date_in_string.blank? rescue nil

          begin
            Date.strptime(date_in_string, "%d/%m/%Y")
          rescue Exception => e
            if public_send(option_name).present?
              @errors[option_name] = errors_translator("#{option_name}_wrong_format".to_sym)
            end

            nil
          end
        end
    end
  end
end
