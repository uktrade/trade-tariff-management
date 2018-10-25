module WorkbasketInteractions
  module EditQuota
    class SettingsSaver < ::WorkbasketInteractions::CreateQuota::SettingsSaver

      def stop_quota_saver
        @stop_quota_saver ||= ::Quotas::StopSaver.new(
            current_admin,
            workbasket, {
              'status': 'new_in_progress',
              'operation_date': (first_period_start_date - 1.day).midnight
            })
      end

      def valid?
        @persist = true
        Sequel::Model.db.transaction(@do_not_rollback_transactions.present? ? {} : { rollback: :always }) do
          stop_quota_saver.persist!
          super
        end
        @errors.blank?
      end

      def persist!
        stop_quota_saver.persist!
        super
      end

      def first_period_start_date
        @first_period_start_date ||= if quota_periods.present?
           quota_periods.map do |k, v|
             if v['type'].to_s == 'custom'
               v['periods'].map do |k, v|
                 v['start_date']
               end.sort do |a, b|
                 a.to_date <=> b.to_date
               end.first

             else
               v['start_date']
             end
           end.reject do |p|
             p.blank?
           end.sort do |a, b|
             a.to_date <=> b.to_date
           end.first
               .to_date

         else
           Date.today
         end
      end

    end
  end
end
