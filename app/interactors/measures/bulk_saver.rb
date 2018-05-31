module Measures
  class BulkSaver

    attr_accessor :current_admin,
                  :collection_ops

    def initialize(current_admin, collection_ops=[])
      @current_admin = current_admin
      @collection_ops = collection_ops.map do |item_ops|
        ActiveSupport::HashWithIndifferentAccess.new(item_ops)
      end
    end

    def persist!
      # TODO
    end

      private
  end
end
