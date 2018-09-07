module WorkbasketInteractions
  module BulkEditOfMeasures
    class ItemSaver

      attr_accessor :workbasket_item,
                    :workbasket,
                    :measure

      def initialize(workbasket_item)
        @workbasket_item = workbasket_item
        @workbasket = workbasket_item.workbasket
      end

      def persist!
        add_measure!
        add_duty_expressions!
        add_conditions!
        add_footnotes!

        measure.set_searchable_data!
      end

      private

        def measure_ops
          @measure_ops ||= ::WorkbasketInteractions::BulkEditOfMeasures::ItemOpsNormalizer.new(
            workbasket_item.hash_data
          ).normalized_ops
        end

        def add_measure!
          @measure = Measure.new(
            ::Measures::BulkParamsConverter.new(
              measure_ops
            ).converted_ops
          )
          @measure.measure_sid = Measure.max(:measure_sid).to_i + 1

          set_oplog_attrs_and_save!(@measure)
        end

        def add_duty_expressions!
          measure_components = measure_ops[:measure_components]

          if measure_components.present?
            ::WorkbasketServices::MeasureAssociationSavers::MeasureComponents.validate_and_persist!(
              measure,
              association_system_ops.merge(type_of: :measure_components),
              measure_components
            )
          end
        end

        def add_conditions!
          conditions = measure_ops[:conditions]

          if conditions.present?
            ::WorkbasketServices::MeasureAssociationSavers::Conditions.validate_and_persist!(
              measure,
              association_system_ops.merge(type_of: :conditions),
              conditions
            )
          end
        end

        def add_footnotes!
          footnotes = measure_ops[:footnotes]

          if footnotes.present?
            ::WorkbasketServices::MeasureAssociationSavers::Footnotes.validate_and_persist!(
              measure,
              association_system_ops.merge(type_of: :footnotes),
              footnotes
            )
          end
        end

        def set_oplog_attrs_and_save!(record)
          ::WorkbasketValueObjects::Shared::PrimaryKeyGenerator.new(record).assign!

          ::WorkbasketValueObjects::Shared::SystemOpsAssigner.new(
            record, measure_system_ops
          ).assign!

          record.save
        end

        def measure_system_ops
          general_system_ops.merge(
            operation: "U"
          )
        end

        def association_system_ops
          general_system_ops.merge(
            operation: "C"
          )
        end

        def general_system_ops
          {
            operation_date: workbasket.operation_date,
            current_admin_id: workbasket.user_id,
            workbasket_id: workbasket.id,
            status: "awaiting_cross_check"
          }
        end

        def parsed_value(data, parent_field_name, field_name)
          parent_value = data[parent_field_name]

          if parent_value.present? && parent_value.to_s != "null"
            parent_value[field_name]
          else
            ''
          end
        end
    end
  end
end
