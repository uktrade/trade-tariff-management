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
end
