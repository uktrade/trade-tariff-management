class RegulationForm
  extend ActiveModel::Naming
  include ActiveModel::Conversion
  include ActiveModel::Validations

  ENTITY_MAPPING = {
    "1" => BaseRegulation,
    "2" => BaseRegulation,
    "3" => BaseRegulation,
    "4" => ModificationRegulation,
    "5" => ProrogationRegulation,
    "6" => CompleteAbrogationRegulation,
    "7" => ExplicitAbrogationRegulation,
    "8" => FullTemporaryStopRegulation
  }

  REPLACEMENT_INDICATORS = {
    "0" => "Not Replaced",
    "1" => "Fully Replaced",
    "2" => "Partially Replaced"
  }

  attr_accessor :role,
                :prefix,
                :publication_year,
                :regulation_number,
                :number_suffix,
                :information_text,
                :validity_start_date,
                :validity_end_date,
                :effective_end_date,
                :regulation_group_id,
                :base_regulation_id,
                :base_regulation_role,
                :file,
                :community_code,
                :replacement_indicator,
                :abrogation_date,
                :officialjournal_number,
                :officialjournal_page,
                :complete_abrogation_regulation_role,
                :complete_abrogation_regulation_id,
                :explicit_abrogation_regulation_role,
                :explicit_abrogation_regulation_id,
                :national,

  def initialize(params = {})
    params.each do |k,v|
      self.public_send("#{k}=", v) if self.respond_to?("#{k}=")
    end
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
      [ regulation.base_regulation_id, regulation.information_text ]
    end
  end

  def to_json
    {
      role: role,
      prefix: prefix,
      publication_year: publication_year,
      regulation_number: regulation_number,
      number_suffix: number_suffix,
      information_text: information_text,
      validity_start_date: validity_start_date,
      validity_end_date: validity_end_date,
      effective_end_date: effective_end_date,
      regulation_group_id: regulation_group_id,
      base_regulation_id: base_regulation_id,
      file: file
    }
  end
end

