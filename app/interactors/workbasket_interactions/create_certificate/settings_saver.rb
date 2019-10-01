module WorkbasketInteractions
  module CreateCertificate
    class SettingsSaver
      include ::WorkbasketHelpers::SettingsSaverHelperMethods

      ATTRS_PARSER_METHODS = %w(
        certificate_type_code
        certificate_code
        description
        validity_start_date
        validity_end_date
      ).freeze

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
                    :certificate,
                    :certificate_description,
                    :certificate_description_period,
                    :persist

      def initialize(workbasket, current_step, save_mode, settings_ops = {})
        @workbasket = workbasket
        @save_mode = save_mode
        @current_step = current_step
        @settings = workbasket.settings
        @settings_params = ActiveSupport::HashWithIndifferentAccess.new(settings_ops)

        setup_attrs_parser!
        clear_cached_sequence_number!

        @persist = true # For now it always true
        @errors = {}
        @errors_summary = {}
        @conformance_errors = {}
      end

      def save!
        settings.set_settings_for!(current_step, settings_params)
      end

      def valid?
        validate!
        errors.blank? && conformance_errors.blank?
      end

      def persist!
        @do_not_rollback_transactions = true
        validate!

        workbasket.title = "#{settings_params[:certificate_type_code]} #{settings_params[:certificate_code]}"
        workbasket.save
      end

      def success_ops
        {}
      end

      ATTRS_PARSER_METHODS.map do |option|
        define_method(option) do
          attrs_parser.public_send(option)
        end
      end

    private

      def validate!
        check_initial_validation_rules!
        check_conformance_rules! if errors.blank?
      end

      def check_initial_validation_rules!
        @initial_validator = ::WorkbasketInteractions::CreateCertificate::InitialValidator.new(
          settings_params
        )

        @errors = initial_validator.fetch_errors
        @errors_summary = initial_validator.errors_summary
      end

      def check_conformance_rules!
        Sequel::Model.db.transaction(@do_not_rollback_transactions.present? ? {} : { rollback: :always }) do
          add_certificate!
          add_certificate_description_period!
          add_certificate_description!

          parse_and_format_conformance_rules
        end
      end

      def parse_and_format_conformance_rules
        @conformance_errors = {}

        unless certificate.conformant?
          @conformance_errors.merge!(get_conformance_errors(certificate))
        end

        unless certificate_description_period.conformant?
          @conformance_errors.merge!(get_conformance_errors(certificate_description_period))
        end

        unless certificate_description.conformant?
          @conformance_errors.merge!(get_conformance_errors(certificate_description))
        end

        if conformance_errors.present?
          @errors_summary = initial_validator.errors_translator(:summary_conformance_rules)
        end
      end

      def add_certificate!
        @certificate = Certificate.new(
          validity_start_date: validity_start_date,
          validity_end_date: validity_end_date
        )

        certificate.certificate_type_code = certificate_type_code
        certificate.certificate_code = certificate_code

        assign_system_ops!(certificate)

        certificate.save if persist_mode?
      end

      def add_certificate_description_period!
        @certificate_description_period = CertificateDescriptionPeriod.new(
          validity_start_date: validity_start_date,
          validity_end_date: validity_end_date
        )

        certificate_description_period.certificate_code = certificate.certificate_code
        certificate_description_period.certificate_type_code = certificate.certificate_type_code

        assign_system_ops!(certificate_description_period)
        set_primary_key!(certificate_description_period)

        certificate_description_period.save if persist_mode?
      end

      def add_certificate_description!
        @certificate_description = CertificateDescription.new(
          description: description,
          language_id: "EN"
        )

        certificate_description.certificate_code = certificate.certificate_code
        certificate_description.certificate_type_code = certificate.certificate_type_code
        certificate_description.certificate_description_period_sid = certificate_description_period.certificate_description_period_sid

        assign_system_ops!(certificate_description)

        certificate_description.save if persist_mode?
      end

      def persist_mode?
        @persist.present?
      end

      def setup_attrs_parser!
        @attrs_parser = ::WorkbasketValueObjects::CreateCertificate::AttributesParser.new(
          settings_params
        )
      end

      def get_conformance_errors(record)
        res = {}

        record.conformance_errors.map do |k, v|
          message = if v.is_a?(Array)
                      v.flatten.join(' ')
                    else
                      v
                    end

          res[k.to_s] = "<strong class='workbasket-conformance-error-code'>#{k}</strong>: #{message}".html_safe
        end

        res
      end
    end
  end
end
