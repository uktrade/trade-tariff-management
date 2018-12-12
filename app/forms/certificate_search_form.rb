class CertificateSearchForm
  extend ActiveModel::Naming
  include ActiveModel::Conversion
  include ActiveModel::Validations

  attr_accessor :q,
                :certificate_type_code,
                :start_date,
                :end_date

  validate :minimum_required_filters, if: :all_minimum_required_fields_are_blank?
  validate :validate_start_date, if: "start_date.present?"
  validate :validate_end_date,   if: "end_date.present?"
  validate :validate_date_range, if: "start_date.present? && end_date.present?"

  def initialize(params)
    CertificateSearch::ALLOWED_FILTERS.map do |filter_name|
      instance_variable_set("@#{filter_name}", params[filter_name])
    end
  end

  def settings
    {
      q: q,
      certificate_type_code: certificate_type_code,
      start_date: start_date,
      end_date: end_date
    }
  end

  def certificate_types_list
    CertificateType.actual.map do |ft|
      {
        certificate_type_code: ft.certificate_type_code,
        description: ft.description
      }
    end.sort_by { |a| a[:certificate_type_code] }
  end

  def parsed_errors
    res = {}

    errors.messages.map do |k, v|
      res[k.to_s] = v[0]
    end

    if res["general_summary"].blank?
      res["general_summary"] = errors_translator(:general_errors)
    end

    res
  end

private

  def minimum_required_filters
    errors.add("general_summary", errors_translator(:minimum_required_filters))
    errors.add("general", errors_translator(:minimum_required_filters_short))
  end

  def all_minimum_required_fields_are_blank?
    certificate_type_code.blank? &&
      q.blank?
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

    if start_date.present? &&
        end_date.present? &&
        start_date > end_date

      errors.add(:start_date, errors_translator(:start_date_higher_end_date))
    end
  end

  def parse_date(date)
    Date.strptime(date, '%d/%m/%Y') rescue nil
  end

  def errors_translator(key)
    I18n.t(:find_certificates)[key]
  end
end
