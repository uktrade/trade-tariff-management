module WorkbasketInteractions
  module CreateRegulation
    class SettingsSaver < ::WorkbasketInteractions::SettingsSaverBase
      WORKBASKET_TYPE = "CreateRegulation".freeze

      ATTRS_PARSER_METHODS = %w(
        workbasket_name
      ).freeze

      ANTIDUMPING_REGULATION_ROLES = %w(2 3).freeze
      ABROGATION_REGULATION_ROLES = %w(6 7).freeze
      ABROGATION_MODELS = %w(
        CompleteAbrogationRegulation
        ExplicitAbrogationRegulation
      ).freeze

      REGULATION_CODE_KEYS = %w(
        prefix
        publication_year
        regulation_number
        number_suffix
      ).freeze

      REQUIRED_PARAMS = %i[
        role
        replacement_indicator
        information_text
        operation_date
      ].freeze

      BASE_REGULATION_REQUIRED_PARAMS = REQUIRED_PARAMS + %i[
        validity_start_date
        regulation_group_id
      ]

      BASE_REGULATION_WHITELIST_PARAMS = %i[
        community_code
        replacement_indicator
        information_text
        validity_start_date
        validity_end_date
        effective_end_date
        regulation_group_id
        officialjournal_number
        officialjournal_page
        operation_date
        workbasket_id
      ].freeze

      MODIFICATION_REGULATION_REQUIRED_PARAMS = REQUIRED_PARAMS + %i[
        base_regulation_role
        base_regulation_id
        validity_start_date
      ]

      MODIFICATION_REGULATION_WHITELIST_PARAMS = %i[
        base_regulation_role
        base_regulation_id
        replacement_indicator
        information_text
        validity_start_date
        validity_end_date
        effective_end_date
        officialjournal_number
        officialjournal_page
        operation_date
        workbasket_id
      ].freeze

      ANTIDUMPING_REGULATION_REQUIRED_PARAMS = BASE_REGULATION_REQUIRED_PARAMS + %i[
        antidumping_regulation_role
        related_antidumping_regulation_id
      ]

      ANTIDUMPING_REGULATION_WHITELIST_PARAMS = %i[
        antidumping_regulation_role
        related_antidumping_regulation_id
        community_code
        replacement_indicator
        information_text
        validity_start_date
        validity_end_date
        effective_end_date
        regulation_group_id
        officialjournal_number
        officialjournal_page
        operation_date
        workbasket_id
      ].freeze

      COMPLETE_ABROGATION_REGULATION_REQUIRED_PARAMS = REQUIRED_PARAMS + %i[
        base_regulation_role
        base_regulation_id
        published_date
      ]

      COMPLETE_ABROGATION_REGULATION_WHITELIST_PARAMS = %i[
        replacement_indicator
        information_text
        officialjournal_number
        officialjournal_page
        published_date
        operation_date
        workbasket_id
      ].freeze

      EXPLICIT_ABROGATION_REGULATION_REQUIRED_PARAMS = COMPLETE_ABROGATION_REGULATION_REQUIRED_PARAMS + [
        :abrogation_date
      ]

      EXPLICIT_ABROGATION_REGULATION_WHITELIST_PARAMS = %i[
        replacement_indicator
        information_text
        officialjournal_number
        officialjournal_page
        published_date
        abrogation_date
        operation_date
        workbasket_id
      ].freeze

      PROROGATION_REGULATION_REQUIRED_PARAMS = REQUIRED_PARAMS + [
        :published_date
      ]

      PROROGATION_REGULATION_WHITELIST_PARAMS = %i[
        replacement_indicator
        information_text
        officialjournal_number
        officialjournal_page
        published_date
        operation_date
        workbasket_id
      ].freeze

      FULL_TEMPORARY_STOP_REGULATION_REQUIRED_PARAMS = REQUIRED_PARAMS + %i[
        validity_start_date
        published_date
      ]

      FULL_TEMPORARY_STOP_REGULATION_WHITELIST_PARAMS = %i[
        replacement_indicator
        information_text
        officialjournal_number
        officialjournal_page
        validity_start_date
        validity_end_date
        effective_enddate
        published_date
        operation_date
        workbasket_id
      ].freeze

      BASE_OR_MODIFICATION = %w(
        BaseRegulation
        ModificationRegulation
      ).freeze

      delegate :target_class, to: :attrs_parser

      delegate :ops, to: :attrs_parser
      alias_method :original_params, :ops

      delegate :normalized_params, to: :attrs_parser
      alias_method :regulation_params, :normalized_params

      attr_accessor :regulation,
                    :base_regulation,
                    :errors

      def valid?
        @errors = {}
        check_required_params!
        check_sub_fields!
        return false if @errors.present?

        Sequel::Model.db.transaction(@do_not_rollback_transactions.present? ? {} : { rollback: :always }) do
          @regulation = target_class.new(filtered_ops)
          regulation.public_send("#{target_class.primary_key[0]}=", regulation_params[target_class.primary_key[0]])
          regulation.public_send("#{target_class.primary_key[1]}=", regulation_params[target_class.primary_key[1]])
          regulation.national = true

          set_base_regulation
          set_validity_end_date if modification_regulation_and_end_period_not_set?
          set_published_date if need_to_bump_published_date?

          validate!
        end

        errors.blank?
      end

      def system_ops
        {
          workbasket_id: workbasket.id,
          operation_date: operation_date,
          added_by_id: current_admin.id,
          added_at: Time.zone.now,
        }
      end

      def create_system_ops
        system_ops.merge(operation: "C")
      end

      def update_system_ops
        system_ops.merge(operation: "U")
      end

      def persist!
        @do_not_rollback_transactions = true

        ::WorkbasketValueObjects::Shared::SystemOpsAssigner.new(
          regulation, create_system_ops
        ).assign!

        regulation.save
        post_saving_updates!
      end

      def filtered_ops
        ops = regulation_params.select do |k, _v|
          whitelist_params.include?(k.to_sym) &&
            !target_class.primary_key.include?(k)
        end

        ops
      end

    private

      def set_published_date
        regulation.published_date = regulation_params[:validity_start_date]
      end

      def need_to_bump_published_date?
        BASE_OR_MODIFICATION.include?(target_class.to_s) &&
          regulation_params[:published_date].blank? &&
          regulation_params[:validity_start_date].present?
      end

      def set_base_regulation
        @base_regulation = if original_params[:base_regulation_role] == "4"
                             ModificationRegulation.where(
                               modification_regulation_role: original_params[:base_regulation_role],
                               modification_regulation_id: original_params[:base_regulation_id],
                             ).first
                           else
                             BaseRegulation.where(
                               base_regulation_role: original_params[:base_regulation_role],
                               base_regulation_id: original_params[:base_regulation_id],
                             ).first
                           end
      end

      def modification_regulation_and_end_period_not_set?
        regulation.is_a?(ModificationRegulation) &&
          original_params[:validity_end_date].blank?
      end

      def set_validity_end_date
        regulation.validity_end_date = base_regulation.validity_end_date
      end

      def check_required_params!
        if target_class.to_s.blank?
          @errors[:role] = "You need to specify the regulation type!"

          return false
        end

        target_class_required_params.map do |k|
          if original_params[k.to_s].blank?
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

        if original_params[:base_regulation_id].present?
          if !("CPUSXNMQA".include? original_params[:base_regulation_id]&.chr)
            @errors[:base_regulation_id] = "Regulation identifier must begin with C,P,U,S,X,N,M,Q or A."
          elsif original_params[:base_regulation_id].size != 8
            @errors[:base_regulation_id] = "Regulation identifier's length can be 8 chars only (eg: 'C1812345')"
          end
        else
          @errors[:base_regulation_id] = "Regulation identifier can't be blank!"
        end
      end

      def check_sub_fields!
        legal_id, description, reference_url = original_params['information_text']&.split('|')
        @errors[:legal_id] = "Public-facing regulation name can't be blank!" unless legal_id.present?
        @errors[:description] = "Description can't be blank!" unless description.present?
        @errors[:reference_url] = "Reference URL can't be blank!" unless reference_url.present?

      end

      def target_class_required_params
        if ANTIDUMPING_REGULATION_ROLES.include?(original_params[:role].to_s)
          ANTIDUMPING_REGULATION_REQUIRED_PARAMS
        else
          self.class.const_get("#{target_class_name_in_upcase}_REQUIRED_PARAMS")
        end
      end

      def whitelist_params
        if ANTIDUMPING_REGULATION_ROLES.include?(original_params[:role].to_s)
          ANTIDUMPING_REGULATION_WHITELIST_PARAMS
        else
          self.class.const_get("#{target_class_name_in_upcase}_WHITELIST_PARAMS")
        end
      end

      def target_class_name_in_upcase
        target_class.to_s
            .titleize
            .split
            .join('_')
            .upcase
      end

      def validate!
        if BASE_OR_MODIFICATION.include?(target_class.to_s)
          regulation_advanced_validation!
        end
      end

      def regulation_advanced_validation!
        @advanced_validator = advanced_validator.validate(regulation)

        if regulation.conformance_errors.present?
          regulation.conformance_errors.map do |error_code, error_details_list|
            error_key = get_error_area(error_code)
            error_key = error_key[0] if error_key.is_a?(Array)
            error_key = :regulation_number if error_key == regulation.primary_key[0]

            @errors[error_key] = error_details_list.is_a?(Array) ? error_details_list[0] : error_details_list
          end
        end
      end

      def advanced_validator
        @advanced_validator ||= "#{target_class}Validator".constantize.new
      end

      def get_error_area(error_code)
        advanced_validator.detect do |v|
          v.identifiers == error_code
        end.validation_options[:of]
      end

      def post_saving_updates!
        if ABROGATION_REGULATION_ROLES.include?(original_params[:role].to_s)
          set_abrogation_regulation_for_base_regulation!
        end
      end

      def set_abrogation_regulation_for_base_regulation!
        base_regulation.public_send("#{regulation.primary_key[0]}=", regulation.public_send(regulation.primary_key[0]))
        base_regulation.public_send("#{regulation.primary_key[1]}=", regulation.public_send(regulation.primary_key[1]))

        ::WorkbasketValueObjects::Shared::SystemOpsAssigner.new(
          base_regulation, update_system_ops
        ).assign!

        base_regulation.save
      end

      def operation_date
        original_params[:operation_date].to_date if original_params[:operation_date].present?
      end

      class << self
        def attach_pdf_to!(pdf_data, workbasket)
          regulation = workbasket.settings
                                 .regulation
          target_class = regulation.class

          doc = RegulationDocument.new(
            regulation_id: regulation.public_send(target_class.primary_key[0]),
            regulation_role: regulation.public_send(target_class.primary_key[1]),
            regulation_id_key: target_class.primary_key[0],
            regulation_role_key: target_class.primary_key[1]
          )
          doc.pdf = pdf_data
          doc.national = true

          doc.save
        end
      end
    end
  end
end
