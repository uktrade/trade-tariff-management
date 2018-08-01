module Workbaskets
  module CreateQuota
    class SettingsSaver < ::Workbaskets::SettingsSaverBase

      workbasket_type = "CreateQuota"

      required_params = %w(
        start_date
        operation_date
      )

      attrs_parser_methods = %w(
        start_date
        end_date
        workbasket_name
        operation_date
        commodity_codes
        commodity_codes_exclusions
        additional_codes
        candidates
        measure_components
        conditions
        footnotes
        excluded_geographical_areas
      )

      associations_list = %w(
        measure_components
        conditions
        footnotes
        excluded_geographical_areas
      )

      private

        def check_required_params!
          general_errors = {}

          required_params.map do |k|
            if public_send(k).blank?
              general_errors[k.to_sym] = "#{k.to_s.capitalize.split('_').join(' ')} can't be blank!"
            end
          end

          if workbasket_name.blank?
            general_errors[:workbasket_name] = errors_translator(:blank_workbasket_name)
          end

          #
          # We have to disable some validations below, because these cases also are
          # covered by conformance rules.
          # However, we will probably return them back soon.
          #

          if candidates.blank?
            general_errors[:commodity_codes] = errors_translator(:blank_commodity_and_additional_codes)
          end

          if commodity_codes.blank? && commodity_codes_exclusions.present?
            general_errors[:commodity_codes_exclusions] = errors_translator(:commodity_codes_exclusions)
          end

          # if settings_params['start_date'].present? && (
          #     commodity_codes.present? ||
          #     additional_codes.present?
          #   ) && candidates.blank?

          #   @errors[:commodity_codes] = errors_translator(:commodity_codes_invalid)
          # end

          if general_errors.present?
            if step_pointer.main_step?
              general_errors.map do |k, v|
                @errors[k] = v
              end

            else
              @errors[:general] = general_errors
            end
          end
        end
    end
  end
end
