class RegulationParamsNormalizer

  ALIASES = {
    start_date: :validity_start_date,
    role: '1',
    prefix: '',
    publication_year: '',
    regulation_number: '',
    number_suffix: '',
    replacement_indicator: '',
    information_text: '',
    validity_start_date: '',
    validity_end_date: '',
    effective_end_date: '',
    abrogation_date: '',
    community_code: '',
    officialjournal_number: '',
    officialjournal_page: ''
  }

  WHITELIST_PARAMS = %w(
    regulation_group_id
    role
    prefix
    publication_year
    regulation_number
    replacement_indicator
    information_text
    validity_start_date
    validity_end_date
    abrogation_date
    effective_end_date
    base_regulation_id
    base_regulation_role
    antidumping_regulation_role
    related_antidumping_regulation_id
    complete_abrogation_regulation_role
    complete_abrogation_regulation_id
    explicit_abrogation_regulation_role
    explicit_abrogation_regulation_id
    community_code
    officialjournal_number
    officialjournal_page
    operation_date
  )

  attr_accessor :normalized_params

  def initialize(regulation_params)
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
end

class RegulationSaver

  REQUIRED_PARAMS = {
    regulation_group_id: :regulation_group_id,
    role: :method_role,
    prefix: :prefix,
    publication_year: :publication_year,
    regulation_number: :regulation_number,
    replacement_indicator: :replacement_indicator,
    information_text: :information_text,
    validity_start_date: :validity_start_date,
    operation_date: :operation_date
  }

  PRIMARY_KEYS = {
    "QuotaDefinition" => :quota_definition_sid
  }

  attr_accessor :original_params,
                :regulation_params,
                :regulation,
                :errors

  def initialize(regulation_params={})
    @original_params = ActiveSupport::HashWithIndifferentAccess.new(regulation_params)
    @regulation_params = ::RegulationParamsNormalizer.new(regulation_params).normalized_params

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

    @regulation = target_class.new(regulation_params)
    validate!
    errors.blank?
  end

  def persist!
    regulation.manual_add = true
    regulation.operation = "C"
    regulation.operation_date = operation_date

    attempts = 5

    begin
      regulation.save
    rescue Exception => e
      attempts -= 1
      generate_regulation_sid

      if attempts > 0
        retry
      else
        raise "Can't save regulation: #{e.message.inspect}"
      end
    end

    post_saving_updates!

    p ""
    p "[SAVED REGULATION] id: #{regulation.regulation_id} | #{regulation.inspect}"
    p ""
  end

  private

    def modification_regulation?
      original_params[:role] == "4"
    end

    def target_class
      if modification_regulation?
        ModificationRegulationValidator
      else
        BaseRegulationValidator
      end
    end

    def check_required_params!
      REQUIRED_PARAMS.map do |k, v|
        if original_params[k.to_s].blank?
          @errors[v.to_sym] = "#{k.to_s.capitalize.split('_').join(' ')} can't be blank!"
        end
      end
    end

    def validate!
      regulation_base_validation!
    end

    def regulation_base_validation!
      @base_validator = base_validator.validate(regulation)

      if regulation.conformance_errors.present?
        regulation.conformance_errors.map do |error_code, error_details_list|
          @errors[get_error_area(error_code)] = error_details_list
        end
      end
    end

    def base_validator
      @base_validator ||= "#{target_class}Validator".constantize.new
    end

    def get_error_area(error_code)
      base_validator.detect do |v|
        v.identifiers == error_code
      end.validation_options[:of]
    end

    def post_saving_updates!
      # TODO
    end

    def operation_date
      original_params[:operation_date].to_date
    end
end
