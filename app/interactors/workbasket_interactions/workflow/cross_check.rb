module WorkbasketInteractions
  module Workflow
    class CrossCheck

      ALLOWED_OPS = %w(
        mode
        submit_for_approval
        reject_reasons
      )

      attr_accessor :settings,
                    :current_user,
                    :workbasket,
                    :mode,
                    :submit_for_approval,
                    :reject_reasons,
                    :errors

      def initialize(current_user, workbasket, settings={})
        @current_user = current_user
        @workbasket = workbasket
        @settings = settings

        @errors = {}
      end

      ALLOWED_OPS.map do |option_name|
        define_method(option_name) do
          settings[option_name]
        end
      end

      def valid?
        check_mode!
        check_reject_ops! if reject_mode?
      end

      def persist!
        if approve_mode?
          approve!
        else
          reject!
        end
      end

      private

        def approve_mode?
          settings[:mode] == "approve"
        end

        def reject_mode?
          settings[:mode] == "reject"
        end

        def approve!
          if workbasket.move_status_to!(
              current_user,
              :ready_for_approval
            )
          end
        end

        def reject!
          workbasket.move_status_to!(
            current_user,
            :cross_check_rejected,
            reject_reasons
          )
        end

        def check_mode!
          if mode.blank? || (mode.present? && mode == "on")
            @errors[:general] = errors_translator(:mode_blank)
          end
        end

        def check_reject_ops!
          if reject_reasons.blank?
            @errors[:general] = errors_translator(:reject_reasons_blank)
          end
        end

        def errors_translator(key)
          I18n.t(:cross_check)[:errors][key]
        end
    end
  end
end
