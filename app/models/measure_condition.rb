class MeasureCondition < Sequel::Model
  include Formatter
  include ::XmlGeneration::BaseHelper
  include ::WorkbasketHelpers::Association

  plugin :time_machine
  plugin :national
  plugin :oplog, primary_key: :measure_condition_sid
  plugin :conformance_validator

  set_primary_key [:measure_condition_sid]

  one_to_one :measure, key: :measure_sid,
                       primary_key: :measure_sid

  one_to_one :measure_action, primary_key: :action_code,
                              key: :action_code do |ds|
    ds.with_actual(MeasureAction)
  end

  one_to_one :certificate, key: %i[certificate_type_code certificate_code],
                           primary_key: %i[certificate_type_code certificate_code] do |ds|
    ds.with_actual(Certificate)
  end


  one_to_one :certificate_type, key: :certificate_type_code,
                                primary_key: :certificate_type_code do |ds|
    ds.with_actual(CertificateType)
  end

  one_to_one :measurement_unit, primary_key: :condition_measurement_unit_code,
                                key: :measurement_unit_code do |ds|
    ds.with_actual(MeasurementUnit)
  end

  one_to_one :monetary_unit, primary_key: :condition_monetary_unit_code,
                             key: :monetary_unit_code do |ds|
    ds.with_actual(MonetaryUnit)
  end

  one_to_one :measurement_unit_qualifier, primary_key: :condition_measurement_unit_qualifier_code,
                                          key: :measurement_unit_qualifier_code do |ds|
    ds.with_actual(MeasurementUnitQualifier)
  end

  one_to_one :measure_condition_code, key: :condition_code,
                                      primary_key: :condition_code do |ds|
    ds.with_actual(MeasureConditionCode)
  end

  one_to_many :measure_condition_components, key: :measure_condition_sid,
                                             primary_key: :measure_condition_sid

  delegate :abbreviation, to: :monetary_unit, prefix: true, allow_nil: true
  delegate :description, to: :measurement_unit, prefix: true, allow_nil: true
  delegate :description, to: :measurement_unit_qualifier, prefix: true, allow_nil: true
  delegate :formatted_measurement_unit_qualifier, to: :measurement_unit_qualifier, prefix: false, allow_nil: true
  delegate :description, to: :certificate, prefix: true, allow_nil: true
  delegate :description, to: :certificate_type, prefix: true, allow_nil: true
  delegate :description, to: :measure_action, prefix: true, allow_nil: true
  delegate :description, to: :measure_condition_code, prefix: true, allow_nil: true
  delegate :validity_start_date, :validity_end_date, to: :measure, allow_nil: true

  def before_create
    self.measure_condition_sid ||= self.class.next_national_sid

    super
  end

  def document_code
    "#{certificate_type_code}#{certificate_code}"
  end

  def short_abbreviation
    res = if component_sequence_number.present?
            ["#{condition_code}#{component_sequence_number}"]
          else
            [condition_code]
    end

    cert_info = document_code.strip
    res << cert_info if cert_info.present?
    res << action_code if action_code.present?

    if res.size == 2
      res.join(" - ")
    else
      res.join(" ")
    end
  end

  # TODO presenter?
  def requirement
    case requirement_type
    when :document
      "#{certificate_type_description}: #{certificate_description}"
    when :duty_expression
      requirement_duty_expression
    end
  end

  def requirement_duty_expression
    RequirementDutyExpressionFormatter.format(
      duty_amount: condition_duty_amount,
      monetary_unit: condition_monetary_unit_code,
      monetary_unit_abbreviation: monetary_unit_abbreviation,
      measurement_unit: measurement_unit_description,
      formatted_measurement_unit_qualifier: formatted_measurement_unit_qualifier
    )
  end

  def action
    measure_action_description
  end

  def condition
    "#{condition_code}#{component_sequence_number}: #{measure_condition_code_description}"
  end

  def requirement_type
    if certificate_code.present?
      :document
    elsif condition_duty_amount.present?
      :duty_expression
    end
  end

  def duty_expression
    measure_condition_components.map(&:formatted_duty_expression).join(" ")
  end

  def record_code
    "430".freeze
  end

  def subrecord_code
    "10".freeze
  end

  def to_json(_options = {})
    {
      original_measure_condition_code: original_measure_condition_code,
      action_code: action_code,
      measure_action: measure_action.to_json,
      certificate_code: certificate_code,
      certificate: certificate.try(:to_json),
      certificate_type_code: certificate_type_code,
      certificate_type: certificate_type.try(:to_json),
      measurement_unit: measurement_unit.try(:to_json),
      monetary_unit: monetary_unit.try(:to_json),
      measurement_unit_qualifier: measurement_unit_qualifier.try(:to_json),
      condition_code: condition_code,
      measure_condition_code: measure_condition_code.try(:to_json),
      measure_condition_components: measure_condition_components.map(&:to_json),
      component_sequence_number: component_sequence_number
    }
  end
end
