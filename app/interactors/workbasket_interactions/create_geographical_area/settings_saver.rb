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
          @errors = {}

          if geographical_code.blank?
            @errors[:geographical_code] = errors_translator(:geographical_code)
          end

          area_id = geographical_area_id.to_s.squish.upcase

          if area_id.present?
            type = geographical_code.to_s.squish

            if geographical_code.present?
              if type == "group" && area_id.match(/^[0-9A-Z]{4}$/).blank?
                @errors[:geographical_area_id] = errors_translator(:geographical_area_id_invalid_group_code)
              end

              if ["country", "region"].include?(type) && area_id.match(/^[A-Z]{2}$/).blank?
                @errors[:geographical_area_id] = errors_translator(:geographical_area_id_invalid_country_code)
              end
            end

            if GeographicalArea.where(geographical_area_id: area_id).present?
              @errors[:geographical_area_id] = errors_translator(:geographical_area_id_already_exist)
            end
          else
            @errors[:geographical_area_id] = errors_translator(:geographical_area_id_blank)
          end

          if description.blank? || (
              description.present? &&
              description.squish.split.size.zero?
            )
            @errors[:description] = errors_translator(:description)
          end

          start_date = parse_date(:validity_start_date)
          end_date = parse_date(:validity_end_date)

          if start_date.present?
            if end_date.present? && start_date > end_date
              @errors[:validity_start_date] = errors_translator(:validity_start_date_later_than_until_date)
            end
          elsif @errors[:validity_start_date].blank?
            @errors[:validity_start_date] = errors_translator(:validity_start_date_blank)
          end

          if start_date.present? &&
             end_date.present? &&
             end_date < start_date

            @errors[:validity_end_date] = errors_translator(:validity_end_date_earlier_than_start_date)
          end
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
