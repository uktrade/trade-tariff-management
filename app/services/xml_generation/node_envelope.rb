module XmlGeneration
  class NodeEnvelope
    include ::XmlGeneration::BaseHelper

    attr_accessor :transactions

    def initialize(grouped_records)
      @transactions = grouped_records.each_with_index.map do |record_group, index|
        ::XmlGeneration::NodeTransaction.new(index + 1, record_group)
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
