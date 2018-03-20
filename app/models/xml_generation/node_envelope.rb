module XmlGeneration
  class NodeEnvelope
    include ::XmlGeneration::BaseHelper

    attr_accessor :transactions

    def initialize(records)
      @transactions = records.map do |transaction_block|
        ::XmlGeneration::NodeTransaction.new(transaction_block)
      end
    end

    def id
      # TODO
      #
      # Emulation:
      #
      Time.now.to_i - 1519999000
    end
  end
end
