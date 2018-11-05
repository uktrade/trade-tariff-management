class GeographicalAreaSearchForm

  extend ActiveModel::Naming
  include ActiveModel::Conversion
  include ActiveModel::Validations

  CODE_KEYS = %w(
    code_country
    code_region
    code_group
  )

  ALLOWED_FILTERS = %w(
    q
    start_date
    end_date
    code
  ) + CODE_KEYS

  ALLOWED_TYPE_VALUES = ["0", "1", "2"]

  attr_accessor :q,
                :start_date,
                :end_date,
                :code_country,
                :code_region,
                :code_group,
                :code

  class << self
    def errors_translator(key)
      I18n.t(:find_geographical_areas)[key]
    end
  end

  validates :q, presence: { message: errors_translator(:search_string_blank) }
  validates :code, presence: { message: errors_translator(:type_is_blank) },
                   if: :country_region_and_group_are_blank?

  validate :validate_start_date, if: "start_date.present?"
  validate :validate_end_date,   if: "end_date.present?"
  validate :validate_date_range, if: "start_date.present? && end_date.present?"

  def initialize(params)
    ALLOWED_FILTERS.map do |filter_name|
      instance_variable_set("@#{filter_name}", params[filter_name])
    end
  end

  def settings
    {
      q: q,
      start_date: start_date,
      end_date: end_date,
      code_country: code_country,
      code_region: code_region,
      code_group: code_group
    }
  end

  def parsed_errors
    res = {}

    errors.messages.map do |k, v|
      res[k.to_s] = v[0]
    end

    if q.blank? && country_region_and_group_are_blank?
      res["general_summary"] = errors_translator(:minimum_required_filters)
    end

    if res["general_summary"].blank?
      res["general_summary"] = errors_translator(:general_errors)
    end

    res
  end

  private

  def country_region_and_group_are_blank?
    code_filter_value(code_country).blank? &&
    code_filter_value(code_region).blank? &&
    code_filter_value(code_group).blank?
  end

  def validate_start_date
    validate_date(:start_date)
  end

  def validate_end_date
    validate_date(:end_date)
  end

  def validate_date(field_name)
    str_value = public_send(field_name)
    date = parse_date(str_value)

    if str_value.present? && date.nil?
      errors.add(field_name, errors_translator("#{field_name}_invalid".to_sym))
    end
  end

  def validate_date_range
    start_date = parse_date(start_date)
    end_date = parse_date(end_date)

    if start_date.present? && end_date.present? && start_date > end_date
      errors.add(:start_date, errors_translator(:start_date_higher_end_date))
    end
  end

  def parse_date(date)
    Date.strptime(date, '%d/%m/%Y') rescue nil
  end

  def errors_translator(key)
    I18n.t(:find_geographical_areas)[key]
  end

  def code_filter_value(code_val)
    parsing_code = code_val.to_s

    parsing_code.present? &&
    (
      parsing_code == 'true' ||
      ALLOWED_TYPE_VALUES.include?(parsing_code)
    )
  end
end
