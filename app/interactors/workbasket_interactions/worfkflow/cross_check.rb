module WorkbasketInteractions
  module Workflow
    class CrossCheck

      attr_accessor :params,
                    :current_user,
                    :workbasket,
                    :errors

      def initialize(current_user, workbasket, params={})
        @current_user = current_user
        @workbasket = workbasket
        @params = params

        @errors = {}
      end

      def valid?
        if approve_mode?
          approve
        else
          reject
        end
      end

      def persist!
        if approve_mode?
          approve
        else
          reject
        end
      end

      private

        def approve_mode?
          params[:mode] == "approve"
        end

        def approve
          if workbasket.move_status_to!(
              current_user,
              :ready_for_approval
            )
          end
        end

        def reject
          workbasket.move_status_to!(
            current_user,
            :cross_check_rejected,
            params[:reject_reasons]
          )
        end
    end
  end
end
