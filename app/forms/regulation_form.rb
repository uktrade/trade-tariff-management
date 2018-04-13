class RegulationForm
  extend ActiveModel::Naming
  include ActiveModel::Conversion
  include ActiveModel::Validations

  attr_accessor :regulation_type,
                :prefix,
                :publication_year,
                :regulation_number,
                :number_suffix,
                :information_text,
                :validity_start_date,
                :validity_end_date,
                :effective_enddate,
                :regulation_group_id,
                :base_regulation_id,
                :file,
                :additional_code_sid,
                :tariff_measure_number,
                :geographical_area_type,
                :geographical_area_proxy,
                :excluded_geographical_areas,
                :measure

  def initialize()
    # @measure = measure
  end

  def attributes=(attrs={})
    attrs.each do |k,v|
      self.public_send("#{k}=", v) if self.respond_to?("#{k}=")
    end
  end

  def self.prefixes
    [
      [ "C", "Draft" ],
      [ "D", "Decision" ],
      [ "A", "Agreement" ],
      [ "I", "Information" ],
      [ "J", "Judgement" ],
    ]
  end

  def self.regulation_roles
    RegulationRoleTypeDescription.all.map do |role|
      [ role.regulation_role_type_id, role.description ]
    end
  end

  def self.base_regulations
    BaseRegulation.actual.map do |regulation|
      [ regulation.base_regulation_id, regulation.base_regulation_id + ": " + regulation.information_text ]
    end
  end

end

