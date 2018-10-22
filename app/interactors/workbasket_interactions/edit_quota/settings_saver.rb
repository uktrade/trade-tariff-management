module WorkbasketInteractions
  module EditQuota
    class SettingsSaver < ::WorkbasketInteractions::CreateQuota::SettingsSaver

      def stop_quota_saver
        @stop_quota_saver ||= ::Quotas::StopSaver.new(current_admin, workbasket, {})
      end

      def valid?
        @persist = true
        Sequel::Model.db.transaction(@do_not_rollback_transactions.present? ? {} : { rollback: :always }) do
          stop_quota_saver.persist!('new_in_progress')
          super
        end
        @errors.blank?
      end

      def persist!
        stop_quota_saver.persist!('new_in_progress')
        super
      end

    end
  end
end
