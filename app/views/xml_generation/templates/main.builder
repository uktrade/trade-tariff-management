xml.instruct!(:xml, version: "1.0", encoding: "UTF-8")
xml.tag!("env:envelope", xmlns: "urn:publicid:-:DGTAXUD:TARIC:MESSAGE:1.0",
                        "xmlns:env" => "urn:publicid:-:DGTAXUD:GENERAL:ENVELOPE:1.0",
                        id: self.node_id) do |env|

  self.transactions.map do |transaction|
    env.tag!("env:transaction", id: transaction.node_id) do |transaction_node|
      transaction.messages.map do |message|
        transaction_node.tag!("env:app.message", id: message.node_id) do |message_node|
          message_node.tag!("oub:transmission", "xmlns:oub" => "urn:publicid:-:DGTAXUD:TARIC:MESSAGE:1.0",
                                           "xmlns:env" => "urn:publicid:-:DGTAXUD:GENERAL:ENVELOPE:1.0") do |transmission_node|
            transmission_node.tag!("oub:record") do |record|
              record.tag!("oub:transaction.id") do record
                xml_data_item(record, transaction.node_id)
              end

              record.tag!("oub:record.code") do record
                xml_data_item(record, message.record_code)
              end

              record.tag!("oub:subrecord.code") do record
                xml_data_item(record, message.subrecord_code)
              end

              record.tag!("oub:record.sequence.number") do record
                xml_data_item(record, 1)
              end

              record.tag!("oub:update.type") do record
                xml_data_item(record, message.update_type)
              end

              Tilt.new(message.partial_path).render(message.record, xml: record)
            end
          end
        end
      end
    end
  end
end
