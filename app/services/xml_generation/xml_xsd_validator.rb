require "nokogiri"

module XmlGeneration
  class XmlXsdValidator

    attr_reader :errors,
                :sxd_schema,
                :xml_content

    def initialize(xsd_schema_path, xml_file_content)
      @sxd_schema = Nokogiri::XML::Schema(
        File.read("#{Rails.root}/xml_generation_system_files/taric3.xsd").strip
      )

      @xml_content = Nokogiri::XML(xml_file_content)
    end

    def valid?
      @errors = sxd_schema.validate(
        xml_content
      ).to_a

      errors.blank?
    end
  end
end
