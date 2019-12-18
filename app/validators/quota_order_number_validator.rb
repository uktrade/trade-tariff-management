class QuotaOrderNumberValidator < TradeTariffBackend::Validator
  #
  # TODO: We need to make sure and confirm code of this comformance rule
  #
  validation :QON1, 'Order number can not be blank.', on: %i[create update] do
    validates :presence, of: :quota_order_number_id
  end

  # validation :QON2, 'Order number must be unique.', on: [:create, :update] do
  #   validates :uniqueness, of: [:quota_order_number_id]
  # end

  # validation :QON3, "Order number should start with '09' and can contain digits only. Could be 6 length only.", on: [:create, :update] do |record|
  #   order_number_id = record.quota_order_number_id

  #   order_number_id.blank? || (
  #     order_number_id.present? &&
  #     (/^09(\d){4}\z/.match?(order_number_id))
  #   )
  # end

  validation :ON1, 'Quota order number id + start date must be unique' do
    validates :uniqueness, of: %i[quota_order_number_id validity_start_date]
  end

  validation :ON2, 'There may be no overlap in time of two quota order numbers with the same quota order number id.' do |record|
    if record.validity_end_date.present?
      record.class.where(
        quota_order_number_id: record.quota_order_number_id
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
        quota_order_number_id: record.quota_order_number_id
      ) {
        (validity_end_date > record.validity_start_date) | Sequel.lit('validity_end_date is null')
      }.exclude(
        quota_order_number_sid: record.quota_order_number_sid
      ).empty?
    end
  end

  validation :ON3, 'The start date must be less than or equal to the end date.' do |record|
    if record.validity_end_date.present?
      record.validity_start_date <= record.validity_end_date
    end
  end

  validation :ON4, 'The referenced geographical area must exist.' do |record|
    if record.quota_order_number_origin.present?
      record.quota_order_number_origin.geographical_area.present?
    end
  end

  validation :ON7, 'The validity period of the quota order number must span the validity period of the quota order number origin.' do |record|
    # this doesn't work
    # validates :validity_date_span, of: :quota_order_number_origin
    if record.quota_order_number_origin.present?
      (
        record.validity_start_date <= record.quota_order_number_origin.validity_start_date
      ) && (
        (record.validity_end_date.blank? && record.quota_order_number_origin.validity_end_date.blank?) ||
        (record.validity_end_date.present? && record.quota_order_number_origin.validity_end_date.present? && (record.validity_end_date >= record.quota_order_number_origin.validity_end_date))
      )
    end
  end

  #
  # NEED_TO_CHECK
  #
  # Need backend rework on that
  #
  # validation :ON8, 'The validity period of the quota order number must span the validity period of the referencing quota definition.' do |record|
  #   # validates :validity_date_span, of: :quota_definition # won't work
  #   if record.quota_definition.present?
  #     (
  #       record.validity_start_date <= record.quota_definition.validity_start_date
  #     ) && (
  #       ( record.validity_end_date.blank? && record.quota_definition.validity_end_date.blank? ) ||
  #       ( record.validity_end_date.present? && record.quota_definition.validity_end_date.present? && (record.validity_end_date >= record.quota_definition.validity_end_date) )
  #     )
  #   end
  # end

  #
  # NEED_TO_CHECK
  #
  # Sequel::DatabaseError (PG::UndefinedColumn: ERROR:  column "effective_start_date" does not exist
  # LINE 1: ...WHERE (("measures"."ordernumber" = '099999') AND ("effective...
  #
  #
  # validation :ON9, 'When a quota order number is used in a measure then the validity period of the quota order number must span the validity period of the measure. This rule is only applicable for measure with start date after 31/12/2007.' do |record|
  #   if record.measure.present? && record.measure.validity_start_date.to_date > Date.new(2007,12,31)
  #     (
  #       record.validity_start_date <= record.measure.validity_start_date
  #     ) && (
  #       ( record.validity_end_date.blank? && record.measure.validity_end_date.blank? ) ||
  #       ( record.validity_end_date.present? && record.measure.validity_end_date.present? && (record.validity_end_date >= record.measure.validity_end_date) )
  #     )
  #   end
  # end

  validation :ON11, 'The quota order number cannot be deleted if it is used in a measure. This rule is only applicable for measure with start date after 31/12/2007.', on: [:destroy] do |record|
    record.measure.blank? || record.measure.validity_start_date.to_date <= Date.new(2007, 12, 31)
  end
end
