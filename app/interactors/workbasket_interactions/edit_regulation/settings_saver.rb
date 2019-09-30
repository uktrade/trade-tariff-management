module WorkbasketInteractions
  module EditRegulation
    class SettingsSaver
      include ::WorkbasketHelpers::SettingsSaverHelperMethods

      attr_accessor :current_step,
                    :save_mode,
                    :settings,
                    :workbasket,
                    :settings_params,
                    :errors,
                    :conformance_errors,
                    :errors_summary,
                    :attrs_parser,
                    :initial_validator,

                    :original_regulation,
                    :base_regulation_id,
                    :base_regulation_role,
                    :validity_start_date,
                    :validity_end_date,

                    :persist,
                    :operation_date,
                    :records

      REQUIRED_PARAMS = %i[
        reason_for_changes
        legal_id
        description
        reference_url
      ].freeze

      BASE_REGULATION_REQUIRED_PARAMS = REQUIRED_PARAMS + %i[
        validity_start_date
        regulation_group_id
      ]

      def initialize(workbasket, current_step, save_mode, settings_ops = {})
        @workbasket = workbasket
        @save_mode = save_mode
        @current_step = current_step
        @settings = workbasket.settings
        @settings_params = ActiveSupport::HashWithIndifferentAccess.new(settings_ops)

        clear_cached_sequence_number!

        @persist = true # For now it always true
        @errors = {}
        @errors_summary = {}
        @conformance_errors = {}
      end

      def save!
        workbasket.settings.reason_for_changes = @settings_params[:reason_for_changes]
        workbasket.settings.legal_id = @settings_params[:legal_id]
        workbasket.settings.reference_url = @settings_params[:reference_url]
        workbasket.settings.description = @settings_params[:description]
        workbasket.settings.validity_start_date = parse_date(@settings_params[:validity_start_date])
        workbasket.settings.validity_end_date = parse_date(@settings_params[:validity_end_date])
        workbasket.settings.regulation_group_id = @settings_params[:regulation_group_id]

        workbasket.settings.save
        if valid?
          update_regulation!
        else
          false
        end
      end

      def valid?
        validate!
        errors.blank? && conformance_errors.blank?
      end


      private

      def set_date
        Date.new(@settings_params["validity_start_date_year"].to_i, @settings_params["validity_start_date_month"].to_i, @settings_params["validity_start_date_day"].to_i)
      rescue ArgumentError
        nil
      end

      def validate!
        check_required_params!
      end

      def update_regulation!
        @records = []
        original_regulation = BaseRegulation.find(base_regulation_id: @settings[:original_base_regulation_id], base_regulation_role: @settings[:original_base_regulation_role].to_i)

        original_regulation.information_text = workbasket.settings.legal_id + '|' +
          workbasket.settings.description + '|' +
          workbasket.settings.reference_url
        original_regulation.validity_start_date = workbasket.settings.validity_start_date
        original_regulation.validity_end_date = workbasket.settings.validity_end_date
        original_regulation.regulation_group_id = workbasket.settings.regulation_group_id

        @records << original_regulation

        save_regulation!
      end

      def check_required_params!
        BASE_REGULATION_REQUIRED_PARAMS.map do |k|
          if @settings_params[k.to_s].blank?
            case k.to_s
            when "regulation_group_id"
              @errors[k] = "Regulation group can't be blank!"
            when "validity_start_date"
              @errors[k] = "Start date can't be blank!"
            else
              @errors[k] = "#{k.to_s.capitalize.split('_').join(' ')} can't be blank!"
            end
          end
        end
      end


      def save_regulation!
        records.each do |record|
          ::WorkbasketValueObjects::Shared::SystemOpsAssigner.new(
            record, system_ops.merge(operation: "U")
          ).assign!(false)
          record.save
        end
      end

      def parse_date(date)
        return nil if date.empty?
        date_parts =  date.gsub(',','/').split('/')
        Date.new(date_parts[2].to_i, date_parts[1].to_i, date_parts[0].to_i)
      end
    end
  end
end
