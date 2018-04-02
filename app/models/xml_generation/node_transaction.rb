module XmlGeneration
  class NodeTransaction < Sequel::Model

    include ::XmlGeneration::NodeBase

    many_to_one :envelope, class_name: "XmlGeneration::NodeEnvelope",
                           key: :node_envelope_id

    one_to_many :messages, class_name: "XmlGeneration::NodeMessage",
                           key: :node_transaction_id
  end
end
