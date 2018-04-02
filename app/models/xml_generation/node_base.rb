module XmlGeneration
  class NodeBase < Sequel::Model

    extend ActiveModel::Naming

    def before_create
      self.node_id ||= Time.now.utc
      super
    end
  end
end
