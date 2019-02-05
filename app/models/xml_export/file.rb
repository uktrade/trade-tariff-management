module XmlExport
  class File < Sequel::Model(:xml_export_files)
    include XmlDataUploader::Attachment.new(:xml)
    include XmlDataUploader::Attachment.new(:meta)

    plugin :serialization

    def save_with_envelope_id(envelope_id: envelope_id_sql)
      self.class.db.transaction do
        save
        self.class.where(id: id).update(envelope_id: Sequel.lit(envelope_id.to_s))
        reload
      end
    end

  private

    def envelope_id_sql
      # Format: YYxxxx (YY = current year, xxxx = number sequence this year)
      # Every year, first working day of January, the sequence is expected to
      # be reset, e.g. 190001, 200001, 210001

      <<~SQL
        (
          SELECT GREATEST(
            (
              SELECT MAX(envelope_id)
                     FROM xml_export_files
                     WHERE EXTRACT(year FROM issue_date) = date_part('year', CURRENT_DATE)
            ) + 1,
            #{initial_envelope_id_for_current_year}
          )
        )
      SQL
    end

    def initial_envelope_id_for_current_year
      next_id = envelope_id_offset_for_current_year + 1
      padded_id = next_id.to_s.rjust(4, "0")
      year_part = Date.current.strftime("%y")

      "#{year_part}#{padded_id}"
    end

    def envelope_id_offset_for_current_year
      ENV.fetch("XML_ENVELOPE_ID_OFFSET_YEAR_#{Date.current.year}", 0).to_i
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
