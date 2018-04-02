module XmlGeneration
  class NodeEnvelope < Sequel::Model

    include ::XmlGeneration::NodeBase
    include ::XmlGeneration::BaseHelper

    one_to_many :transactions, class_name: "XmlGeneration::NodeTransaction",
                               key: :node_envelope_id

    validates do
      uniqueness_of :node_id
    end
  end
end
