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
              system_ops.merge(type_of: :measure_components),
              measure_components
            )
          end
        end

        def add_conditions!
          conditions = measure_ops[:conditions]

          if conditions.present?
            ::WorkbasketServices::MeasureAssociationSavers::MeasureComponents.validate_and_persist!(
              measure,
              system_ops.merge(type_of: :conditions),
              conditions
            )
          end
        end

        def add_footnotes!
          footnotes_list = measure_ops[:footnotes]

          if footnotes_list.present?
            footnotes_list.each do |f_ops|
              if f_ops[:footnote_type_id].present? &&
                 f_ops[:description].present?

                footnote = Footnote.new(
                  validity_start_date: measure.validity_start_date,
                  validity_end_date: measure.validity_end_date
                )
                footnote.footnote_type_id = f_ops[:footnote_type_id]

                set_oplog_attrs_and_save!(footnote)

                f_m = FootnoteAssociationMeasure.new
                f_m.measure_sid = measure.measure_sid
                f_m.footnote_id = footnote.footnote_id
                f_m.footnote_type_id = f_ops[:footnote_type_id]

                set_oplog_attrs_and_save!(f_m)

                fd_period = FootnoteDescriptionPeriod.new(
                  validity_start_date: footnote.validity_start_date,
                  validity_end_date: footnote.validity_end_date
                )
                fd_period.footnote_id = footnote.footnote_id
                fd_period.footnote_type_id = f_ops[:footnote_type_id]

                set_oplog_attrs_and_save!(fd_period)

                fd = FootnoteDescription.new(
                  language_id: "EN",
                  description: f_ops[:description]
                )
                fd.footnote_id = footnote.footnote_id
                fd.footnote_type_id = f_ops[:footnote_type_id]
                fd.footnote_description_period_sid = fd_period.footnote_description_period_sid

                set_oplog_attrs_and_save!(fd)
              end
            end
          end
        end

        def set_oplog_attrs_and_save!(record)
          ::WorkbasketValueObjects::Shared::PrimaryKeyGenerator.new(record).assign!

          ::WorkbasketValueObjects::Shared::SystemOpsAssigner.new(
            record, system_ops
          ).send(:assign_bulk_edit_options!)

          record.save
        end

        def system_ops
          {
            operation_date: Date.today + 1.day,
            current_admin_id: workbasket.user_id,
            workbasket_id: workbasket.id
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
