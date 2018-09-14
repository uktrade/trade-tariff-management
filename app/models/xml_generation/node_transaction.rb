module XmlGeneration
  class NodeTransaction

    attr_accessor :messages

    def initialize(record)
      @messages = Array.wrap(::XmlGeneration::NodeMessage.new(record))
    end

    def node_id
      Time.now.to_i
    end
  end
end
