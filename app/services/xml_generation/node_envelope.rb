module XmlGeneration
  class NodeEnvelope
    include ::XmlGeneration::BaseHelper

    attr_accessor :transactions

    def initialize(records)
      @transactions = records.each_with_index.map do |record, index|
        ::XmlGeneration::NodeTransaction.new(index + 1, record)
      end
      @_message_id = 0
      @_record_sequence_number = 0
    end

    def present?
      transactions.any?
    end

    def message_id
      @_message_id = @_message_id.next
    end

    def record_sequence_number
      @_record_sequence_number = @_record_sequence_number.next
    end
  end
end
