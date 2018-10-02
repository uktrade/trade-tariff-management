module WorkbasketInteractions
  module CreateGeographicalArea
    class SettingsSaver

      WORKBASKET_TYPE = "CreateGeographicalArea"

      include ::WorkbasketHelpers::SettingsSaverHelperMethods

      ALLOWED_OPS = %w(
        geographical_code
        geographical_area_id
        description
        parent_geographical_area_group_id
        validity_start_date
        validity_end_date
        operation_date
      )

      attr_accessor :current_step,
                    :save_mode,
                    :settings,
                    :workbasket,
                    :settings_params,
                    :errors

      def initialize(workbasket, current_step, save_mode, settings_ops={})
        @workbasket = workbasket
        @save_mode = save_mode
        @current_step = current_step
        @settings = workbasket.settings
        @settings_params = ActiveSupport::HashWithIndifferentAccess.new(settings_ops)
        @errors = {}

        clear_cached_sequence_number!
      end

      ALLOWED_OPS.map do |option_name|
        define_method(option_name) do
          settings_params[option_name]
        end
      end

      def valid?
        validate!
        @errors.blank?
      end

      def save!
        workbasket.title = geographical_area_id
        workbasket.operation_date = operation_date.try(:to_date)
        workbasket.save

        settings.set_settings_for!(current_step, settings_params)
      end

      def persist!
        @persist = true
        validate!

        settings.save
      end

      def success_ops
        {}
      end

      private

        def validate!
          general_errors = {}

          if geographical_code.blank?
            general_errors[:geographical_code] = errors_translator(:geographical_code)
          end

          if geographical_area_id.present?
            area_id = geographical_area_id.squish.upcase
            type = geographical_code.squish.to_s

            if geographical_code.present?
              if type == "1" && area_id.match(/^[0-9A-Z]{4}$/).blank?
                general_errors(:geographical_area_id) = errors_translator(:geographical_area_id_invalid_group_code)
              end

              if GeographicalArea::COUNTRIES_CODES.include?(type) && area_id.match(/^[A-Z]{2}$/).blank?
                general_errors(:geographical_area_id) = errors_translator(:geographical_area_id_invalid_country_code)
              end
            end

            if GeographicalArea.where(geographical_area_id: area_id).present?
              general_errors(:geographical_area_id) = errors_translator(:geographical_area_id_already_exist)
            end
          else
            general_errors[:geographical_area_id] = errors_translator(:geographical_area_id_blank)
          end

          if description.blank? || (
            description.present? &&
            description.squish.split.size.zero?
          )
            general_errors[:description] = errors_translator(:description)
          end

          start_date = begin
            validity_start_date.to_date
          rescue Exception => e
            nil
          end

          end_date = begin
            validity_end_date.to_date
          rescue Exception => e
            @end_date_has_wrong_format = true if validity_end_date.present?
            nil
          end

          if start_date.present?
            if end_date.present? && start_date > end_date
              general_errors[:validity_start_date] = errors_translator(:validity_start_date_later_than_until_date)
            end
          else
            general_errors[:validity_start_date] = errors_translator(:validity_start_date_blank)
          end

          if end_date.present?
            if @end_date_has_wrong_format.present?
              general_errors[:validity_end_date] = errors_translator(:validity_end_date_wrong_format)
            end

            if start_date.present? && end_date < start_date
              general_errors[:validity_end_date] = errors_translator(:validity_end_date_earlier_than_start_date)
            end
          end

          if general_errors.present?
            general_errors.map do |k, v|
              @errors[k] = v
            end
          end
        end
    end
  end
end
