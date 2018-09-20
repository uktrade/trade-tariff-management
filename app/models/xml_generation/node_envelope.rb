module XmlGeneration
  class NodeEnvelope
    include ::XmlGeneration::BaseHelper

    attr_accessor :transactions

    def initialize(records)
      @transactions = records.each_with_index.map do |record, index|
        ::XmlGeneration::NodeTransaction.new(index + 1, record)
      end
    end

    def node_id
      1
    end
  end
end
