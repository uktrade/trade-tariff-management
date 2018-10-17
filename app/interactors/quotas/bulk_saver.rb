module Quotas
  class BulkSaver

    attr_accessor :saver

    delegate :valid?, :persist!, :success_response, :error_response, to: :saver

    def initialize(current_admin, workbasket, collection_ops=[])
      @saver = ::Measures::BulkSaver.new(current_admin, workbasket, collection_ops)
    end
  end
end
