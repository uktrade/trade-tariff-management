class RegulationParamsNormalizer

  ALIASES = {
    role: :method_regulation_role,
    effective_end_date: :method_effective_end_date,
  }

  WHITELIST_PARAMS = %w(
    role
    community_code
    replacement_indicator
    information_text
    validity_start_date
    validity_end_date
    abrogation_date
    effective_end_date
    published_date
    regulation_group_id
    officialjournal_number
    officialjournal_page
    base_regulation_role
    base_regulation_id
    antidumping_regulation_role
    related_antidumping_regulation_id
    operation_date
  )

  attr_accessor :reg_params,
                :normalized_params,
                :target_class

  def initialize(regulation_params)
    @reg_params = regulation_params
    @normalized_params = {}

    whitelist = regulation_params.select do |k, v|
      WHITELIST_PARAMS.include?(k) && v.present?
    end

    whitelist.map do |k, v|
      if ALIASES.keys.include?(k.to_sym)
        if ALIASES[k.to_sym].to_s.starts_with?("method_")
          @normalized_params.merge!(
            send(ALIASES[k.to_sym], regulation_params[k])
          )
        else
          @normalized_params[ALIASES[k.to_sym]] = v
        end
      else
        @normalized_params[k] = v
      end
    end

    # TODO: Remove me later
    #       Added because of
    #       `on create set dummy values for the OJ page and number e.g. 00 00 and hide from the form`
    #       and
    #       `On create set the community code to 1 and hide the field`
    #       from https://trello.com/c/EbZmbJYu/158-create-regulation-phase-1
    #
    stub_some_attributes

    @normalized_params = ActiveSupport::HashWithIndifferentAccess.new(normalized_params)
  end

  def stub_some_attributes
    @normalized_params[:officialjournal_number] = '00'
    @normalized_params[:officialjournal_page] = 0
    @normalized_params[:community_code] = 1
  end

  def method_regulation_role(role)
    ops = {}

    @target_class = case role
    when "1", "2", "3"
      BaseRegulation
    when "4"
      ModificationRegulation
    when "5"
      ProrogationRegulation
    when "6"
      CompleteAbrogationRegulation
    when "7"
      ExplicitAbrogationRegulation
    when "8"
      FullTemporaryStopRegulation
    end

    ops[target_class.primary_key[1]] = role
    ops[target_class.primary_key[0]] = fetch_regulation_number

    ops
  end

  def method_effective_end_date(effective_end_date)
    ops = {}

    if reg_params[:role] == "8"
      ops[:effective_enddate] = effective_end_date
    else
      ops[:effective_end_date] = effective_end_date
    end

    ops
  end

  def fetch_regulation_number
    base = "#{reg_params[:prefix]}#{reg_params[:publication_year]}#{reg_params[:regulation_number]}"
    base += reg_params[:number_suffix].to_s

    base.delete(' ')
  end
end

class RegulationSaver

  ANTIDUMPING_REGULATION_ROLES = %w(2 3)
  ABROGATION_REGULATION_ROLES = %w(6 7)
  ABROGATION_MODELS = %w(
    CompleteAbrogationRegulation
    ExplicitAbrogationRegulation
  )

  REQUIRED_PARAMS = [
    :role,
    :prefix,
    :publication_year,
    :regulation_number,
    :replacement_indicator,
    :information_text,
    :operation_date
  ]

  OPTIONAL_PARAMS = [
    :number_suffix,
    :officialjournal_number,
    :officialjournal_page,
    :pdf_data
  ]

  BASE_REGULATION_REQUIRED_PARAMS = REQUIRED_PARAMS + [
    :validity_start_date,
    :regulation_group_id
  ]

  BASE_OPTIONAL_PARAMS = OPTIONAL_PARAMS + [
    :community_code,
    :validity_end_date,
    :effective_end_date
  ]

  BASE_REGULATION_WHITELIST_PARAMS = [
    :community_code,
    :replacement_indicator,
    :information_text,
    :validity_start_date,
    :validity_end_date,
    :effective_end_date,
    :regulation_group_id,
    :officialjournal_number,
    :officialjournal_page,
    :operation_date
  ]

  MODIFICATION_REGULATION_REQUIRED_PARAMS = REQUIRED_PARAMS + [
    :base_regulation_role,
    :base_regulation_id,
    :validity_start_date
  ]

  MODIFICATION_REGULATION_WHITELIST_PARAMS = [
    :base_regulation_role,
    :base_regulation_id,
    :replacement_indicator,
    :information_text,
    :validity_start_date,
    :validity_end_date,
    :effective_end_date,
    :officialjournal_number,
    :officialjournal_page,
    :operation_date
  ]

  ANTIDUMPING_REGULATION_REQUIRED_PARAMS = BASE_REGULATION_REQUIRED_PARAMS + [
    :antidumping_regulation_role,
    :related_antidumping_regulation_id
  ]

  ANTIDUMPING_REGULATION_WHITELIST_PARAMS = [
    :antidumping_regulation_role,
    :related_antidumping_regulation_id,
    :community_code,
    :replacement_indicator,
    :information_text,
    :validity_start_date,
    :validity_end_date,
    :effective_end_date,
    :regulation_group_id,
    :officialjournal_number,
    :officialjournal_page,
    :operation_date
  ]

  COMPLETE_ABROGATION_REGULATION_REQUIRED_PARAMS = REQUIRED_PARAMS + [
    :base_regulation_role,
    :base_regulation_id,
    :published_date
  ]

  COMPLETE_ABROGATION_REGULATION_WHITELIST_PARAMS = [
    :replacement_indicator,
    :information_text,
    :officialjournal_number,
    :officialjournal_page,
    :published_date,
    :operation_date
  ]

  EXPLICIT_ABROGATION_REGULATION_REQUIRED_PARAMS = COMPLETE_ABROGATION_REGULATION_REQUIRED_PARAMS + [
    :abrogation_date
  ]

  EXPLICIT_ABROGATION_REGULATION_WHITELIST_PARAMS = [
    :replacement_indicator,
    :information_text,
    :officialjournal_number,
    :officialjournal_page,
    :published_date,
    :abrogation_date,
    :operation_date
  ]

  PROROGATION_REGULATION_REQUIRED_PARAMS = REQUIRED_PARAMS + [
    :published_date
  ]

  PROROGATION_REGULATION_WHITELIST_PARAMS = [
    :replacement_indicator,
    :information_text,
    :officialjournal_number,
    :officialjournal_page,
    :published_date,
    :operation_date
  ]

  FULL_TEMPORARY_STOP_REGULATION_REQUIRED_PARAMS = REQUIRED_PARAMS + [
    :validity_start_date,
    :published_date
  ]

  FULL_TEMPORARY_STOP_REGULATION_WHITELIST_PARAMS = [
    :replacement_indicator,
    :information_text,
    :officialjournal_number,
    :officialjournal_page,
    :validity_start_date,
    :validity_end_date,
    :effective_enddate,
    :published_date,
    :operation_date
  ]

  BASE_OR_MODIFICATION = %w(
    BaseRegulation
    ModificationRegulation
  )

  attr_accessor :current_admin,
                :target_class,
                :original_params,
                :regulation_params,
                :base_regulation,
                :regulation,
                :normalizer,
                :errors

  def initialize(current_admin, regulation_params={})
    @current_admin = current_admin
    @original_params = ActiveSupport::HashWithIndifferentAccess.new(regulation_params)
    @normalizer = ::RegulationParamsNormalizer.new(original_params)
    @regulation_params = normalizer.normalized_params
    @target_class = normalizer.target_class

    p ""
    p "-" * 100
    p ""
    p " normalized_params: #{@regulation_params.inspect}"
    p ""
    p "-" * 100
    p ""

    @errors = {}
  end

  def valid?
    check_required_params!
    return false if @errors.present?

    @regulation = target_class.new(filtered_ops)
    regulation.public_send("#{target_class.primary_key[0]}=", regulation_params[target_class.primary_key[0]])
    regulation.public_send("#{target_class.primary_key[1]}=", regulation_params[target_class.primary_key[1]])
    regulation.national = true

    set_base_regulation
    set_validity_end_date if modification_regulation_and_end_period_not_set?
    set_published_date if need_to_bump_published_date?

    validate!
    errors.blank?
  end

  def persist!
    regulation.manual_add = true
    regulation.operation = "C"
    regulation.operation_date = operation_date
    regulation.added_by_id = current_admin.id
    regulation.added_at = Time.zone.now
    regulation.try("approved_flag=", true)
    regulation.try("stopped_flag=", false)

    attempts = 5

    begin
      regulation.save
    rescue Exception => e
      attempts -= 1

      if attempts > 0
        retry
      else
        raise "Can't save regulation: #{e.message.inspect}"
      end
    end

    post_saving_updates!
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

    def filtered_ops
      ops = regulation_params.select do |k ,v|
        whitelist_params.include?(k.to_sym) &&
        !target_class.primary_key.include?(k)
      end

      ops
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
      target_class_required_params.map do |k|
        if original_params[k.to_s].blank?
          @errors[k] = "#{k.to_s.capitalize.split('_').join(' ')} can't be blank!"
        end
      end
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
      save_pdf_document!

      if ABROGATION_REGULATION_ROLES.include?(original_params[:role].to_s)
        set_abrogation_regulation_for_base_regulation!
      end
    end

    def save_pdf_document!
      if original_params[:pdf_data].present?
        doc = RegulationDocument.new(
          regulation_id: regulation.public_send(target_class.primary_key[0]),
          regulation_role: regulation.public_send(target_class.primary_key[1]),
          regulation_id_key: target_class.primary_key[0],
          regulation_role_key: target_class.primary_key[1]
        )
        doc.pdf = original_params[:pdf_data]
        doc.national = true
        doc.save
      end
    end

    def set_abrogation_regulation_for_base_regulation!
      base_regulation.public_send("#{regulation.primary_key[0]}=", regulation.public_send(regulation.primary_key[0]))
      base_regulation.public_send("#{regulation.primary_key[1]}=", regulation.public_send(regulation.primary_key[1]))
      base_regulation.save
    end

    def operation_date
      original_params[:operation_date].to_date
    end
end
