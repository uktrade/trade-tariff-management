module XmlGeneration
  class NodeEnvelope
    include ::XmlGeneration::BaseHelper

    attr_accessor :transactions

    def initialize(records)
      @transactions = records.map do |record|
        ::XmlGeneration::NodeTransaction.new(record)
      end
    end

    def node_id
      Time.now.to_i
    end
  end
end
