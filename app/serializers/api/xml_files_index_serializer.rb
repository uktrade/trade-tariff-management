module Api
  module XmlFilesIndexSerializer
  module_function

    def call(files)
      files.map do |file|
        {
          id: file.id,
          issue_date: file.issue_date,
          url: (file.xml.url if file.xml.present?)
        }
      end
    end
  end
end
