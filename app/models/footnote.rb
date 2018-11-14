class Footnote < Sequel::Model

  include ::XmlGeneration::BaseHelper
  include ::WorkbasketHelpers::Association

  plugin :time_machine
  plugin :oplog, primary_key: [:footnote_type_id, :footnote_id]
  plugin :conformance_validator

  set_primary_key [:footnote_type_id, :footnote_id]


  many_to_many :footnote_descriptions, join_table: :footnote_description_periods,
                                       left_primary_key: [:footnote_type_id, :footnote_id],
                                       left_key: [:footnote_type_id, :footnote_id],
                                       right_key: [:footnote_description_period_sid,
                                                   :footnote_type_id,
                                                   :footnote_id],
                                       right_primary_key: [:footnote_description_period_sid,
                                                           :footnote_type_id,
                                                           :footnote_id] do |ds|
    ds.with_actual(FootnoteDescriptionPeriod)
      .order(Sequel.desc(:footnote_description_periods__validity_start_date))
  end

  def footnote_description
    footnote_descriptions(reload: true).first
  end

  one_to_one :footnote_type, primary_key: :footnote_type_id,
                             key: :footnote_type_id

  one_to_many :footnote_description_periods, primary_key: [:footnote_type_id,
                                                           :footnote_id],
                                             key: [:footnote_type_id,
                                                   :footnote_id]

  one_to_many :footnote_association_measures, primary_key: [:footnote_type_id,
                                                            :footnote_id],
                                              key: [:footnote_type_id,
                                                    :footnote_id]

  many_to_many :measures, join_table: :footnote_association_measures,
                          left_key: [:footnote_type_id, :footnote_id],
                          right_key: [:measure_sid]
  one_to_many :footnote_association_goods_nomenclatures, key: [:footnote_type, :footnote_id],
                                                         primary_key: [:footnote_id, :footnote_type_id]
  many_to_many :goods_nomenclatures, join_table: :footnote_association_goods_nomenclatures,
                                     left_key: [:footnote_type, :footnote_id],
                                     right_key: [:goods_nomenclature_sid]
  one_to_many :footnote_association_erns, key: [:footnote_type, :footnote_id],
                                          primary_key: [:footnote_type_id, :footnote_id]
  many_to_many :export_refund_nomenclatures, join_table: :footnote_association_erns,
                                     left_key: [:footnote_type, :footnote_id],
                                     right_key: [:export_refund_nomenclature_sid]
  one_to_many :footnote_association_additional_codes, key: [:footnote_type_id, :footnote_id],
                                                      primary_key: [:footnote_id, :footnote_type_id]
  many_to_many :additional_codes, join_table: :footnote_association_additional_codes,
                                  left_key: [:footnote_type_id, :footnote_id],
                                  right_key: [:additional_code_sid]
  many_to_many :meursing_headings, join_table: :footnote_association_meursing_headings,
                                  left_key: [:footnote_type, :footnote_id],
                                  right_key: [:meursing_table_plan_id, :meursing_heading_number]


  delegate :description, :formatted_description, to: :footnote_description, allow_nil: true

  dataset_module do
    def national
      where(national: true)
    end

    def q_search(filter_ops)
      scope = actual

      if filter_ops[:description].present?
        q_rule = "#{filter_ops[:description]}%"

        scope = scope.join_table(:inner,
          :footnote_descriptions,
          footnote_type_id: :footnote_type_id,
          footnote_id: :footnote_id
        ).where("
          footnotes.footnote_id ilike ? OR
          footnote_descriptions.description ilike ?",
          q_rule, q_rule
        )
      end

      if filter_ops[:footnote_type_id].present?
        scope = scope.where(
          "footnotes.footnote_type_id = ?", filter_ops[:footnote_type_id]
        )
      end

      scope.order(Sequel.asc(:footnotes__footnote_id))
           .all
           .uniq { |item| item.description }
    end

    begin :find_footnotes_search_filters
      def keywords_search(keyword)
        where("
          footnotes.footnote_id ilike ? OR
          footnote_descriptions.description ilike ?",
          "#{keyword}%", "%#{keyword}%"
        )
      end

      def by_footnote_type_id(footnote_type_id)
        where("footnotes.footnote_type_id = ?", footnote_type_id)
      end

      def by_commodity_codes(commodity_codes)
        join_table(:inner,
          :footnote_association_goods_nomenclatures,
          footnote_type: :footnote_type_id,
          footnote_id: :footnote_id,
          goods_nomenclature_item_id: commodity_codes
        )
      end

      def by_measure_sids(list_of_measure_sids)
        join_table(:inner,
          :footnote_association_measures,
          footnote_type_id: :footnote_type_id,
          footnote_id: :footnote_id,
          measure_sid: list_of_measure_sids
        )
      end

      def after_or_equal(start_date)
        where("footnotes.validity_start_date >= ?", start_date)
      end

      def before_or_equal(end_date)
        where(
          "footnotes.validity_end_date IS NOT NULL AND footnotes.validity_end_date <= ?", end_date
        )
      end

      def default_join
        join_table(:inner,
          :footnote_descriptions,
          footnote_type_id: :footnote_type_id,
          footnote_id: :footnote_id
        )
      end

      def default_distinct
        distinct(
          :footnotes__footnote_type_id,
          :footnotes__footnote_id
        )
      end

      def default_order
        default_distinct.default_join.order(
          Sequel.asc(:footnotes__footnote_type_id),
          Sequel.asc(:footnotes__footnote_id)
        )
      end

      def custom_field_order(sort_by_field, sort_direction)
        sortable_rule = if sort_by_field.in?(FootnoteSearch::SIMPLE_SORTABLE_MODES)
          "footnotes__#{sort_by_field}".to_sym
        else
          :footnote_descriptions__description
        end

        order_rule = if sort_direction.to_sym == :desc
          Sequel.desc(sortable_rule)
        else
          Sequel.asc(sortable_rule)
        end

        default_join.order(order_rule)
      end
    end
  end

    # FO4
    # length_of :footnote_description_periods, minimum: 1
    # # FO4
    # associated :footnote_description_periods, ensure: :first_footnote_description_period_is_valid
    # # FO5, FO6, FO7, FO9, FO10
    # associated [:measures,
    #             :goods_nomenclatures,
    #             :export_refund_nomenclatures,
    #             :additional_codes,
    #             :meursing_headings], ensure: :spans_validity_period_of_associations
    # # FO17
    # associated :footnote_type, ensure: :footnote_type_validity_period_spans_validity_periods

  def code
    "#{footnote_type_id}#{footnote_id}"
  end

  def abbreviation
    "#{footnote_type_id} - #{footnote_id}"
  end

  def record_code
    "200".freeze
  end

  def subrecord_code
    "00".freeze
  end

  def json_mapping
    {
      footnote_type_id: footnote_type_id,
      footnote_id: footnote_id,
      description: description
    }
  end

  def to_json(options = {})
    json_mapping
  end

  def decorate
    FootnoteDecorator.decorate(self)
  end

  def associated_records_count
    goods_nomenclatures.count +
    export_refund_nomenclatures.count +
    measures.count +
    additional_codes.count +
    meursing_headings.count
  end

  def commodity_codes
    prepare_collection(goods_nomenclatures, :goods_nomenclature_item_id)
  end

  def measure_sids
    prepare_collection(measures, :measure_sid)
  end

  def prepare_collection(list, data_field_name)
    return [] if list.blank?

    list.map do |item|
      item.public_send(data_field_name)
    end.reject do |i|
      i.blank?
    end.uniq
       .map(&:to_s)
  end

  class << self
    def max_per_page
      10
    end

    def default_per_page
      10
    end

    def max_pages
      999
    end
  end
end
