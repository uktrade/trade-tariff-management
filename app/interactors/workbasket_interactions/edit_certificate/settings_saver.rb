module WorkbasketInteractions
  module EditCertificate
    class SettingsSaver

      include ::WorkbasketHelpers::SettingsSaverHelperMethods

      ATTRS_PARSER_METHODS = %w(
        reason_for_changes
        operation_date
        description
        description_validity_start_date
        validity_start_date
        validity_end_date
      )

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
                    :original_certificate,
                    :certificate,
                    :certificate_description,
                    :certificate_description_period,
                    :next_certificate_description,
                    :next_certificate_description_period,
                    :persist

      def initialize(workbasket, current_step, save_mode, settings_ops={})
        @workbasket = workbasket
        @save_mode = save_mode
        @current_step = current_step
        @settings = workbasket.settings
        @original_certificate = settings.original_certificate.decorate
        @settings_params = ActiveSupport::HashWithIndifferentAccess.new(settings_ops)

        setup_attrs_parser!
        clear_cached_sequence_number!

        @persist = true # For now it always true
        @errors = {}
        @conformance_errors = {}
      end

      def save!
        workbasket.title = original_certificate.title
        workbasket.operation_date = (Date.strptime(operation_date, "%d/%m/%Y") rescue nil)
        workbasket.save

        settings.set_settings_for!(current_step, settings_params)
      end

      def valid?
        validate!
        errors.blank? && conformance_errors.blank?
      end

      def persist!
        @do_not_rollback_transactions = true
        validate!
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
          check_if_nothing_changed! if @errors.blank?
          check_conformance_rules! if @errors.blank?
        end

        def check_initial_validation_rules!
          @initial_validator = ::WorkbasketInteractions::EditCertificate::InitialValidator.new(
            original_certificate, settings_params
          )

          @errors = initial_validator.fetch_errors
          @errors_summary = initial_validator.errors_summary
        end

        def check_if_nothing_changed!
          if nothing_changed?
            @errors[:general] = "Nothing changed"
            @errors_summary = initial_validator.errors_translator(:nothing_changed)
          end
        end

        def nothing_changed?
          original_certificate.description.to_s.squish == description.to_s.squish &&
          original_certificate.validity_start_date.strftime("%Y-%m-%d") == validity_start_date.try(:strftime, "%Y-%m-%d") &&
          original_certificate.validity_end_date.try(:strftime, "%Y-%m-%d") == validity_end_date.try(:strftime, "%Y-%m-%d")
        end

        def check_conformance_rules!
          Sequel::Model.db.transaction(@do_not_rollback_transactions.present? ? {} : { rollback: :always }) do

            if it_is_just_description_changed?
              end_date_existing_certificate_desription_period!
              add_next_certificate_description_period!
              add_next_certificate_description!

            else
              end_date_existing_certificate!

              add_certificate!
              add_certificate_description_period!
              add_certificate_description!

              if description_validity_start_date.present?
                add_next_certificate_description_period!
                add_next_certificate_description!
              end
            end

            parse_and_format_conformance_rules
          end
        end

        def parse_and_format_conformance_rules
          @conformance_errors = {}

          if it_is_just_description_changed?
            unless next_certificate_description_period.conformant?
              @conformance_errors.merge!(get_conformance_errors(next_certificate_description_period))
            end

            unless next_certificate_description.conformant?
              @conformance_errors.merge!(get_conformance_errors(next_certificate_description))
            end

          else

            unless certificate.conformant?
              @conformance_errors.merge!(get_conformance_errors(certificate))
            end

            unless certificate_description_period.conformant?
              @conformance_errors.merge!(get_conformance_errors(certificate_description_period))
            end

            unless certificate_description.conformant?
              @conformance_errors.merge!(get_conformance_errors(certificate_description))
            end

            if description_validity_start_date.present?
              unless next_certificate_description_period.conformant?
                @conformance_errors.merge!(get_conformance_errors(next_certificate_description_period))
              end

              unless next_certificate_description.conformant?
                @conformance_errors.merge!(get_conformance_errors(next_certificate_description))
              end
            end
          end

          if conformance_errors.present?
            @errors_summary = initial_validator.errors_translator(:summary_conformance_rules)
          end
        end

        def it_is_just_description_changed?
          @it_is_just_description_changed ||= (
            original_certificate.description.to_s.squish != description.to_s.squish &&
            original_certificate.validity_start_date.strftime("%Y-%m-%d") == validity_start_date.try(:strftime, "%Y-%m-%d") &&
            original_certificate.validity_end_date.try(:strftime, "%Y-%m-%d") == validity_end_date.try(:strftime, "%Y-%m-%d")
          )
        end

        def end_date_existing_certificate!
          unless original_certificate.already_end_dated?
            original_certificate.validity_end_date = validity_start_date

            ::WorkbasketValueObjects::Shared::SystemOpsAssigner.new(
              original_certificate, system_ops.merge(operation: "U")
            ).assign!(false)

            original_certificate.save
          end
        end

        def end_date_existing_certificate_desription_period!
          certificate_description_period = original_certificate.certificate_description
                                                               .certificate_description_period

          unless certificate_description_period.already_end_dated?
            certificate_description_period.validity_end_date = (description_validity_start_date || validity_start_date)

            ::WorkbasketValueObjects::Shared::SystemOpsAssigner.new(
              certificate_description_period, system_ops.merge(operation: "U")
            ).assign!(false)

            certificate_description_period.save
          end
        end

        def add_certificate!
          @certificate = Certificate.new(
            validity_start_date: validity_start_date,
            validity_end_date: validity_end_date
          )

          certificate.certificate_code = original_certificate.certificate_code
          certificate.certificate_type_code = original_certificate.certificate_type_code

          assign_system_ops!(certificate)

          certificate.save if persist_mode?
        end

        def add_certificate_description_period!
          @certificate_description_period = CertificateDescriptionPeriod.new(
            validity_start_date: validity_start_date,
            validity_end_date: (description_validity_start_date || validity_end_date)
          )

          certificate_description_period.certificate_code = certificate.certificate_code
          certificate_description_period.certificate_type_code = certificate.certificate_type_code

          assign_system_ops!(certificate_description_period)
          set_primary_key!(certificate_description_period)

          certificate_description_period.save if persist_mode?
        end

        def add_certificate_description!
          @certificate_description = CertificateDescription.new(
            description: original_certificate.description,
            language_id: "EN"
          )

          certificate_description.certificate_code = certificate.certificate_code
          certificate_description.certificate_type_code = certificate.certificate_type_code
          certificate_description.certificate_description_period_sid = certificate_description_period.certificate_description_period_sid

          assign_system_ops!(certificate_description)
          set_primary_key!(certificate_description)

          certificate_description.save if persist_mode?
        end

        def add_next_certificate_description_period!
          @next_certificate_description_period = CertificateDescriptionPeriod.new(
            validity_start_date: (description_validity_start_date || validity_start_date),
            validity_end_date: validity_end_date
          )

          next_certificate_description_period.certificate_code = original_certificate.certificate_code
          next_certificate_description_period.certificate_type_code = original_certificate.certificate_type_code

          assign_system_ops!(next_certificate_description_period)
          set_primary_key!(next_certificate_description_period)

          next_certificate_description_period.save if persist_mode?
        end

        def add_next_certificate_description!
          @next_certificate_description = CertificateDescription.new(
            description: description,
            language_id: "EN"
          )

          next_certificate_description.certificate_code = original_certificate.certificate_code
          next_certificate_description.certificate_type_code = original_certificate.certificate_type_code
          next_certificate_description.certificate_description_period_sid = next_certificate_description_period.certificate_description_period_sid

          assign_system_ops!(next_certificate_description)

          next_certificate_description.save if persist_mode?
        end

        def persist_mode?
          @persist.present?
        end

        def setup_attrs_parser!
          @attrs_parser = ::WorkbasketValueObjects::EditCertificate::AttributesParser.new(
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

            res[k.to_s] = "<strong class='workbasket-conformance-error-code'>#{k.to_s}</strong>: #{message}".html_safe
          end

          res
        end

        def validator_class(record)
          "#{record.class.name}Validator".constantize
        end
    end
  end
end
