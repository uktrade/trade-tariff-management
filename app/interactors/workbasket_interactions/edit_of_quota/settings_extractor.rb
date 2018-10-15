module WorkbasketInteractions
  module EditOfQuota
    class SettingsExtractor

      attr_reader :quota_order_number,
                  :quota_definition,
                  :quota_definitions,
                  :quota_origins

      def initialize(quota_definition_sid)
        @quota_definition = QuotaDefinition.find(quota_definition_sid: quota_definition_sid)
        @quota_order_number = quota_definition.quota_order_number
        @quota_definitions = QuotaDefinition.where(quota_order_number_sid: quota_order_number.quota_order_number_sid).all
        @quota_origins = QuotaOrderNumberOrigin.where(quota_order_number_sid: quota_order_number.quota_order_number_sid).all
      end

      def settings
        {
            'quota_ordernumber': quota_order_number.quota_order_number_id,
            'quota_description': quota_definition.description,
            'measure_type_id': quota_definition.quota_type_id,
            'regulation_id': quota_definition.regulation_id,
            'commodity_codes': quota_definition.goods_nomenclature_item_ids.join('\r\n'),
            'commodity_codes_exclusions': '',
            'additional_codes': quota_definition.additional_code_ids.join('\r\n'),
            'quota_licence': quota_definition.license,
            'quota_is_licensed': quota_definition.license.present?.to_s,
            'reduction_indicator': quota_definition.reduction_indicator.to_s,
            'start_date': quota_order_number.validity_start_date.strftime('%Y-%m-%d'),
            'geographical_area_id': extract_geographical_area_ids,
            'excluded_geographical_areas': extract_excluded_geographical_area_ids,
            'quota_periods': extract_quota_periods_settings
        }
      end

      def extract_quota_periods_settings
        {
            'type': 'custom',
            'repeat': 'false',
            'balance': '',
            'measurement_unit_id': '',
            'measurement_unit_qualifier_id': '',
            'periods': extract_period_values
        }
      end

      def extract_period_values
        quota_definitions.map.with_index do |period, index|
          {
              "#{index}": {
                  'balance': period.initial_volume.to_s,
                  'critical': (period.critical_state == 'Y').to_s,
                  'end_date': period.validity_end_date.strftime('%Y-%m-%d'),
                  'start_date': period.validity_start_date.strftime('%Y-%m-%d'),
                  'measurement_unit_id': '',
                  'criticality_threshold': period.critical_threshold.to_s,
                  'measurement_unit_code': period.measurement_unit_code,
                  'measurement_unit_qualifier_id': '',
                  'measurement_unit_qualifier_code': period.measurement_unit_qualifier_code
              }
          }
        end.reduce(:merge)
      end

      def extract_excluded_geographical_area_ids
        if quota_origins.present?
          quota_order_number_origin_sid = quota_origins.first.quota_order_number_origin_sid
          area_ids = QuotaOrderNumberOriginExclusion.where(quota_order_number_origin_sid: quota_order_number_origin_sid).map do |e|
            e.excluded_geographical_area_sid
          end
          GeographicalArea.where(geographical_area_sid: area_ids).map do |area|
            area.geographical_area_id
          end
        else
          ['']
        end
      end

      def extract_geographical_area_ids
        if quota_origins.size == 1
          quota_origins.first.geographical_area_id
        else
          quota_origins.map do |area|
            area.geographical_area_id
          end
        end
      end

    end
  end
end
