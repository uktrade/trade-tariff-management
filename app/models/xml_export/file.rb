module XmlExport
  class File < Sequel::Model(:xml_export_files)

    include XmlDataUploader::Attachment.new(:xml)
    include XmlDataUploader::Attachment.new(:base_64)
    include XmlDataUploader::Attachment.new(:zip)
    include XmlDataUploader::Attachment.new(:meta)

    plugin :serialization

    serialize_attributes :yaml, :date_filters

    def save_with_envelope_id(envelope_id: envelope_id_sql)
      self.class.db.transaction do
        save
        self.class.where(id: id).update(envelope_id: Sequel.lit(envelope_id))
        reload
      end
    end

    private

    def envelope_id_sql
      # Format: YYxxxx (YY = current year, xxxx = number sequence this year)
      # Every year, first working day of January, the sequence is expected to
      # be reset, e.g. 190001, 200001, 210001

      <<~SQL
      (SELECT CONCAT (
        to_char(CURRENT_DATE, 'YY'),
        (
          SELECT LPAD((COUNT(*) + #{envelope_id_offset})::TEXT , 4, '0')
          FROM xml_export_files
          WHERE EXTRACT(year FROM issue_date) = date_part('year', CURRENT_DATE)
        )
      ))
      SQL
    end

    def envelope_id_offset
      ENV.fetch("XML_ENVELOPE_ID_OFFSET_YEAR_#{Date.current.year}", 0)
    end

    class << self
      def max_per_page
        15
      end

      def default_per_page
        15
      end

      def max_pages
        999
      end
    end
  end
end
