module XmlGeneration
  class NodeEnvelope < XmlGeneration::NodeBase

    include ::XmlGeneration::BaseHelper

    one_to_many :xml_generation_node_transactions, key: :node_envelope_id

    attr_accessor :transactions

    def initialize(records)
      @transactions = records.map do |transaction_block|
        ::XmlGeneration::NodeTransaction.new(transaction_block)
      end
    end
  end
end
