module XmlGeneration
  module NodeBase
    extend ActiveSupport::Concern

    included do
      extend(ActiveModel::Naming)
    end

    def before_create
      self.node_id ||= Time.now.utc.to_i
      super
    end
  end
end
