module XmlGeneration
  class NodeEnvelope < Sequel::Model

    extend ActiveModel::Naming
    include ::XmlGeneration::BaseHelper

    attr_accessor :transactions

    def initialize(records)
      @transactions = records.map do |transaction_block|
        ::XmlGeneration::NodeTransaction.new(transaction_block)
      end
    end
  end
end
