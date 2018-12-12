class RegulationDocument < Sequel::Model(:regulation_documents)
  include PdfDataUploader::Attachment.new(:pdf)

  validates do
    presence_of :regulation_id,
                :regulation_role,
                :regulation_id_key,
                :regulation_role_key

    uniqueness_of %i[
      regulation_id
      regulation_role
      regulation_id_key
      regulation_role_key
    ]
  end
end
