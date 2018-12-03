module XmlGeneration
  class NodeEnvelope
    include ::XmlGeneration::BaseHelper

    attr_accessor :transactions

    def initialize(records)
      @transactions = records.each_with_index.map do |record, index|
        ::XmlGeneration::NodeTransaction.new(index + 1, record)
      end
      @message_id_sequence = 0
    end

    def node_id
      1
    end

    def present?
      transactions.any?
    end

    def message_id
      self.message_id_sequence = message_id_sequence.next
    end

    private

    attr_accessor :message_id_sequence
  end
end
