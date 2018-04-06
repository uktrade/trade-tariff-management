class MeasureForm
  extend ActiveModel::Naming
  include ActiveModel::Conversion
  include ActiveModel::Validations

  MEASURE_TYPE_MAPPING = %w(
    oid
    measure_type_id
    measure_type_series_id
    validity_start_date
    validity_end_date
    measure_type_acronym
    description
  )

  MEASURE_TYPE_SERIES_MAPPING = %w(
    oid
    measure_type_series_id
    validity_start_date
    validity_end_date
    description
  )

  attr_accessor :validity_start_date,
                :validity_end_date,
                :measure_type_series_id,
                :measure_type_id,
                :geographical_area_id,
                :goods_nomenclature_item_id,
                :geographical_area_sid,
                :goods_nomenclature_sid,
                :ordernumber,
                :additional_code_type_id,
                :additional_code_id,
                :additional_code_sid,
                :tariff_measure_number,
                :geographical_area_type,
                :geographical_area_proxy,
                :excluded_geographical_areas,
                :measure

  def initialize(measure)
    @measure = measure
  end

  def attributes=(attrs={})
    attrs.each do |k,v|
      self.public_send("#{k}=", v) if self.respond_to?("#{k}=")
    end
  end

  def measure_types_collection
    if measure_type_series_id.present?
      MeasureType.where(measure_type_series_id: measure_type_series_id)
    else
      all_measure_types
    end
  end

  def measure_types_json
    @mt_json ||= Rails.cache.fetch(:measures_form_measure_types_json, expires_in: 8.hours) do
      hash_collection(all_measure_types, MEASURE_TYPE_MAPPING)
    end
  end

  def measure_types_series_json
    @mtypes_series_json ||= Rails.cache.fetch(:measures_form_measure_types_series_json, expires_in: 8.hours) do
      hash_collection(measure_type_series_collection, MEASURE_TYPE_SERIES_MAPPING)
    end
  end

  def geographical_areas_json
    @ga_json ||= Rails.cache.fetch(:measures_form_geographical_areas_json, expires_in: 8.hours) do
      list = {}

      all_geographical_areas.each do |group|
        list[group.geographical_area_id] = group.contained_geographical_areas.map do |child|
          {
            geographical_area_id: child.geographical_area_id,
            description: child.description
          }
        end
      end

      list
    end
  end

  def all_measure_types
    @all_mt ||= Rails.cache.fetch(:measures_form_measure_types, expires_in: 8.hours) do
      MeasureType.actual
                 .all
    end
  end

  def measure_type_series_collection
    @series ||= Rails.cache.fetch(:measures_form_measure_type_series, expires_in: 8.hours) do
      MeasureTypeSeries.actual
                       .all
    end
  end

  def all_geographical_areas
    @all_ga ||= GeographicalArea.actual
                      .all
  end

  def all_geographical_countries
    @all_gc ||= GeographicalArea.actual
                      .countries
                      .all
  end

  def geographical_groups_except_erga_omnes
    @ggeeo ||= GeographicalArea.actual.groups
                      .except_erga_omnes
                      .all
  end

  def geographical_area_erga_omnes
    @gaeo ||= GeographicalArea.erga_omnes_group
  end

  def hash_collection(items, mapping)
    list = []

    items.each do |item|
      item_hash = {}

      mapping.each do |k|
        item_hash[k] = item.public_send(k)
      end

      list << item_hash
    end

    list
  end
end

