module XmlExport
  class FileDecorator < JobBaseDecorator

    def date_of_export
      to_readable_date(:relevant_date)
    end
  end
end
