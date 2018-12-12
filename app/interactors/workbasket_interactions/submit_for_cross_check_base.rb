module WorkbasketInteractions
  class SubmitForCrossCheckBase
    attr_accessor :current_admin,
                  :workbasket

    def initialize(current_admin, workbasket)
      @current_admin = current_admin
      @workbasket = workbasket
    end

    def run!
      workbasket.move_status_to!(current_admin, :awaiting_cross_check)
      update_collection!
    end

  private

    def update_collection!
      workbasket.settings
                .collection
                .map do |item|

        item.move_status_to!(:awaiting_cross_check)
      end
    end
  end
end
