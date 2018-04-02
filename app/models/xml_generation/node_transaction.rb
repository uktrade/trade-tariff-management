module XmlGeneration
  class NodeTransaction < Sequel::Model

    extend ActiveModel::Naming

    attr_accessor :messages

    def initialize(records)
      @messages = Array.wrap(records).map do |record|
        ::XmlGeneration::NodeMessage.new(record)
      end
    end
  end
end
