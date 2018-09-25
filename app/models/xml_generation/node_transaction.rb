module XmlGeneration
  class NodeTransaction

    attr_accessor :messages,
                  :id

    def initialize(id, record)
      @id = id
      @messages = Array.wrap(::XmlGeneration::NodeMessage.new(record))
    end

    def node_id
      id
    end
  end
end
