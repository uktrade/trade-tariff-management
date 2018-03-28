module XmlGeneration
  class NodeTransaction < Sequel::Model

    extend ActiveModel::Naming

    attr_accessor :messages

    def initialize(records)
      @messages = Array.wrap(records).map do |record|
        ::XmlGeneration::NodeMessage.new(record)
      end
    end

    def id
      # TODO
      #
      # Emulation:
      #
      Time.now.to_i - 1515111000
    end
  end
end
