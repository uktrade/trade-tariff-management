module WorkbasketInteractions
  module EditQuota
    class SettingsExtractor

      attr_reader :quota_order_number,
                  :quota_definition,
                  :quota_definitions,
                  :quota_origins,
                  :exclusions

      def initialize(quota_definition_sid, exclusions = [])
        @quota_definition = QuotaDefinition.find(quota_definition_sid: quota_definition_sid)
        @quota_order_number = quota_definition.quota_order_number
        @quota_definitions = QuotaDefinition.where(quota_order_number_sid: quota_order_number.quota_order_number_sid).all
        @quota_origins = QuotaOrderNumberOrigin.where(quota_order_number_sid: quota_order_number.quota_order_number_sid).all
        @exclusions = exclusions
      end

      def settings
        main_step_settings.
            merge(configure_quota_step_settings).
            merge(conditions_footnotes_step_settings)
      end

      def main_step_settings
        {
            'end_date': nil,
            'start_date': quota_order_number.validity_start_date.strftime('%d/%m/%Y'),
            'quota_licence': quota_definition.license,
            'quota_is_licensed': quota_definition.license.present?.to_s,
            'regulation_id': 'regulation'.in?(exclusions) ? '' : quota_definition.regulation_id,
            'regulation_role': 'regulation'.in?(exclusions) ? '' : quota_definition.regulation_role,
            'commodity_codes': 'commodity_codes'.in?(exclusions) ? '' : quota_definition.goods_nomenclature_item_ids.join(', '),
            'commodity_codes_exclusions': '',
            'measure_type_id': quota_definition.quota_type_id,
            'additional_codes': 'additional_codes'.in?(exclusions) ? '' : quota_definition.additional_code_ids.join(', '),
            'quota_description': quota_definition.description,
            'quota_ordernumber': 'order_number'.in?(exclusions) ? '' : quota_order_number.quota_order_number_id,
            'quota_precision': quota_definition.maximum_precision,
            'reduction_indicator': quota_definition.reduction_indicator.to_s,
            'geographical_area_id': 'origin'.in?(exclusions) ? '' : extract_geographical_area_ids,
            'excluded_geographical_areas': 'origin'.in?(exclusions) ? '' : extract_excluded_geographical_area_ids,
        }
      end

      def configure_quota_step_settings
        {
            'quota_periods': extract_quota_periods_settings,
        }
      end

      def conditions_footnotes_step_settings
        {
            'sub_quotas': extract_sub_quotas_settings,
            'footnotes': 'footnotes'.in?(exclusions) || quota_definition.measure.blank? ? [] : to_indexed_object(quota_definition.measure.to_json[:footnotes]),
            'conditions': 'conditions'.in?(exclusions) || quota_definition.measure.blank? ? [] : to_indexed_object(quota_definition.measure.to_json[:measure_conditions])
        }
      end

      private

      def extract_sub_quotas_settings
        quota_associations = QuotaAssociation.where(main_quota_definition_sid: quota_definition.quota_definition_sid, relation_type: 'EQ')
        quota_associations.map.with_index do |association, index|
          sub_quota = QuotaDefinition.find(quota_definition_sid: association.sub_quota_definition_sid)
          {
              "#{index}": {
                  'coefficient': association.coefficient,
                  'order_number': sub_quota.quota_order_number_id,
                  'commodity_codes': sub_quota.goods_nomenclature_item_ids.join('\r\n')
              }
          }
        end.reduce(:merge)
      end

      def extract_quota_periods_settings
        {
            '0': {
                'type': 'custom',
                'repeat': 'false',
                'balance': '',
                'measurement_unit_id': '',
                'measurement_unit_qualifier_id': '',
                'periods': extract_period_settings,
                'parent_quota': extract_parent_quota_settings
            }
        }
      end

      def extract_parent_quota_settings
        quota_association = QuotaAssociation.where(sub_quota_definition_sid: quota_definition.quota_definition_sid, relation_type: 'NM').first
        if quota_association.present?
          parent_quota_order_number = QuotaDefinition.find(quota_definition_sid: quota_association.main_quota_definition_sid).quota_order_number_id
          balance_settings = QuotaDefinition.where(quota_order_number_id: parent_quota_order_number).order(:validity_start_date).
              map.with_index do |period, index|
            {
                "#{index}": {
                    'balance': period.initial_volume.to_s
                }
            }
          end.reduce(:merge)
          {
              'associate': 'true',
              'order_number': parent_quota_order_number,
              'balances': balance_settings
          }
        else
          {
              'associate': 'false'
          }
        end
      end

      def extract_period_settings
        quota_definitions.map.with_index do |period, index|
          {
              "#{index}": {
                  'quota_definition_sid': period.quota_definition_sid,
                  'balance': period.initial_volume.to_s,
                  'critical': (period.critical_state == 'Y').to_s,
                  'end_date': period.validity_end_date.strftime('%d/%m/%Y'),
                  'start_date': period.validity_start_date.strftime('%d/%m/%Y'),
                  'criticality_threshold': period.critical_threshold.to_s,
                  'measurement_unit_id': '',
                  'measurement_unit_code': period.measurement_unit_code,
                  'measurement_unit_qualifier_id': '',
                  'measurement_unit_qualifier_code': period.measurement_unit_qualifier_code,
                  'duty_expressions': extract_duty_expressions(period)
              }
          }
        end.reduce(:merge)
      end

      def extract_duty_expressions(period)
        measure = Measure.where(ordernumber: period.quota_order_number_id, validity_start_date: period.validity_start_date).first
        if measure.present?
          measure.measure_components.map.with_index do |component, index|
            {
                "#{index}": component.to_json
            }
          end.reduce(:merge)
        end
      end

      def extract_excluded_geographical_area_ids
        if quota_origins.present?
          quota_order_number_origin_sid = quota_origins.first.quota_order_number_origin_sid
          area_ids = QuotaOrderNumberOriginExclusion.where(quota_order_number_origin_sid: quota_order_number_origin_sid).map do |e|
            e.excluded_geographical_area_sid
          end
          GeographicalArea.where(geographical_area_sid: area_ids).map do |area|
            area.geographical_area_id
          end.uniq
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
          end.uniq
        end
      end

      begin :helper_methods
        def to_indexed_object(subject)
          if subject.kind_of?(Array)
            array_to_indexed_object(subject)
          elsif subject.kind_of?(Hash)
            hash_to_indexed_object(subject)
          else
            subject
          end
        end

        def hash_to_indexed_object(hash)
          hash.map do |key, item|
            {
                "#{key}": to_indexed_object(item)
            }
          end.reduce(:merge)
        end

        def array_to_indexed_object(array)
          array.map.with_index do |item, index|
            {
                "#{index}": to_indexed_object(item)
            }
          end.reduce(:merge)
        end
      end
    end
  end
end
