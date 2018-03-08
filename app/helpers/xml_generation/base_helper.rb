module XmlGeneration
  module BaseHelper
    def xml_data_item(xml_node, data)
      xml_node.text!(data.to_s || '')
    end
  end
end
