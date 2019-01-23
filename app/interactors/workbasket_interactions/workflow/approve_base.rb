module WorkbasketInteractions
  module Workflow
    class ApproveBase
      ALLOWED_OPS = %w(
        mode
        submit_for_approval
        reject_reasons
        export_date
      ).freeze

      attr_accessor :settings,
                    :current_user,
                    :workbasket,
                    :mode,
                    :submit_for_approval,
                    :reject_reasons,
                    :errors

      def initialize(current_user, workbasket, settings = {})
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

        errors.blank?
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
        mode.to_s == "approve"
      end

      def reject_mode?
        mode.to_s == "reject"
      end

      def approve!
        if workbasket.move_status_to!(
          current_user,
            approve_status
          )

          post_approve_action!
        end
      end

      def reject!
        if workbasket.move_status_to!(
          current_user,
            reject_status,
            reject_reasons
          )

          post_reject_action!
        end
      end

      def check_mode!
        if mode.blank? || (mode.present? && mode == "on")
          @errors[:general] = errors_translator(blank_mode_validation_message)
        end
      end

      def check_reject_ops!
        if reject_reasons.blank?
          @errors[:general] = errors_translator(:reject_reasons_blank)
        end
      end

      def errors_translator(key)
        I18n.t(:workflow)[:errors][key]
      end
    end
  end
end
