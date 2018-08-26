module XmlGeneration
  class NodeTransaction

    attr_accessor :workbasket,
                  :messages

    def initialize(workbasket)
      @workbasket = workbasket

      # TODO: refactor me!

      @messages = if workbasket.type == "bulk_edit_of_measures"
        workbasket.bulk_edit_collection
      else
        workbasket.settings
                  .collection
      end.map do |record|
        ::XmlGeneration::NodeMessage.new(record)
      end
    end

    def node_id
      workbasket.id
    end
  end
end
