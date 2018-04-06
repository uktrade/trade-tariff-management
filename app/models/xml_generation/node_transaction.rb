# module XmlGeneration
#   class NodeTransaction < Sequel::Model

#     include ::XmlGeneration::NodeBase

#     many_to_one :envelope, class_name: "XmlGeneration::NodeEnvelope",
#                            key: :node_envelope_id

#     one_to_many :messages, class_name: "XmlGeneration::NodeMessage",
#                            key: :node_transaction_id

#     validates do
#       uniqueness_of :node_id
#       presence_of :node_envelope_id
#     end
#   end
# end

module XmlGeneration
  class NodeTransaction

    attr_accessor :messages

    def initialize(records)
      @messages = Array.wrap(records).map do |record|
        ::XmlGeneration::NodeMessage.new(record)
      end
    end

    def node_id
      # TODO
      #
      # Emulation:
      #
      Time.now.to_i - 1515111000
    end
  end
end
