module XmlGeneration
  class Metadata < ::XmlGeneration::XmlInteractorBase
    include ::XmlGeneration::BaseHelper

    SOURCE_SYSTEM = "DIT".freeze
    INTERFACE_NAME = "TAQ01".freeze
    INTERFACE_VERSION = "V1.0".freeze
    CHECKSUM_ALGORITHM = "MD5".freeze
    COMPRESSED = "false".freeze
    COMPRESSION_ALGORITHM = "ZIP".freeze
    COMPRESSED_CHECKSUM_ALGORITHM = "MD5".freeze
    SOURCE_LOCATION = "DIT FTP Server".freeze

    attr_accessor :xml_export,
                  :xml_file_path

    def initialize(xml_export)
      @xml_export = xml_export
      @xml_file_path = xml_export.tmp_xml_file.path
    end

    def generate
      renderer.render(self, xml: xml_builder)
    end

    def correlation_id
      SecureRandom.uuid
    end

    def source_file_name
      xml_export.name_of_xml_file
    end

    def xml_file_checksum
      get_md5_checksum(xml_file_path)
    end

    def xml_file_size
      File.size(xml_file_path)
    end

    def destinations
      [
        OpenStruct.new(
          destination_system: "DIT",
          destination_location: "ED-Tariff, To Tariff folder",
          destination_file_name: source_file_name,
          destination_file_encoding: "BASE64"
        )
      ]
    end

  private

    def get_md5_checksum(file_path)
      md5 = Digest::MD5.file(file_path)
      md5.hexdigest
    end

    def template_name
      "metadata"
    end
  end
end
