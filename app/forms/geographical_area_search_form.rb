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
                :code_group

  validates :q, presence: { message: 'Hey bro! need to feel in!' }

  validates :code_country, presence: true, if: :group_and_region_blank?
  validates :code_region, presence: true, if: :group_and_country_blank?
  validates :code_group, presence: true, if: :country_and_region_blank?

  def group_and_region_blank?
    code_group.blank? && code_region.blank?
  end

  def group_and_country_blank?
    code_group.blank? && code_country.blank?
  end

  def country_and_region_blank?
    code_country.blank? && code_region.blank?
  end

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

    if CODE_KEYS.any? { |k| res.has_key?(k) }
      res["code"] = 'Hey bro! need to provide code!'
    end

    CODE_KEYS.map do |k|
      res.delete(k) if res.has_key?(k)
    end

    res
  end
end
