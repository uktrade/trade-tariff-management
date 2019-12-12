class QuotaOrderNumberOriginValidator < TradeTariffBackend::Validator
  #
  # TODO: We need to make sure and confirm code of this comformance rule
  #
  validation :QONO1, 'Order number can not be blank.', on: %i[create update] do
    validates :presence, of: :quota_order_number_sid
  end

  validation :QONO2, 'Geographical area can not be blank.', on: %i[create update] do
    validates :presence, of: :geographical_area_id
  end

  validation :ON5, 'There may be no overlap in time of two quota order number origins with the same quota order number SID and geographical area id.' do |record|
    # TODO: confirm geographical_area_sid or geographical_area_id
    if record.validity_end_date.present?
      record.class.where(
        quota_order_number_sid: record.quota_order_number_sid,
        geographical_area_sid: record.geographical_area_sid
      ) {
        (
          (validity_end_date > record.validity_start_date) &
          (validity_start_date < record.validity_end_date)
        ) |
          (
            (validity_start_date < record.validity_end_date) &
            (validity_end_date > record.validity_end_date)
          )
      }.empty?
    else
      record.class.where(
        quota_order_number_sid: record.quota_order_number_sid,
        geographical_area_sid: record.geographical_area_sid
      ) {
        validity_end_date > record.validity_start_date
      }.empty?
    end
  end

  validation :ON6, 'The validity period of the geographical area must span the validity period of the quota order number origin.' do
    validates :validity_date_span, of: :geographical_area
  end

  validation :ON10, 'When a quota order number is used in a measure then the validity period of the quota order number origin must span the validity period of the measure. This rule is only applicable for measures with start date after 31/12/2007.' do |record|
    measure = Measure.where(ordernumber: record.quota_order_number&.quota_order_number_id).last
    if record.quota_order_number.present? && measure.present? && measure.validity_start_date.to_date > Date.new(2007, 12, 31)
      (
        record.validity_start_date <= measure.validity_start_date
      ) && (
        (record.validity_end_date.blank? && measure.validity_end_date.blank?) ||
        (record.validity_end_date.present? && measure.validity_end_date.present? && (record.validity_end_date >= measure.validity_end_date))
      )
    end
  end

  validation :ON12, 'The quota order number origin cannot be deleted if it is used in a measure. This rule is only applicable for measure with start date after 31/12/2007.', on: [:destroy] do |record|
    record.quota_order_number.blank? || record.quota_order_number.measure.blank? || record.quota_order_number.measure.validity_start_date.to_date <= Date.new(2007, 12, 31)
  end

  #
  # NEED_TO_CHECK
  #
  # NoMethodError (undefined method `quota_order_number_origin_exclusion' for #<QuotaOrderNumberOrigin:0x000000000544ca00>
  #
  # validation :ON13, 'An exclusion can only be entered if the order number origin is a geographical area group (area code = 1).' do |record|
  #   if record.quota_order_number_origin_exclusion.present?
  #     record.geographical_area.present? && record.geographical_area.geographical_code == "1"
  #   end
  # end

  # validation :ON14, 'The excluded geographical area must be a member of the geographical area group.' do |record|
  #   if record.quota_order_number_origin_exclusion.present?
  #     record.geographical_area.present? && record.geographical_area.parent_geographical_area_group_sid == record.quota_order_number_origin_exclusion.geographical_area.parent_geographical_area_group_sid
  #   end
  # end
end
