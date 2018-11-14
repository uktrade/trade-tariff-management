module WorkbasketInteractions
  module CreateGeographicalArea
    class InitialValidator

      ALLOWED_OPS = %w(
        geographical_code
        geographical_area_id
        description
        parent_geographical_area_group_id
        validity_start_date
        validity_end_date
        operation_date
      )

      attr_accessor :settings,
                    :errors,
                    :errors_summary,
                    :type,
                    :area_id,
                    :start_date,
                    :end_date

      def initialize(settings)
        @settings = settings

        @type = squish_it(geographical_code)
        @area_id = squish_it(geographical_area_id).upcase
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
        check_type!
        check_area_id!
        check_description!
        check_validity_period!
        check_operation_date!

        errors
      end

      private

        def check_type!
          if geographical_code.blank?
            @errors[:geographical_code] = errors_translator(:geographical_code)
            @errors_summary = errors_translator(:summary_minimal_required_fields)
          end
        end

        def check_area_id!
          if area_id.present?
            if geographical_code.present?
              if type == "group" && area_id.match(/^[0-9A-Z]{4}$/).blank?
                @errors[:geographical_area_id] = errors_translator(:geographical_area_id_invalid_group_code)
                @errors_summary = errors_translator(:summary_invalid_fields)
              end

              if ["country", "region"].include?(type) && area_id.match(/^[A-Z]{2}$/).blank?
                @errors[:geographical_area_id] = errors_translator(:geographical_area_id_invalid_country_code)
                @errors_summary = errors_translator(:summary_invalid_fields)
              end
            end

            if GeographicalArea.where(geographical_area_id: area_id).present?
              @errors[:geographical_area_id] = errors_translator(:geographical_area_id_already_exist)
              @errors_summary = errors_translator(:summary_invalid_fields)
            end
          else
            @errors[:geographical_area_id] = errors_translator(:geographical_area_id_blank)
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
          if start_date.present?
            if end_date.present? && start_date > end_date
              @errors[:validity_start_date] = errors_translator(:validity_start_date_later_than_until_date)
              @errors_summary = errors_translator(:summary_invalid_fields)
            end

          elsif @errors[:validity_start_date].blank?
            @errors[:validity_start_date] = errors_translator(:validity_start_date_blank)
            @errors_summary = errors_translator(:summary_minimal_required_fields)
          end

          if start_date.present? &&
             end_date.present? &&
             end_date < start_date

            @errors[:validity_end_date] = errors_translator(:validity_end_date_earlier_than_start_date)
            @errors_summary = errors_translator(:summary_invalid_fields)
          end
        end

        def check_operation_date!
          if operation_date.blank?
            @errors[:operation_date] = errors_translator(:operation_date_blank)
            @errors_summary = errors_translator(:summary_minimal_required_fields)
          end
        end

        def errors_translator(key)
          I18n.t(:create_geographical_area)[key]
        end

        def squish_it(val)
          val.to_s
             .squish
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
