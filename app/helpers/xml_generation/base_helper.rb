module XmlGeneration
  module BaseHelper
    def timestamp_value(datetime)
      datetime.present? ? datetime.utc : ""
    end

    def xml_data_item(xml_node, data)
      xml_node.text!(data.to_s)
    end

    def xml_data_item_v2(xml_node, namespace, data)
      if data.in?([true, false]) || data.present?
        xml_node.tag!("oub:#{namespace}") do
          xml_node
          xml_data_item(xml_node, data)
        end
      end
    end

    def flag_format(val)
      val.present? ? 1 : 0
    end
  end
end
