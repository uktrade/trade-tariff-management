module XmlExport
  class File < Sequel::Model(:xml_export_files)

    include XmlDataUploader::Attachment.new(:xml)

    plugin :serialization

    serialize_attributes :yaml, :date_filters

    class << self
      def max_per_page
        15
      end
    end
  end
end
