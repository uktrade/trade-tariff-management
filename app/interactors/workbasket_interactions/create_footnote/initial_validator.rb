module WorkbasketInteractions
  module CreateFootnote
    class InitialValidator

      ALLOWED_OPS = %w(
        footnote_type_id
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
        check_footnote_type_id!
        check_description!
        check_validity_period!
        check_operation_date!

        errors
      end

      private

        def check_footnote_type_id!
          if footnote_type_id.blank?
            @errors[:footnote_type_id] = errors_translator(:footnote_type_id_blank)
            @errors_summary = errors_translator(:summary_minimal_required_fields)
          end
        end

        def check_description!
          if description.blank? || (
              description.present? &&
              description.squish.split.size.zero?
            )

            @errors[:description] = errors_translator(:description_blank)
            @errors_summary = errors_translator(:summary_minimal_required_fields)
          end
        end

        def check_validity_period!
          if @errors[:validity_start_date].blank?
            if start_date.present?
              if end_date.present? && start_date > end_date
                @errors[:validity_start_date] = errors_translator(:validity_start_date_later_than_until_date)
              end

            elsif @errors[:validity_start_date].blank?
              @errors[:validity_start_date] = errors_translator(:validity_start_date_blank)
            end
          end

          if start_date.present? &&
             end_date.present? &&
             end_date < start_date

            @errors[:validity_end_date] = errors_translator(:validity_end_date_earlier_than_start_date)
          end

          if VALIDITY_PERIOD_ERRORS_KEYS.any? do |error_key|
              errors.has_key?(error_key)
            end

            @errors_summary = errors_translator(:summary_invalid_validity_period) if @errors_summary.blank?
          end
        end

        def check_operation_date!
          if operation_date.blank?
            @errors[:operation_date] = errors_translator(:operation_date_blank)
          end
        end

        def errors_translator(key)
          I18n.t(:create_footnote)[key]
        end

        def parse_date(option_name)
          date_in_string = public_send(option_name)
          date_in_string.blank? rescue nil

          begin
            @errors = {} if @errors.nil?
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
