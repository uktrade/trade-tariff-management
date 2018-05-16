module XmlGeneration
  class Metadata < ::XmlGeneration::XmlInteractorBase

    SOURCE_SYSTEM = "DIT"
    SOURCE_SYSTEM_TYPE = "AWS"
    SOURCE_SYSTEM_OS = "Ubuntu"
    INTERFACE_NAME = "TODO"
    INTERFACE_VERSION = "TODO"
    CORRELATION_ID = "TODO"
    CONVERSATION_ID = "TODO"
    TRANSACTION_ID = "TODO"
    MESSAGE_ID = "TODO"
    CHECKSUM_ALGORITHM = "MD5"
    COMPRESSED = "false"
    COMPRESSION_ALGORITHM = "ZIP"
    COMPRESSED_CHECKSUM_ALGORITHM = "MD5"

    attr_accessor :xml_file,
                  :zip_file,
                  :xml_data

    def initialize(xml_file, zip_file)
      @xml_file = xml_file
      @zip_file = zip_file
    end

    def generate
      @xml_data = renderer.render(self, xml: xml_builder)
    end

    def extract_start_date_time
      "TODO"
    end

    def extract_end_date_time
      "TODO"
    end

    def extract_database_date_time
      "TODO"
    end

    def xml_file_checksum
      "TODO"
    end

    def xml_file_size
      "TODO"
    end

    def compressed_checksum
      "TODO"
    end

    def destinations
      [
        OpenStruct.new(
          destination_system: "ICMS_SPIRE",
          destination_location: "TODO",
          destination_file_name: "TODO",
          destination_file_encoding: "TODO"
        ),
        OpenStruct.new(
          destination_system: "MDTP",
          destination_location: "TODO",
          destination_file_name: "TODO",
          destination_file_encoding: "TODO"
        )
      ]
    end

    private

      def template_name
        "metadata"
      end
  end
end
