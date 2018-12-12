require "nokogiri"

#
# xml = File.read("#{Rails.root}/lib/xml_generation_system_files/sample.xml")
# validator = XmlGeneration::XmlXsdValidator.new(xml)
# errors = validator.run
#

module XmlGeneration
  class XmlXsdValidator
    attr_reader :errors,
                :sxd_schema,
                :xml_content

    def initialize(xml_file_content)
      path_to_xsd = File.read("#{Rails.root}/lib/xml_generation_system_files/taric3.xsd")
      @sxd_schema = Nokogiri::XML::Schema(path_to_xsd)
      @xml_content = Nokogiri::XML(xml_file_content)
    end

    def run
      valid? ? [] : errors.map(&:message)
    end

    def valid?
      @errors = sxd_schema.validate(
        xml_content
      ).to_a

      errors.blank?
    end
  end
end
