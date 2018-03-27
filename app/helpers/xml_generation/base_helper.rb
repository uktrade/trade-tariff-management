module XmlGeneration
  module BaseHelper
    def timestamp_value(datetime)
      datetime.present? ? datetime.utc : ""
    end

    def xml_data_item(xml_node, data)
      xml_node.text!(data.to_s || '')
    end
  end
end
