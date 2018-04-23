module RegulationDocumentContext
  extend ActiveSupport::Concern

  def pdf_document_record
    RegulationDocument.where(
      regulation_id: public_send(primary_key[0]),
      regulation_role: public_send(primary_key[1]).to_s,
      regulation_id_key: primary_key[0].to_s,
      regulation_role_key: primary_key[1].to_s
    ).first
  end

  def pdf_url
    pdf_document_record.pdf.url
  end
end
