module XmlGeneration
  class NodeTransaction

    attr_accessor :messages

    def initialize(workbasket)
      @messages = workbasket.settings
                            .collection
                            .map do |record|
        ::XmlGeneration::NodeMessage.new(record)
      end
    end

    def node_id
      workbasket.id
    end
  end
end
