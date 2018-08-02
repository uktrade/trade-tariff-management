module XmlGeneration
  class NodeEnvelope
    include ::XmlGeneration::BaseHelper

    attr_accessor :transactions

    def initialize(workbaskets)
      @transactions = workbaskets.map do |workbasket|
        ::XmlGeneration::NodeTransaction.new(workbasket)
      end
    end

    def node_id
      Time.now.to_i
    end
  end
end
