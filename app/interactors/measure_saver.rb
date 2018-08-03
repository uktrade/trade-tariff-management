class MeasureSaver

  include ::CustomLogger

  REQUIRED_PARAMS = {
    start_date: :validity_start_date,
    operation_date: :operation_date
  }

  attr_accessor :current_admin,
                :original_params,
                :measure_params,
                :measure,
                :errors

  def initialize(current_admin, measure_params={})
    @current_admin = current_admin
    @original_params = ActiveSupport::HashWithIndifferentAccess.new(measure_params)
    @measure_params = ::Measures::AttributesNormalizer.new(original_params).normalized_params

    log_it("normalized_params: #{@measure_params.inspect}")

    @errors = {}
  end

  def valid?
    check_required_params!
    return false if @errors.present?

    @measure = Measure.new(measure_params)
    #
    # We need to assign `measure_sid` Measure before assign Geographical Area or Measure Type
    # Otherwise, we are getting
    # Sequel::Error `does not have a primary key`
    #
    # This is because MeasureValidator class is tend to work with already persisted
    # database record.
    #
    generate_measure_sid

    validate!
    errors.blank?
  end

  def persist!
    generate_measure_sid
    set_system_attrs(measure)

    attempts = 5

    begin
      measure.save
    rescue Exception => e
      attempts -= 1
      generate_measure_sid

      if attempts > 0
        retry
      else
        raise "Can't save measure: #{e.message.inspect}"
      end
    end

    post_saving_updates!
    measure.set_searchable_data!

    log_it("[SAVED MEASURE] sid: #{measure.measure_sid} | #{measure.inspect}")
  end

  private

    def check_required_params!
      REQUIRED_PARAMS.map do |k, v|
        if original_params[k.to_s].blank?
          @errors[v.to_sym] = "#{k.to_s.capitalize.split('_').join(' ')} can't be blank!"
        end
      end
    end

    def validate!
      normalizer = ::Measures::ConformanceErrorsParser.new(
        measure, MeasureValidator, @errors
      )

      measure = normalizer.record
      @errors = normalizer.errors
    end

    def generate_measure_sid
      measure.measure_sid = Measure.max(:measure_sid).to_i + 1
    end

    def post_saving_updates!
      add_excluded_geographical_areas!
      add_quota_definitions!
      add_duty_expressions!
      add_conditions!
      add_footnotes!
    end

    def add_quota_definitions!
      if measure.ordernumber.present? && original_params["existing_quota"].to_s != 'true'
        quota_def_ops = original_params["quota_periods"]

        if quota_def_ops.present?
          add_quota_order_number!
          mode = quota_def_ops.keys.first
          target_ops = quota_def_ops[mode]

          if target_ops.present?
            case mode
            when "annual", "bi_annual", "quarterly", "monthly"
              add_quota_definition!(mode, target_ops) if target_ops[:start_date].present?
            when "custom"
              add_custom_quota_definition!(target_ops)
            end
          end
        end
      end
    end

    def add_quota_order_number!
      quota_order_number = QuotaOrderNumber.new(
        quota_order_number_id: measure.ordernumber,
        validity_start_date: order_start_date
      )
      set_oplog_attrs_and_save!(quota_order_number)

      if measure.geographical_area_id.present?
        quota_order_number_origin = QuotaOrderNumberOrigin.new(
          validity_start_date: quota_order_number.validity_start_date
        )
        quota_order_number_origin.quota_order_number_sid = quota_order_number.quota_order_number_sid
        quota_order_number_origin.geographical_area_id = measure.geographical_area_id
        quota_order_number_origin.geographical_area_sid = measure.geographical_area_sid

        set_oplog_attrs_and_save!(quota_order_number_origin)
      end

      if measure.excluded_geographical_areas.present?
        measure.excluded_geographical_areas.map do |excluded_area|
          quota_order_number_origin_exclusion = QuotaOrderNumberOriginExclusion.new
          quota_order_number_origin_exclusion.quota_order_number_origin_sid = quota_order_number_origin.quota_order_number_origin_sid
          quota_order_number_origin_exclusion.excluded_geographical_area_sid = excluded_area.geographical_area_sid

          set_oplog_attrs_and_save!(quota_order_number_origin_exclusion)
        end
      end
    end

    def add_quota_definition!(mode, data)
      data.keys.select do |k|
        k.starts_with?("amount")
      end.map do |k|
        quota_definition = QuotaDefinition.new(quota_ops(mode, data, k))
        set_oplog_attrs_and_save!(quota_definition)
      end
    end

    def add_custom_quota_definition!(data)
      data.map do |k, v|
        quota_definition = QuotaDefinition.new(custom_quota_ops(v))
        set_oplog_attrs_and_save!(quota_definition)
      end
    end

    def quota_period_asc
      original_params["quota_periods"].values
                                      .first
                                      .values
                                      .sort do |a, b|
        a['start_date'] <=> b['start_date']
      end
    end

    def order_start_date
      if original_params["quota_periods"].keys.first == "custom"
        quota_period_asc.first['start_date']
                        .to_date
      else
        original_params['quota_periods'].values.first['start_date']
      end
    end

    def quota_ops(mode, data, k)
      {
        initial_volume: data[k]
      }.merge(quota_definition_main_ops)
       .merge(quota_definition_start_and_date_ops(mode, data, k))
       .merge(unit_ops(data))
    end

    def custom_quota_ops(data)
      {
        initial_volume: data["amount1"],
        validity_start_date: data[:start_date].to_date,
        validity_end_date: data[:end_date].try(:to_date)
      }.merge(quota_definition_main_ops)
       .merge(unit_ops(data))
    end

    def unit_ops(data)
      {
        monetary_unit_code: data[:monetary_unit_code],
        measurement_unit_code: data[:measurement_unit_code],
        measurement_unit_qualifier_code: data[:measurement_unit_qualifier_code],
      }
    end

    def quota_definition_main_ops
      quota_order_number = QuotaOrderNumber.where(quota_order_number_id: measure.ordernumber).first

      {
        quota_order_number_id: quota_order_number.quota_order_number_id,
        quota_order_number_sid: quota_order_number.quota_order_number_sid,
        critical_threshold: original_params[:quota_criticality_threshold],
        critical_state: original_params[:quota_status] == "critical" ? "Y" : "N",
        description: original_params[:quota_description]
      }
    end

    def quota_definition_start_and_date_ops(mode, data, k)
      ops = {}
      start_date = data[:start_date].to_date
      amount_number = k.gsub("amount", "").to_i

      case mode
      when "annual"
        ops[:validity_start_date] = start_date
        ops[:validity_end_date] = start_date + 1.year
      when "bi_annual"
        step_range = amount_number * 6
        ops[:validity_start_date] = start_date + (step_range - 6).months
        ops[:validity_end_date] = start_date + step_range.months
      when "monthly"
        ops[:validity_start_date] = start_date + (amount_number - 1).months
        ops[:validity_end_date] = start_date + amount_number.months
      when "quarterly"
        step_range = amount_number * 3
        ops[:validity_start_date] = start_date + (step_range - 3).months
        ops[:validity_end_date] = start_date + step_range.months
      end

      ops
    end

    def add_excluded_geographical_areas!
      if excluded_areas.present?
        excluded_areas.map do |area_code|
          add_excluded_geographical_area!(area_code)
        end
      end
    end

    def excluded_areas
      original_params[:excluded_geographical_areas].reject do |a|
        a.blank?
      end
    end

    def add_excluded_geographical_area!(area_code)
      area = GeographicalArea.actual
                             .where(geographical_area_id: area_code)
                             .first

      excluded_area = MeasureExcludedGeographicalArea.new(
        excluded_geographical_area: area_code
      )

      excluded_area.geographical_area_sid = area.geographical_area_sid
      excluded_area.measure_sid = measure.measure_sid
      set_oplog_attrs_and_save!(excluded_area)
    end

    def add_duty_expressions!
      measure_components = original_params[:measure_components]

      if measure_components.present?
        measure_components.each do |k, d_ops|
          if d_ops[:duty_expression_id].present?
            m_component = MeasureComponent.new(
              { duty_amount: d_ops[:amount] }.merge(unit_ops(d_ops))
            )
            m_component.measure_sid = measure.measure_sid
            m_component.duty_expression_id = d_ops[:duty_expression_id]

            set_oplog_attrs_and_save!(m_component)
          end
        end
      end
    end

    def add_conditions!
      conditions = original_params[:conditions]

      if conditions.present?
        conditions.select do |k, v|
          v[:condition_code].present?
        end.group_by do |k, v|
          v[:condition_code]
        end.map do |k, grouped_ops|
          grouped_ops.each_with_index do |data, index|
            add_condition!(index, data[1])
          end
        end
      end
    end

    def add_condition!(position, data)
      condition = MeasureCondition.new(
        action_code: data[:action_code],
        condition_code: data[:condition_code],
        condition_duty_amount: data[:amount],
        certificate_type_code: data[:certificate_type_code],
        certificate_code: data[:certificate_code],
        component_sequence_number: position + 1
      )
      condition.measure_sid = measure.measure_sid

      set_oplog_attrs_and_save!(condition)

      data[:measure_condition_components].select do |k, v|
        v[:duty_expression_id].present?
      end.map do |k, v|
        add_measure_condition_component!(condition, v)
      end
    end

    def add_measure_condition_component!(condition, data)
      mc_component = MeasureConditionComponent.new(
        { duty_amount: data[:amount] }.merge(unit_ops(data))
      )

      mc_component.measure_condition_sid = condition.measure_condition_sid
      mc_component.duty_expression_id = data[:duty_expression_id]

      set_oplog_attrs_and_save!(mc_component)
    end

    def add_footnotes!
      footnotes_list = original_params[:footnotes]

      if footnotes_list.present?
        footnotes_list.each do |k, f_ops|
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

      log_it("[ATTEMPT TO SAVE - #{record.class.name}] #{record.inspect}")

      set_system_attrs(record)
      record.save

      log_it("[SAVED - #{record.class.name}] #{record.inspect}")
    end

    def set_system_attrs(record)
      ::WorkbasketValueObjects::Shared::SystemOpsAssigner.new(
        record, system_ops
      ).assign!
    end

    def system_ops
      {
        operation_date: operation_date,
        current_admin_id: current_admin.id
      }
    end

    def operation_date
      original_params[:operation_date].to_date
    end
end
