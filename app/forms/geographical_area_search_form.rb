class GeographicalAreaSearchForm

  extend ActiveModel::Naming
  include ActiveModel::Conversion
  include ActiveModel::Validations

  attr_accessor :q,
                :start_date,
                :end_date,
                :code

  validates :q, presence: { message: 'Hey bro! need to feel in!' }
  validates :code, presence: { message: 'Hey bro! need to provide code!' }

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
      code: code
    }
  end

  def parsed_errors
    res = {}

    errors.messages.map do |k, v|
      res[k.to_s] = v[0]
    end

    res
  end
end
