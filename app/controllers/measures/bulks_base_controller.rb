module Measures
  class BulksBaseController < ApplicationController

    skip_around_action :configure_time_machine

    expose(:workbasket) do
      Workbaskets::Workbasket.find(id: params[:id])
    end

    expose(:workbasket_items) do
      Workbaskets::Item.by_workbasket(workbasket)
                       .by_id_asc
    end

    private

      def workbasket_author?
        current_user.author_of_workbasket?(workbasket)
      end

      helper_method :workbasket_author?

      def workbasket_is_editable?
        workbasket_author? && workbasket.editable?
      end

      helper_method :workbasket_is_editable?

      def require_to_be_workbasket_owner!
        unless workbasket_author?
          render nothing: true, status: :ok
          return false
        end
      end
  end
end
