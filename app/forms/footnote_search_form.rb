class FootnoteSearchForm

  extend ActiveModel::Naming
  include ActiveModel::Conversion
  include ActiveModel::Validations

  attr_accessor :q,
                :footnote_type_id,
                :commodity_codes,
                :measure_sids,
                :start_date,
                :end_date

  validates :q, presence: { message: "Hey bro! need to feel in!" }

  validate :validate_start_date, if: "start_date.present?"
  validate :validate_end_date,   if: "end_date.present?"
  validate :validate_date_range, if: "start_date.present? && end_date.present?"

  def initialize(params)
    FootnoteSearch::ALLOWED_FILTERS.map do |filter_name|
      instance_variable_set("@#{filter_name}", params[filter_name])
    end
  end

  def settings
    {
      q: q,
      footnote_type_id: footnote_type_id,
      commodity_codes: commodity_codes,
      measure_sids: measure_sids,
      start_date: start_date,
      end_date: end_date
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

    def validate_start_date
      validate_date(:start_date)
    end

    def validate_end_date
      validate_date(:end_date)
    end

    def validate_date(field_name)
      date = parse_date(public_send(field_name))

      if date.nil?
        errors.add(field_name, "Invalid #{field_name.split('_').join(' ')}")
      end
    end

    def validate_date_range
      start_date = parse_date(start_date)
      end_date = parse_date(end_date)

      if start_date.present? &&
         end_date.present? &&
         start_date > end_date

        errors.add(:start_date, "Start date should not be greater than end date")
      end
    end

    def parse_date(date)
      Date.strptime(date, '%d/%m/%Y') rescue nil
    end
end
