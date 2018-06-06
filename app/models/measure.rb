class Measure < Sequel::Model

  include ::XmlGeneration::BaseHelper

  VALID_ROLE_TYPE_IDS = [
    1, # Base regulation
    2, # Modification
    3, # Provisional anti-dumping/countervailing duty
    4  # Definitive anti-dumping/countervailing duty
  ]

  set_primary_key [:measure_sid]
  plugin :time_machine, period_start_column: :effective_start_date,
                        period_end_column: :effective_end_date
  plugin :oplog, primary_key: :measure_sid
  plugin :conformance_validator
  plugin :national

  many_to_one :measure_group, key: :measure_group_id,
                              foreign_key: :id

  many_to_one :goods_nomenclature, key: :goods_nomenclature_sid,
                                   foreign_key: :goods_nomenclature_sid

  many_to_one :export_refund_nomenclature, key: :export_refund_nomenclature_sid,
                                   foreign_key: :export_refund_nomenclature_sid

  one_to_one :measure_type, primary_key: :measure_type_id,
                    key: :measure_type_id,
                    class_name: MeasureType do |ds|
                      ds.with_actual(MeasureType)
                    end

  one_to_many :measure_conditions, key: :measure_sid,
    order: [Sequel.asc(:condition_code), Sequel.asc(:component_sequence_number)]

  one_to_one :geographical_area, key: :geographical_area_sid,
                        primary_key: :geographical_area_sid,
                        class_name: GeographicalArea do |ds|
    ds.with_actual(GeographicalArea)
  end

  one_to_many :measure_excluded_geographical_areas, key: :measure_sid,
                                                    primary_key: :measure_sid

  many_to_many :excluded_geographical_areas, join_table: :measure_excluded_geographical_areas,
                                             left_key: :measure_sid,
                                             left_primary_key: :measure_sid,
                                             right_key: :excluded_geographical_area,
                                             right_primary_key: :geographical_area_id,
                                             order: Sequel.asc(:geographical_area_id),
                                             class_name: 'GeographicalArea'

  many_to_many :footnotes, join_table: :footnote_association_measures,
                           order: [Sequel.asc(:footnote_type_id, nulls: :first),
                                   Sequel.asc(:footnote_id, nulls: :first)],
                           left_key: :measure_sid,
                           right_key: [:footnote_type_id, :footnote_id] do |ds|
                             ds.with_actual(Footnote)
                           end

  one_to_many :footnote_association_measures, key: :measure_sid, primary_key: :measure_sid

  one_to_many :measure_components, key: :measure_sid

  one_to_one :additional_code, key: :additional_code_sid,
                               primary_key: :additional_code_sid do |ds|
    ds.with_actual(AdditionalCode)
  end

  one_to_one :meursing_additional_code, key: :additional_code,
                                        primary_key: :additional_code_id do |ds|
    ds.with_actual(MeursingAdditionalCode)
  end

  many_to_one :additional_code_type, class_name: 'AdditionalCodeType',
                          key: :additional_code_type_id,
                          primary_key: :additional_code_type_id

  one_to_one :quota_order_number, key: :quota_order_number_id,
                                  primary_key: :ordernumber do |ds|
    ds.with_actual(QuotaOrderNumber)
      .order(Sequel.desc(:validity_start_date))
  end

  many_to_many :full_temporary_stop_regulations, join_table: :fts_regulation_actions,
                                                 left_primary_key: :measure_generating_regulation_id,
                                                 left_key: :stopped_regulation_id,
                                                 right_key: :fts_regulation_id,
                                                 right_primary_key: :full_temporary_stop_regulation_id do |ds|
                                                   ds.with_actual(FullTemporaryStopRegulation)
                                                 end

  delegate :third_country?, :excise?, :vat?, to: :measure_type, allow_nil: true

  def full_temporary_stop_regulation
    full_temporary_stop_regulations.first
  end

  one_to_many :measure_partial_temporary_stops, primary_key: :measure_generating_regulation_id,
                                                key: :partial_temporary_stop_regulation_id

  def measure_partial_temporary_stop
    measure_partial_temporary_stops.first
  end

  many_to_one :modification_regulation, primary_key: [:modification_regulation_id,
                                                      :modification_regulation_role],
                                        key: [:measure_generating_regulation_id,
                                              :measure_generating_regulation_role]

  many_to_one :base_regulation, primary_key: [:base_regulation_id,
                                      :base_regulation_role],
                                key: [:measure_generating_regulation_id,
                                      :measure_generating_regulation_role]

  def validity_start_date
    if self[:validity_start_date].present?
      self[:validity_start_date]
    else
      generating_regulation.try(:validity_start_date)
    end
  end

  def validity_end_date
    if national
      self[:validity_end_date]
    elsif self[:validity_end_date].present? && generating_regulation.present? && generating_regulation.effective_end_date.present?
      (self[:validity_end_date] > generating_regulation.effective_end_date) ? generating_regulation.effective_end_date : self[:validity_end_date]
    elsif self[:validity_end_date].present? && validity_date_justified?
      self[:validity_end_date]
    elsif generating_regulation.present?
      generating_regulation.effective_end_date
    else
      nil
    end
  end

  def generating_regulation
    @generating_regulation ||= case measure_generating_regulation_role
                               when 1 then base_regulation
                               when 4 then modification_regulation
                               else
                                 base_regulation
                               end
  end

  # Soft-deleted
  def invalidated?
    invalidated_at.present?
  end

  dataset_module do
    def by_regulation_id(regulation_id)
      where(
        "measure_generating_regulation_id = ? OR justification_regulation_id = ?",
        regulation_id, regulation_id
      )
    end

    def q_search(code)
      where(Sequel.like(:goods_nomenclature_item_id, "#{code}%"))
    end

    def with_base_regulations
      query = if model.point_in_time.present?
        distinct(:measure_generating_regulation_id, :measure_type_id, :goods_nomenclature_sid, :geographical_area_id, :geographical_area_sid, :additional_code_type_id, :additional_code_id).select(Sequel.expr(:measures).*)
      else
        select(Sequel.expr(:measures).*)
      end
      query.
        select_append(Sequel.as(Sequel.case({{Sequel.qualify(:measures, :validity_start_date)=>nil}=>Sequel.lit('base_regulations.validity_start_date')}, Sequel.lit('measures.validity_start_date')), :effective_start_date)).
        select_append(Sequel.as(Sequel.case({{Sequel.qualify(:measures, :validity_end_date)=>nil}=>Sequel.lit('base_regulations.effective_end_date')}, Sequel.lit('measures.validity_end_date')), :effective_end_date)).
        join_table(:inner, :base_regulations, base_regulations__base_regulation_id: :measures__measure_generating_regulation_id).
        actual_for_base_regulations
    end

    def with_modification_regulations
      query = if model.point_in_time.present?
        distinct(:measure_generating_regulation_id, :measure_type_id, :goods_nomenclature_sid, :geographical_area_id, :geographical_area_sid, :additional_code_type_id, :additional_code_id).select(Sequel.expr(:measures).*)
      else
        select(Sequel.expr(:measures).*)
      end
      query.
        select_append(Sequel.as(Sequel.case({{Sequel.qualify(:measures, :validity_start_date)=>nil}=>Sequel.lit('modification_regulations.validity_start_date')}, Sequel.lit('measures.validity_start_date')), :effective_start_date)).
        select_append(Sequel.as(Sequel.case({{Sequel.qualify(:measures, :validity_end_date)=>nil}=>Sequel.lit('modification_regulations.effective_end_date')}, Sequel.lit('measures.validity_end_date')), :effective_end_date)).
        join_table(:inner, :modification_regulations, modification_regulations__modification_regulation_id: :measures__measure_generating_regulation_id).
        actual_for_modifications_regulations
    end

    def actual_for_base_regulations
      if model.point_in_time.present?
        filter{|o| o.<=(Sequel.case({{Sequel.qualify(:measures, :validity_start_date)=>nil}=>Sequel.lit('base_regulations.validity_start_date')}, Sequel.lit('measures.validity_start_date')), model.point_in_time) &
        (o.>=(Sequel.case({{Sequel.qualify(:measures, :validity_end_date)=>nil}=>Sequel.lit('base_regulations.effective_end_date')}, Sequel.lit('measures.validity_end_date')), model.point_in_time) | ({Sequel.case({{Sequel.qualify(:measures, :validity_end_date)=>nil}=>Sequel.lit('base_regulations.effective_end_date')}, Sequel.lit('measures.validity_end_date')) => nil})) }
      else
        self
      end
    end

    def actual_for_modifications_regulations
      if model.point_in_time.present?
        filter{|o| o.<=(Sequel.case({{Sequel.qualify(:measures, :validity_start_date)=>nil}=>Sequel.lit('modification_regulations.validity_start_date')}, Sequel.lit('measures.validity_start_date')), model.point_in_time) &
        (o.>=(Sequel.case({{Sequel.qualify(:measures, :validity_end_date)=>nil}=>Sequel.lit('modification_regulations.effective_end_date')}, Sequel.lit('measures.validity_end_date')), model.point_in_time) | ({Sequel.case({{Sequel.qualify(:measures, :validity_end_date)=>nil}=>Sequel.lit('modification_regulations.effective_end_date')}, Sequel.lit('measures.validity_end_date')) => nil})) }
      else
        self
      end
    end

    def with_measure_type(condition_measure_type)
      where(measures__measure_type_id: condition_measure_type.to_s)
    end

    def valid_since(first_effective_timestamp)
      where("measures.validity_start_date >= ?", first_effective_timestamp)
    end

    def valid_to(last_effective_timestamp)
      where("measures.validity_start_date <= ?", last_effective_timestamp)
    end

    def valid_before(last_effective_timestamp)
      where("measures.validity_start_date < ?", last_effective_timestamp)
    end

    def valid_from(timestamp)
      where("measures.validity_start_date >= ?", timestamp)
    end

    def not_terminated
      where("measures.validity_end_date IS NULL")
    end

    def terminated
      where("measures.validity_end_date IS NOT NULL")
    end

    def with_gono_id(goods_nomenclature_item_id)
      where(goods_nomenclature_item_id: goods_nomenclature_item_id)
    end

    def with_tariff_measure_number(tariff_measure_number)
      where(tariff_measure_number: tariff_measure_number)
    end

    def with_geographical_area(area)
      where(geographical_area_id: area)
    end

    def with_duty_amount(amount)
      join_table(:left, MeasureComponent, measures__measure_sid: :measure_components__measure_sid).
      where(measure_components__duty_amount: amount)
    end

    def for_candidate_measure(candidate_measure)
      where(measure_type_id: candidate_measure.measure_type_id,
            validity_start_date: candidate_measure.validity_start_date,
            additional_code_type_id: candidate_measure.additional_code_type_id,
            additional_code_id: candidate_measure.additional_code_id,
            goods_nomenclature_item_id: candidate_measure.goods_nomenclature_item_id,
            geographical_area_id: candidate_measure.geographical_area_id,
            national: true)
    end

    def expired_before(candidate_measure)
      where(measure_type_id: candidate_measure.measure_type_id,
            additional_code_type_id: candidate_measure.additional_code_type_id,
            additional_code_id: candidate_measure.additional_code_id,
            goods_nomenclature_item_id: candidate_measure.goods_nomenclature_item_id,
            geographical_area_id: candidate_measure.geographical_area_id,
            national: true).
      where("validity_start_date < ?", candidate_measure.validity_start_date).
      where(validity_end_date: nil)
    end

    def non_invalidated
      where(measures__invalidated_at: nil)
    end

    include ::Measures::SearchFilters::FindMeasuresCollection
  end

  def set_searchable_data!
    ops = {}

    if measure_generating_regulation_id.present?
      ops[:regulation_code] = generating_regulation_code
    end

    if measure_group.present?
      ops[:group_name] = measure_group.name
    end

    if excluded_geographical_areas.present?
      joined_areas_str = excluded_geographical_areas.map(&:geographical_area_id).uniq.join("_")
      ops[:excluded_geographical_areas_names] = "_" + joined_areas_str + "_"
    end

    if measure_components.present?
      ops[:duty_expressions] = measure_components.map do |m_component|
        duty_amount = m_component.duty_amount.present? ? m_component.duty_amount.to_f.to_s : ''

        {
          duty_expression_id: m_component.duty_expression_id,
          duty_amount: duty_amount,
          monetary_unit_code: m_component.monetary_unit_code.to_s,
          measurement_unit_code: m_component.measurement_unit_code.to_s
        }
      end
      ops[:duty_expressions_count] = measure_components.count
    end

    if measure_conditions.present?
      condition_codes = measure_conditions.map(&:condition_code).uniq
      ops[:measure_conditions] = "_" + condition_codes.join("_") + "_"
      ops[:measure_conditions_count] = condition_codes.count
    end

    if footnotes.present?
      ops[:footnotes] = footnotes.map do |footnote|
        {
          footnote_id: footnote.footnote_id,
          footnote_type_id: footnote.footnote_type_id
        }
      end
      ops[:footnotes_count] = footnotes.count
    end

    self.searchable_data = ops.to_json
    save
  end

  def_column_accessor :effective_end_date, :effective_start_date

  def national?
    national
  end

  def validate!
    model.validate(self)
  end

  def validity_date_justified?
    justification_regulation_role.present? && justification_regulation_id.present?
  end

  def generating_regulation_present?
    measure_generating_regulation_id.present? && measure_generating_regulation_role.present?
  end

  def measure_generating_regulation_id
    result = self[:measure_generating_regulation_id]

    # https://www.pivotaltracker.com/story/show/35164477
    case result
    when "D9500019"
      "D9601421"
    else
      result
    end
  end

  def id
    measure_sid
  end

  def generating_regulation_code(regulation_code = measure_generating_regulation_id)
    "#{regulation_code.first}#{regulation_code[3..6]}/#{regulation_code[1..2]}"
  end

  def generating_regulation_url(for_suspending_regulation=false)
    return false if national?

    MeasureService::CouncilRegulationUrlGenerator.new(
      for_suspending_regulation ? suspending_regulation : generating_regulation
    ).generate
  end

  def origin
    if measure_sid >= 0
      "eu"
    else
      "uk"
    end
  end

  def import
    measure_type.present? && measure_type.trade_movement_code.in?(MeasureType::IMPORT_MOVEMENT_CODES)
  end

  def export
    measure_type.present? && measure_type.trade_movement_code.in?(MeasureType::EXPORT_MOVEMENT_CODES)
  end

  def suspended?
    full_temporary_stop_regulation.present? || measure_partial_temporary_stop.present?
  end

  def suspending_regulation
    full_temporary_stop_regulation.presence || measure_partial_temporary_stop
  end

  def associated_to_non_open_ended_gono?
    goods_nomenclature.present? && goods_nomenclature.validity_end_date.present?
  end

  def duty_expression
    measure_components.map(&:duty_expression_str).join(" ")
  end

  def duty_expression_with_national_measurement_units_for(declarable)
    national_measurement_units = national_measurement_units_for(declarable)
    if national_measurement_units.present?
      "#{duty_expression} (#{national_measurement_units.join(" - ")})"
    else
      duty_expression
    end
  end

  def formatted_duty_expression
    measure_components.map(&:formatted_duty_expression).join(" ")
  end

  def conditions_short_list
    measure_conditions.map(&:short_abbreviation).join(", ")
  end

  def national_measurement_units_for(declarable)
    if excise? && declarable && declarable.national_measurement_unit_set.present?
      declarable.national_measurement_unit_set
                .national_measurement_unit_set_units
                .select(&:present?)
                .select{ |nmu| nmu.level > 1 }
                .map(&:to_s)
    end
  end

  def formatted_duty_expression_with_national_measurement_units_for(declarable)
    national_measurement_units = national_measurement_units_for(declarable)
    if national_measurement_units.present?
      "#{formatted_duty_expression} (#{national_measurement_units.join(" - ")})"
    else
      formatted_duty_expression
    end
  end

  def meursing?
    measure_components.any?(&:meursing?)
  end

  def order_number
    if quota_order_number.present?
      quota_order_number
    elsif ordernumber.present?
      # TODO refactor if possible
      qon = QuotaOrderNumber.new(quota_order_number_id: ordernumber)
      qon.associations[:quota_definition] = nil
      qon
    end
  end

  def self.changes_for(depth = 1, conditions = {})
    operation_klass.select(
      Sequel.as(Sequel.cast_string("Measure"), :model),
      :oid,
      :operation_date,
      :operation,
      Sequel.as(depth, :depth)
    ).where(conditions)
     .where { |o| o.<=(:validity_start_date, point_in_time) }
     .limit(TradeTariffBackend.change_count)
     .order(Sequel.desc(:operation_date, nulls: :last))
  end

  def status_title
    if status.present?
      I18n.t(:measures)[:states][status.to_sym]
    else
      "-"
    end
  end

  def additional_code_title
    return "" if additional_code_id.blank?

    "#{additional_code_type_id} #{additional_code_id}"
  end

  def record_code
    "430".freeze
  end

  def subrecord_code
    "00".freeze
  end

  def self.max_per_page
    25
  end

  def self.default_per_page
    25
  end

  def self.max_pages
    999
  end

  #
  # TODO: removed duplications
  #

  def to_table_json
    {
      measure_sid: measure_sid,
      regulation: generating_regulation_code + " (#{measure_generating_regulation_id})",
      measure_type_id: measure_type_id,
      validity_start_date: validity_start_date.strftime("%d %b %Y"),
      validity_end_date: validity_end_date.try(:strftime, "%d %b %Y") || "-",
      goods_nomenclature_id: goods_nomenclature_item_id,
      additional_code_id: additional_code_title,
      geographical_area: geographical_area.try(:geographical_area_id),
      excluded_geographical_areas: excluded_geographical_areas.map(&:geographical_area_id).join(", ") || "-",
      duties: duty_expression,
      conditions: conditions_short_list,
      footnotes: footnotes.map(&:abbreviation).join(", "),
      last_updated: (updated_at || added_at).try(:strftime, "%d %b %Y") || "-",
      status: status_title
    }
  end

  def to_json(options = {})
    {
      measure_sid: measure_sid,
      regulation: generating_regulation.to_json,
      measure_type: measure_type.to_json,
      validity_start_date: validity_start_date.try(:strftime, "%d %b %Y"),
      validity_end_date: validity_end_date.try(:strftime, "%d %b %Y") || "-",
      goods_nomenclature: goods_nomenclature.try(:to_json),
      additional_code: additional_code.try(:to_json),
      geographical_area: geographical_area.try(:to_json),
      excluded_geographical_areas: excluded_geographical_areas.map(&:to_json),
      measure_components: measure_components.map(&:to_json),
      measure_conditions: measure_conditions.map(&:to_json),
      footnotes: footnotes.map(&:to_json),
      last_updated: (updated_at || added_at).try(:strftime, "%d %b %Y") || "-",
      status: status_title
    }
  end
end
