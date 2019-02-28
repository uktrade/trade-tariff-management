module Workbaskets
  module Workflows
    class CrossChecksController < Workbaskets::Workflows::BaseController

      expose(:checker) do
        ::WorkbasketInteractions::Workflow::CrossCheck.new(
          current_user, workbasket, params[:cross_check]
        )
      end

      expose(:check_completed_url) do
        cross_check_url(workbasket.id)
      end

    end
  end
end
