class PdfDataUploader < Shrine
  plugin :validation_helpers

  Attacher.validate do
    validate_max_size 15 * 1024 * 1024, message: "is too large (max is 15 MB)"
    validate_mime_type_inclusion %w[application/pdf]
  end
end
