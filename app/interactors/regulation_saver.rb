class RegulationParamsNormalizer

  ALIASES = {
    role: :method_regulation_role
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
    complete_abrogation_regulation_role
    complete_abrogation_regulation_id
    explicit_abrogation_regulation_role
    explicit_abrogation_regulation_id

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

    @normalized_params
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

  def fetch_regulation_number
    base = "#{reg_params[:prefix]}#{reg_params[:publication_year]}#{reg_params[:regulation_number]}"
    base += reg_params[:number_suffix].to_s

    base.delete(' ')
  end
end

class RegulationSaver

  ANTIDUMPING_REGULATION_ROLES = %w(2 3)
  ABROGATION_REGULATION_ROLES = %w(6 7)

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

  BASE_REGULATION_WHITELIST_PARAMS = BASE_REGULATION_REQUIRED_PARAMS +
                                     BASE_OPTIONAL_PARAMS

  MODIFICATION_REGULATION_REQUIRED_PARAMS = BASE_REGULATION_REQUIRED_PARAMS + [
    :base_regulation_role,
    :base_regulation_id
  ]

  MODIFICATION_REGULATION_WHITELIST_PARAMS = MODIFICATION_REGULATION_REQUIRED_PARAMS +
                                             BASE_OPTIONAL_PARAMS

  ANTIDUMPING_REGULATION_REQUIRED_PARAMS = BASE_REGULATION_REQUIRED_PARAMS + [
    :antidumping_regulation_role,
    :related_antidumping_regulation_id
  ]

  ANTIDUMPING_REGULATION_WHITELIST_PARAMS = ANTIDUMPING_REGULATION_REQUIRED_PARAMS +
                                            BASE_OPTIONAL_PARAMS

  COMPLETE_ABROGATION_REGULATION_REQUIRED_PARAMS = REQUIRED_PARAMS + [
    :base_regulation_role,
    :base_regulation_id,
    :published_date
  ]

  COMPLETE_ABROGATION_REGULATION_WHITELIST_PARAMS = COMPLETE_ABROGATION_REGULATION_REQUIRED_PARAMS +
                                                    OPTIONAL_PARAMS

  EXPLICIT_ABROGATION_REGULATION_REQUIRED_PARAMS = COMPLETE_ABROGATION_REGULATION_REQUIRED_PARAMS + [
    :abrogation_date
  ]

  EXPLICIT_ABROGATION_REGULATION_WHITELIST_PARAMS = COMPLETE_ABROGATION_REGULATION_WHITELIST_PARAMS + [
    :abrogation_date
  ]

  ADVANCED_VALIDATION_MODELS = %w(
    BaseRegulation
    ModificationRegulation
  )

  attr_accessor :current_admin,
                :target_class,
                :original_params,
                :regulation_params,
                :regulation,
                :normalizer,
                :errors

  def initialize(current_admin, regulation_params={})
    @current_admin = current_admin
    @original_params = ActiveSupport::HashWithIndifferentAccess.new(regulation_params)

    Rails.logger.info ""
    Rails.logger.info "-" * 100
    Rails.logger.info ""
    Rails.logger.info "regulation_params: #{regulation_params.inspect}"
    Rails.logger.info ""
    Rails.logger.info "-" * 100
    Rails.logger.info ""

    @normalizer = ::RegulationParamsNormalizer.new(regulation_params)
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

    @regulation = target_class.new(
      regulation_params.reject do |k ,v|
        !whitelist_params.include?(k) ||
        target_class.primary_key.include?(k)
      end
    )
    regulation.public_send("#{target_class.primary_key[0]}=", regulation_params[target_class.primary_key[0]])
    regulation.public_send("#{target_class.primary_key[1]}=", regulation_params[target_class.primary_key[1]])

    validate!
    errors.blank?
  end

  def persist!
    regulation.manual_add = true
    regulation.operation = "C"
    regulation.operation_date = operation_date
    regulation.added_by_id = current_admin.id
    regulation.added_at = Time.zone.now

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

    p ""
    p "[SAVED REGULATION OPS] #{regulation.inspect}"
    p ""
  end

  private

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
        name = target_class.to_s
                           .titleize
                           .split
                           .join('_')
                           .upcase
        self.class.const_get("#{name}_REQUIRED_PARAMS")
      end
    end

    def whitelist_params
      self.class.const_get("#{name}_WHITELIST_PARAMS")
    end

    def validate!
      if ADVANCED_VALIDATION_MODELS.include?(target_class.to_s)
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
        doc.save
      end
    end

    def set_abrogation_regulation_for_base_regulation!
      target_regulation = BaseRegulation.where(
        base_regulation_role: original_params[:base_regulation_role],
        base_regulation_id: original_params[:base_regulation_id],
      ).first

      target_regulation.public_send("#{regulation.primary_key[0]}=", regulation.public_send(regulation.primary_key[0])
      target_regulation.public_send("#{regulation.primary_key[1]}=", regulation.public_send(regulation.primary_key[1])

      target_regulation.save

      p ""
      p "[SAVED ABROGATION REGULATION FOR BASE] #{target_regulation.inspect}"
      p ""
    end

    def operation_date
      original_params[:operation_date].to_date
    end
end
