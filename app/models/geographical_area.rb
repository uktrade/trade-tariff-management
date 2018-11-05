class GeographicalArea < Sequel::Model

  include ::XmlGeneration::BaseHelper
  include ::WorkbasketHelpers::Association
  include OwnValidityPeriod

  COUNTRIES_CODES = ['0', '2'].freeze
  ERGA_OMNES = '1011'

  plugin :time_machine
  plugin :oplog, primary_key: :geographical_area_sid
  plugin :conformance_validator

  set_primary_key :geographical_area_sid

  many_to_many :geographical_area_descriptions, join_table: :geographical_area_description_periods,
                                                left_primary_key: :geographical_area_sid,
                                                left_key: :geographical_area_sid,
                                                right_key: [:geographical_area_description_period_sid,
                                                            :geographical_area_sid],
                                                right_primary_key: [:geographical_area_description_period_sid,
                                                                    :geographical_area_sid] do |ds|
    ds.with_actual(GeographicalAreaDescriptionPeriod)
      .order(Sequel.desc(:geographical_area_description_periods__validity_start_date))
  end

  one_to_one :geographical_area_membership, key: :geographical_area_sid,
                                            primary_key: :geographical_area_sid

  many_to_one :parent_geographical_area, class: self
  one_to_many :children_geographical_areas, key: :parent_geographical_area_group_sid,
                                            class: self

  one_to_one :parent_geographical_area, key: :geographical_area_sid,
                                        primary_key: :parent_geographical_area_group_sid,
                                        class_name: 'GeographicalArea'

  many_to_many :contained_geographical_areas, class_name: 'GeographicalArea',
                                              join_table: :geographical_area_memberships,
                                              left_key: :geographical_area_group_sid,
                                              right_key: :geographical_area_sid,
                                              class: self do |ds|
    ds.with_actual(GeographicalAreaMembership).order(Sequel.asc(:geographical_area_id))
  end

  many_to_many :member_of_following_geographical_areas, class_name: 'GeographicalArea',
                                                        join_table: :geographical_area_memberships,
                                                        left_key: :geographical_area_sid,
                                                        right_key: :geographical_area_group_sid,
                                                        class: self do |ds|
    ds.with_actual(GeographicalAreaMembership).order(Sequel.asc(:geographical_area_id))
  end

  one_to_many :measures, key: :geographical_area_sid,
                         primary_key: :geographical_area_sid do |ds|
    ds.with_actual(Measure)
  end

  def group?
    geographical_code == "1"
  end

  def country?
    geographical_code == "0"
  end

  def region?
    geographical_code == "2"
  end

  dataset_module do
    def by_id(id)
      where(geographical_area_id: id)
    end

    def latest
      order(Sequel.desc(:operation_date))
    end

    def countries
      where(geographical_code: COUNTRIES_CODES)
    end

    def groups
      exclude(geographical_code: COUNTRIES_CODES)
    end

    def except_erga_omnes
      exclude(geographical_area_id: GeographicalArea::ERGA_OMNES)
    end

    def to_csv
      headers = ["Code", "Description", "Type", "Start date", "End date"]

      CSV.generate(headers: true) do |csv|
        csv << headers

        all.each do |geo_area|
          geo_area = geo_area.decorate

          csv << [
            geo_area.geographical_area_id,
            geo_area.description,
            geo_area.type,
            geo_area.start_date,
            geo_area.end_date
          ]
        end
      end
    end

    begin :search_functionality
      def default_order
        distinct(:geographical_areas__geographical_area_id).order(
          Sequel.asc(:geographical_areas__geographical_area_id)
        )
      end

      def by_code(code)
        where(geographical_code: code)
      end

      def after_or_equal(start_date)
        where("validity_start_date >= ?", start_date)
      end

      def before_or_equal(end_date)
        where("validity_end_date IS NOT NULL AND validity_end_date <= ?", end_date)
      end

      def keywords_search(keywords)
        keywords = keywords.to_s.squish

        join_table(:inner,
          :geographical_area_descriptions,
          geographical_area_id: :geographical_area_id,
        ).where("
          geographical_areas.geographical_area_id ilike ? OR
          geographical_area_descriptions.description ilike ?",
          "#{keywords}%", "%#{keywords}%"
        )
      end

      def q_search(filter_ops={})
        scope = actual

        if filter_ops[:q].present?
          q_rule = "#{filter_ops[:q]}%"

          scope = scope.join_table(:inner,
            :geographical_area_descriptions,
            geographical_area_id: :geographical_area_id,
          ).where("
            geographical_areas.geographical_area_id ilike ? OR
            geographical_area_descriptions.description ilike ?",
            q_rule, q_rule
          )

          scope.order(Sequel.asc(:geographical_area_descriptions__description))
        else
          scope.order(Sequel.asc(:geographical_areas__geographical_area_id))
        end
      end
    end
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

    def erga_omnes_group
      actual.by_id(GeographicalArea::ERGA_OMNES)
            .first
    end

    def conditional_search(filter_ops={})
      group_id = filter_ops[:parent_id]

      if group_id.present?
        group = actual.by_id(group_id).first

        return [] if group.blank?

        scope = group.contained_geographical_areas
        keyword = filter_ops[:q].to_s.downcase.strip

        if keyword.present?
          scope = scope.select do |area|
            [
              area.geographical_area_id.downcase,
              area.description.downcase
            ].any? do |val|
              val.starts_with?(keyword)
            end
          end
        end

        scope
      else

        if filter_ops[:groups_only].present?
          groups.q_search(filter_ops)
        elsif filter_ops[:countries_only].present?
          countries.q_search(filter_ops)
        else
          q_search(filter_ops)
        end
      end
    end

    def actual_groups_collection_json
      TimeMachine.at(Date.current) do
        GeographicalArea.actual
                        .groups
                        .map(&:to_json)
                        .to_json
      end
    end
  end

  delegate :description, to: :geographical_area_description, allow_nil: true

  def geographical_area_description
    geographical_area_descriptions.first
  end

  def other_descriptions
    geographical_area_descriptions.select do |item|
      item.oid != geographical_area_description.oid
    end.sort do |a, b|
      b.validity_start_date.to_date <=> a.validity_start_date.to_date
    end
  end

  def to_json
    {
      geographical_area_id: geographical_area_id,
      description: description || '',
      is_country: is_country?,
      validity_start_date: validity_start_date,
      validity_end_date: validity_end_date
    }
  end

  def id
    geographical_area_id
  end

  def record_code
    "250".freeze
  end

  def subrecord_code
    "00".freeze
  end

  def is_country?
    COUNTRIES_CODES.include?(geographical_code)
  end

  def json_mapping
    {
      id: geographical_area_id,
      description: "#{geographical_area_id} - #{description}"
    }
  end

  def membership_validity_start_date
    geographical_area_membership&.validity_start_date
  end

  def membership_validity_end_date
    geographical_area_membership&.validity_end_date
  end

  def decorate
    GeographicalAreaDecorator.decorate(self)
  end
end
