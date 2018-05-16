module XmlGeneration
  class Metadata < ::XmlGeneration::XmlInteractorBase

    SOURCE_SYSTEM = "DIT"
    SOURCE_SYSTEM_TYPE = "AWS"
    SOURCE_SYSTEM_OS = "Ubuntu"
    INTERFACE_NAME = "TAQ01"
    INTERFACE_VERSION = "V1.0"
    CORRELATION_ID = "8452f702-a7e0-40aa-8d2f-052073d9ca88"
    CONVERSATION_ID = "TODO"
    TRANSACTION_ID = "TODO"
    MESSAGE_ID = "TODO"
    CHECKSUM_ALGORITHM = "MD5"
    COMPRESSED = "false"
    COMPRESSION_ALGORITHM = "ZIP"
    COMPRESSED_CHECKSUM_ALGORITHM = "MD5"
    SOURCE_LOCATION = "DIT"
    SOURCE_FILE_NAME =
    SOURCE_FILE_ENCODING =

    attr_accessor :xml_export,
                  :record
                  :extract_start_date_time,
                  :extract_end_date_time,
                  :extract_database_date_time

    def initialize(xml_export)
      @xml_export = xml_export
      @record = xml_export.record

      @extract_start_date_time = record.extract_start_date_time
      @extract_end_date_time = record.extract_end_date_time
      @extract_database_date_time = record.extract_database_date_time
    end

    def generate
      renderer.render(self, xml: xml_builder)
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
