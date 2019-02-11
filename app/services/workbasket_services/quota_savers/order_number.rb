module WorkbasketServices
  module QuotaSavers
    class OrderNumber < ::WorkbasketServices::Base
      attr_accessor :saver_class,
                    :order_number_ops,
                    :first_period_start_date,
                    :excluded_areas_ops,
                    :excluded_areas,
                    :order_number,
                    :persist_data,
                    :origin_areas_ops,
                    :origin_areas,
                    :periods,
                    :errors

      def initialize(saver_class, order_number_ops, persist_data = false)
        @saver_class = saver_class
        @order_number_ops = order_number_ops
        @persist_data = persist_data
        @excluded_areas_ops = order_number_ops['excluded_geographical_areas']
        @origin_areas_ops = Array.wrap(order_number_ops["geographical_area_id"])
        @periods = order_number_ops['quota_periods']

        @errors = []
      end

      def valid?
        generate_records!
        validate!

        if @errors.blank? && persist_data.present?
          persist!
        end

        @errors.blank?
      end

      def generate_records!
        set_first_period_date

        build_order_number
        build_origin_areas_ops if origin_areas_ops.present?
        build_excluded_areas_ops if excluded_areas_ops.present?
      end

      def validate!
        records.map do |record|
          record_key = record.class
                             .name
                             .to_sym

          ::WorkbasketValueObjects::Shared::ConformanceErrorsParser.new(
            record, get_validator(record_key), {}
          ).errors
           .map do |_k, v|
            @errors << v
          end
        end

        @errors = @errors.flatten
                         .uniq
      end

      def persist!
        records.map(&:save)
      end

    private

      def records
        [
          order_number,
          origin_areas,
          excluded_areas
        ].flatten
         .reject(&:blank?)
      end

      def set_first_period_date
        @first_period_start_date = if periods.present?
                                     earliest_start_date&.to_date
                                   else
                                     Date.today
                                   end
      end

      def earliest_start_date
        periods.map do |_k, v|
          if v['type'].to_s == 'custom'
            v['periods'].map do |_k, v|
              v['start_date']
            end.min_by(&:to_date)
          else
            v['start_date']
          end
        end.reject(&:blank?).min_by(&:to_date)
      end

      def build_order_number
        Rails.logger.info ""
        Rails.logger.info " first_period_start_date: #{first_period_start_date}"
        Rails.logger.info ""

        @order_number = QuotaOrderNumber.new(
          quota_order_number_id: order_number_ops["quota_ordernumber"],
          validity_start_date: first_period_start_date
        )

        ::WorkbasketValueObjects::Shared::PrimaryKeyGenerator.new(@order_number).assign!

        set_system_data(order_number)
      end

      def build_origin_areas_ops
        @origin_areas = origin_areas_ops.reject(&:blank?).map do |area_code|
          area = geographical_area(area_code)

          origin = QuotaOrderNumberOrigin.new(
            validity_start_date: order_number.validity_start_date,
              quota_order_number_sid: order_number.quota_order_number_sid,
              geographical_area_id: area.geographical_area_id,
              geographical_area_sid: area.geographical_area_sid
          )
          set_system_data(origin)

          origin
        end
      end

      def build_excluded_areas_ops
        @excluded_areas = excluded_areas_ops.reject(&:blank?).map do |area_code|
          area = geographical_area(area_code)

          exclusion = QuotaOrderNumberOriginExclusion.new
          exclusion.quota_order_number_origin_sid = origin_areas.first.quota_order_number_origin_sid
          exclusion.excluded_geographical_area_sid = area.geographical_area_sid
          set_system_data(exclusion)

          exclusion
        end
      end

      def get_validator(klass_name)
        case klass_name.to_s
        when "QuotaOrderNumber"
          QuotaOrderNumberValidator
        when "QuotaOrderNumberOrigin"
          QuotaOrderNumberOriginValidator
        when "QuotaOrderNumberOriginExclusion"
          QuotaOrderNumberOriginExclusionValidator
        end
      end
    end
  end
end
