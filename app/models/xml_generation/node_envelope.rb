module XmlGeneration
  class NodeEnvelope < Sequel::Model

    include ::XmlGeneration::NodeBase
    include ::XmlGeneration::BaseHelper

    one_to_many :transactions, class_name: "XmlGeneration::NodeTransaction",
                               key: :node_envelope_id
  end
end
