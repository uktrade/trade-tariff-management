module XmlGeneration
  class NodeTransaction
    attr_accessor :messages,
                  :id

    def initialize(id, records)
      @id = id
      @messages = records.map do |record|
        ::XmlGeneration::NodeMessage.new(record)
      end
    end

    def node_id
      id
    end
  end
end
