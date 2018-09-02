module WorkbasketInteractions
  module BulkEditOfMeasures
    class ItemSaver

      attr_accessor :workbasket_item,
                    :measure,
                    :original_params

      def initialize(workbasket_item)
        @workbasket_item = workbasket_item
      end

      def measure_params
        ActiveSupport::HashWithIndifferentAccess.new(
          workbasket_item.hash_data
        )
      end

      def persist_measure!
        @original_params = {}

        @original_params[:measure_components] = measure_params["measure_components"]
        @original_params[:conditions] = measure_params["measure_conditions"]
        @original_params[:footnotes] = measure_params["footnotes"]

        add_measure!

        add_duty_expressions! if original_params[:measure_components].present?
        add_conditions! if @original_params[:conditions].present?
        add_footnotes! if @original_params[:footnotes].present?

        measure.set_searchable_data!
      end

      def add_measure!
        @measure = Measure.new(
          ::Measures::BulkParamsConverter.new(
            measure_params
          ).converted_ops
        )
        @measure.measure_sid = Measure.max(:measure_sid).to_i + 1

        set_oplog_attrs_and_save!(@measure)
      end

      def add_duty_expressions!
        measure_components = original_params[:measure_components]

        if measure_components.present?
          measure_components.each do |d_ops|
            if d_ops[:duty_expression].present? && d_ops[:duty_expression][:duty_expression_id].present?
              m_component = MeasureComponent.new(
                { duty_amount: d_ops[:duty_amount] }.merge(unit_ops(d_ops))
              )
              m_component.measure_sid = measure.measure_sid
              m_component.duty_expression_id = d_ops[:duty_expression][:duty_expression_id]

              set_oplog_attrs_and_save!(m_component)
            end
          end
        end
      end

      def add_conditions!
        conditions = original_params[:conditions]

        if conditions.present?
          conditions.select do |v|
            v[:measure_condition_code][:condition_code].present?
          end.group_by do |v|
            v[:measure_condition_code][:condition_code]
          end.map do |k, grouped_ops|
            grouped_ops.each_with_index do |data, index|
              add_condition!(index, data)
            end
          end
        end
      end

      def add_condition!(position, data)
        condition = MeasureCondition.new(
          action_code: data[:measure_action].present? && data[:measure_action].to_s != "null" ? data[:measure_action][:action_code] : '',
          condition_code: data[:measure_condition_code].present? && data[:measure_condition_code].to_s != "null" ? data[:measure_condition_code][:condition_code] : '',
          certificate_type_code: data[:certificate_type].present? && data[:certificate_type].to_s != "null" ? data[:certificate_type][:certificate_type_code] : '',
          certificate_code: data[:certificate].present? && data[:certificate].to_s != "null" ? data[:certificate][:certificate_code] : '',
          component_sequence_number: position + 1
        )
        condition.measure_sid = measure.measure_sid

        set_oplog_attrs_and_save!(condition)

        data[:measure_condition_components].select do |v|
          v[:duty_expression][:duty_expression_id].present?
        end.map do |v|
          add_measure_condition_component!(condition, v)
        end
      end

      def add_measure_condition_component!(condition, data)
        mc_component = MeasureConditionComponent.new(
          { duty_amount: data[:duty_amount] }.merge(unit_ops(data))
        )

        mc_component.measure_condition_sid = condition.measure_condition_sid
        mc_component.duty_expression_id = data[:duty_expression][:duty_expression_id]

        set_oplog_attrs_and_save!(mc_component)
      end

      def add_footnotes!
        footnotes_list = original_params[:footnotes]

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

      def unit_ops(data)
        {
          monetary_unit_code: data[:monetary_unit].present? && data[:monetary_unit].to_s != "null" ? data[:monetary_unit][:monetary_unit_code] : '',
          measurement_unit_code: data[:measurement_unit].present? && data[:measurement_unit].to_s != "null" ? data[:measurement_unit][:measurement_unit_code] : '',
          measurement_unit_qualifier_code: data[:measurement_unit_qualifier].present? && data[:measurement_unit_qualifier].to_s != "null" ? data[:measurement_unit_qualifier][:measurement_unit_qualifier_code] : '',
        }
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
          workbasket_id: workbasket_id
        }
      end
    end
  end
end
