module Workbaskets
  class Item < Sequel::Model(:workbasket_items)

    STATES = [
      :in_progress,
      :submitted,
      :rejected
    ]

    plugin :timestamps

    many_to_one :workbasket, key: :workbasket_id,
                             foreign_key: :id

    validates do
      presence_of :status,
                  :workbasket_id,
                  :record_id,
                  :record_key,
                  :record_type

      inclusion_of :status, in: STATES.map(&:to_s)

      uniqueness_of [
        :workbasket_id,
        :record_id,
        :record_key,
        :record_type
      ]
    end

    dataset_module do
      def by_workbasket(workbasket)
        where(workbasket_id: workbasket.id)
      end

      def by_id_asc
        order(Sequel.asc(:id))
      end

      include ::BulkEditHelpers::OrderByIdsQuery
    end

    def new_data_parsed
      @new_data_parsed ||= JSON.parse(new_data)
    end

    def original_data_parsed
      @original_data_parsed ||= JSON.parse(original_data)
    end

    def hash_data
      data = new_data_parsed.present? ? new_data_parsed : original_data_parsed

      if validation_errors_parsed.present?
        data["errored_columns"] = validation_errors_parsed
      end

      if changed_values_parsed.present?
        data["changed_columns"] = changed_values_parsed
      end

      data
    end

    def validation_errors_parsed
      @validation_errors_parsed ||= JSON.parse(validation_errors)
    end

    def changed_values_parsed
      @changed_values_parsed ||= JSON.parse(changed_values)
    end

    def record
      record_type.constantize
                 .where(record_key.to_sym => record_id)
                 .first
    end

    def error_details(errored_column)
      errors_detected = Workbaskets::Workbasket.validate_measure!(
        ActiveSupport::HashWithIndifferentAccess.new(
          hash_data
        )
      )

      errors_detected.values
                     .flatten
    end

    begin :need_to_refactor

      attr_accessor :measure, :original_params

      def measure_params
        ActiveSupport::HashWithIndifferentAccess.new(
          hash_data
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

        log_it("[ATTEMPT TO SAVE - #{record.class.name}] #{record.inspect}")

        record.save

        log_it("[SAVED - #{record.class.name}] #{record.inspect}")
      end

      def system_ops
        {
          operation_date: Date.today + 1.day,
          current_admin_id: workbasket.user_id,
          workbasket_id: workbasket_id
        }
      end

      def log_it(message)
        if Rails.env.development?
          p ""
          p "-" * 100
          p ""
          p " #{message}"
          p ""
          p "-" * 100
          p ""
        end
      end
    end

    class << self
      def create_from_target_record(workbasket, target_record)
        item = new(workbasket_id: workbasket.id)

        key = target_record.primary_key
        item.record_key = key
        item.record_id = target_record.public_send(key)
        item.record_type = target_record.class.to_s
        item.original_data = target_record.to_json.to_json
        item.status = "in_progress"

        item.save
      end
    end
  end
end
