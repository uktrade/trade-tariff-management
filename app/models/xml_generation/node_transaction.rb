module XmlGeneration
  class NodeTransaction < XmlGeneration::NodeBase

    one_to_many :xml_generation_node_messages, key: :node_transaction_id
    many_to_one :xml_generation_node_envelope, key: :node_envelope_id

    attr_accessor :messages

    def initialize(records)
      @messages = Array.wrap(records).map do |record|
        ::XmlGeneration::NodeMessage.new(record)
      end
    end
  end
end
