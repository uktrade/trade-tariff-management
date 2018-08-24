module WorkbasketServices
  module QuotaSavers
    class OrderNumber < ::WorkbasketServices::Base

      attr_accessor :saver_class,
                    :order_number_ops,
                    :first_period_start_date,
                    :excluded_areas_ops,
                    :excluded_areas,
                    :order_number,
                    :quota_origin,
                    :persist_data,
                    :origin_area,
                    :periods,
                    :errors

      def initialize(saver_class, order_number_ops, persist_data=false)
        @saver_class = saver_class
        @order_number_ops = order_number_ops
        @persist_data = persist_data
        @excluded_areas_ops = order_number_ops['excluded_geographical_areas']
        @origin_area = order_number_ops["geographical_area_id"]
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
        build_quota_origin if origin_area.present?
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
           .map do |k, v|
            @errors << v
          end
        end

        @errors = @errors.flatten
                         .uniq
      end

      def persist!
        records.map do |record|
          record.save
        end
      end

      private

        def records
          [
            order_number,
            quota_origin,
            excluded_areas
          ].flatten
           .reject do |el|
            el.blank?
          end
        end

        def set_first_period_date
          @first_period_start_date = if periods.present?
            periods.map do |k, v|
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

        def build_order_number
          Rails.logger.info ""
          Rails.logger.info " first_period_start_date: #{first_period_start_date}"
          Rails.logger.info ""

          @order_number = QuotaOrderNumber.new(
            quota_order_number_id: order_number_ops["quota_ordernumber"],
            validity_start_date: first_period_start_date
          )

          set_system_data(order_number)
        end

        def build_quota_origin
          area = geographical_area(origin_area)

          @quota_origin = QuotaOrderNumberOrigin.new(
            validity_start_date: order_number.validity_start_date,
            quota_order_number_sid: order_number.quota_order_number_sid,
            geographical_area_id: area.geographical_area_id,
            geographical_area_sid: area.geographical_area_sid
          )

          set_system_data(quota_origin)
        end

        def build_excluded_areas_ops
          @excluded_areas = excluded_areas_ops.reject do |el|
            el.blank?
          end.map do |area_code|
            area = geographical_area(area_code)

            exclusion = QuotaOrderNumberOriginExclusion.new
            exclusion.quota_order_number_origin_sid = quota_origin.quota_order_number_origin_sid
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
