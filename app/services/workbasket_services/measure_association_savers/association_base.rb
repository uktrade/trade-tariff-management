module WorkbasketServices
  module MeasureAssociationSavers
    class AssociationBase < ::WorkbasketServices::Base

      class << self
        def errors_in_collection(measure, system_ops, collection)
          errors = {}

          prepare_collection(collection, system_ops[:type_of]).map do |k, item_ops|
            ops = item_ops.merge(position: k)

            record = new(measure, system_ops, ops)
            errors[k] = record.errors unless record.valid?
          end

          errors
        end

        alias_method :validate_and_persist!, :errors_in_collection

        def prepare_collection(collection, type_of)
          return prepare_conditions(collection) if type_of.to_s == "conditions"
          return collection if collection.is_a?(Hash)

          res = {}
          collection.uniq.each_with_index do |excluded_geographical_area, index|
            res[index] = {
              position: index,
              excluded_geographical_area: excluded_geographical_area
            }
          end

          res
        end

        def prepare_conditions(collection)
          res = {}
          codes_and_items = {}

          collection.map do |k, item_ops|
            code = item_ops[:condition_code]

            res[k] = item_ops.merge(
              component_sequence_number: get_component_sequence_number!(codes_and_items, code)
            )

            if codes_and_items[code].present?
              codes_and_items[code] << k
            else
              codes_and_items[code] = [ k ]
            end
          end

          res
        end

        def get_component_sequence_number!(codes_and_items, code)
          codes_and_items[code].present? ? (codes_and_items[code].size + 1) : 1
        end
      end

      private

        def persist_record!(record)
          assigner = ::WorkbasketValueObjects::Shared::SystemOpsAssigner.new(
            record, system_ops
          )
          assigner.assign!

          rec = assigner.record
          rec.save

          rec
        end

        def set_primary_key(record, extra_increment_value=nil)
          ::WorkbasketValueObjects::Shared::PrimaryKeyGenerator.new(
            record,
            extra_increment_value
          ).assign!
        end

        def unit_ops(attrs)
          {
            duty_amount: attrs[:duty_amount],
            monetary_unit_code: attrs[:monetary_unit_code],
            measurement_unit_code: attrs[:measurement_unit_code],
            measurement_unit_qualifier_code: attrs[:measurement_unit_qualifier_code]
          }
        end
    end
  end
end
