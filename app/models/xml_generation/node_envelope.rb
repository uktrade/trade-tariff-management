#
# TODO:
#   THIS VERSION NEEDS TO BE RE-VISITED
#
# module XmlGeneration
#   class NodeEnvelope < Sequel::Model

#     include ::XmlGeneration::NodeBase
#     include ::XmlGeneration::BaseHelper

#     one_to_many :transactions, class_name: "XmlGeneration::NodeTransaction",
#                                key: :node_envelope_id

#     validates do
#       uniqueness_of :node_id
#     end
#   end
# end

module XmlGeneration
  class NodeEnvelope
    include ::XmlGeneration::BaseHelper

    attr_accessor :transactions

    def initialize(records)
      @transactions = records.map do |transaction_block|
        ::XmlGeneration::NodeTransaction.new(transaction_block)
      end
    end

    def node_id
      # TODO
      #
      # Emulation:
      #
      Time.now.to_i - 1519999000
    end
  end
end
