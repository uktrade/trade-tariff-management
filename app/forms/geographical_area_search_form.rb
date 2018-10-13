class GeographicalAreaSearchForm

  extend ActiveModel::Naming
  include ActiveModel::Conversion
  include ActiveModel::Validations

  CODE_KEYS = %w(
    code_country
    code_region
    code_group
  )

  attr_accessor :q,
                :start_date,
                :end_date,
                :code_country,
                :code_region,
                :code_group,
                :code

  validates :q, presence: { message: "Hey bro! need to feel in!" }
  validates :code, presence: { message: "Hey bro! need to provide code!" }, if: :country_region_and_blank?
  validate :validate_start_date, if: "start_date.present?"
  validate :validate_end_date, if: "end_date.present?"
  validate :validate_start_date_end_date, if: "start_date.present? && end_date.present?"

  def initialize(params)
    GeographicalAreaSearch::ALLOWED_FILTERS.map do |filter_name|
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

    res
  end

  private

  def country_region_and_blank?
    code_country.blank? && code_region.blank? && code_group.blank?
  end

  def validate_start_date
    date = parse_date(start_date)

    if date.nil?
      errors.add(:start_date, "Invalid start date")
    end
  end

  def validate_end_date
    date = parse_date(end_date)

    if date.nil?
      errors.add(:end_date, "Invalid end date")
    end
  end

  def validate_start_date_end_date
    _start_date = parse_date(start_date)
    _end_date = parse_date(end_date)

    if _start_date.present? && _end_date.present?
      if _start_date > _end_date
        errors.add(:start_date, "Start date should not be greater than end date")
      end
    end
  end

  def parse_date(date)
    Date.strptime(date, '%d/%m/%Y') rescue nil
  end
end
