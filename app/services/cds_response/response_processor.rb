module CdsResponse
  class ResponseProcessor
    def self.process(file_contents)

      file_contents.each do |filename, content|
        unless filename.include? "meta"
          doc = Nokogiri::XML(content).remove_namespaces!

          workbasket = Workbaskets::Workbasket[get_workbasket_id(doc)]

          if doc.xpath("//invalidTransactionData").present?
            workbasket.cds_error!
            return "invalid workbasket"
          else
            if doc.xpath("//validTransactionData").present?
              workbasket.published!
              return "published workbasket"
            else
              return "could not indentify repsonse from CDS"
            end
          end
        end
      end
    end

    private

    def self.get_workbasket_id(doc)
      XmlExport::File.find(envelope_id: get_envelope_id(doc))&.workbasket_selected
    end

    def self.get_envelope_id(doc)
      doc.xpath("//envelopeId").text
    end
  end
end
