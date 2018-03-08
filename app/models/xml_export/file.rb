module XmlExport
  class File < Sequel::Model(:xml_export_files)

    include XmlDataUploader::Attachment.new(:xml)

    class << self
      def max_per_page
        15
      end
    end
  end
end
