class RegulationParamsNormalizer

  ALIASES = {
    role: :method_regulation_role
  }

  WHITELIST_PARAMS = %w(
    role
    community_code
    prefix
    publication_year
    regulation_number
    number_suffix
    replacement_indicator
    information_text
    validity_start_date
    validity_end_date
    abrogation_date
    effective_end_date
    regulation_group_id
    officialjournal_number
    officialjournal_page

    antidumping_regulation_role
    related_antidumping_regulation_id
    complete_abrogation_regulation_role
    complete_abrogation_regulation_id
    explicit_abrogation_regulation_role
    explicit_abrogation_regulation_id

    operation_date
  )

  REQUIRED_NUMBER_COMPONENTS = %w(
    prefix
    publication_year
    regulation_number
  )

  attr_accessor :reg_params,
                :normalized_params

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

    case role
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

    @normalized_params[:target_class] = target_class

    ops[target_class.primary_key[1]] = role
    ops[target_class.primary_key[0]] = fetch_regulation_number

    ops
  end

  def fetch_regulation_number
    missing_component = REQUIRED_NUMBER_COMPONENTS.any? do |component_name|
      reg_params[component_name].blank?
    end

    return nil if missing_component

    base = "#{reg_params[:prefix]}#{reg_params[:publication_year]}#{reg_params[:regulation_number]}"
    base += reg_params[:number_suffix]

    base.delete(' ')
  end
end

class RegulationSaver

  REQUIRED_PARAMS = %w(
    role
    prefix
    publication_year
    regulation_number
    number_suffix
    replacement_indicator
    information_text
    validity_start_date
    regulation_group_id
    operation_date
  )

  attr_accessor :target_class,
                :original_params,
                :regulation_params,
                :regulation,
                :errors

  def initialize(regulation_params={})
    @original_params = ActiveSupport::HashWithIndifferentAccess.new(regulation_params)

    Rails.logger.info ""
    Rails.logger.info "-" * 100
    Rails.logger.info ""
    Rails.logger.info "regulation_params: #{regulation_params.inspect}"
    Rails.logger.info ""
    Rails.logger.info "-" * 100
    Rails.logger.info ""

    @regulation_params = ::RegulationParamsNormalizer.new(regulation_params).normalized_params
    @target_class = @regulation_params[:target_class]

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
