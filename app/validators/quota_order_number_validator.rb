class QuotaOrderNumberValidator < TradeTariffBackend::Validator

  #
  # TODO: We need to make sure and confirm code of this comformance rule
  #
  validation :QON1, 'Order number can not be blank.', on: [:create, :update] do
    validates :presence, of: :quota_order_number_id
  end

  # validation :QON2, 'Order number must be unique.', on: [:create, :update] do
  #   validates :uniqueness, of: [:quota_order_number_id]
  # end

  validation :QON3, "Order number should start with '09' and can contain digits only. Could be 6 length only.", on: [:create, :update] do |record|
    order_number_id = record.quota_order_number_id

    order_number_id.blank? || (
      order_number_id.present? &&
      (/^09(\d){4}\z/.match?(order_number_id))
    )
  end

  validation :ON1, 'Quota order number id + start date must be unique' do
    validates :uniqueness, of: [:quota_order_number_id, :validity_start_date]
  end

  validation :ON2, 'There may be no overlap in time of two quota order numbers with the same quota order number id.' do |record|
    if record.validity_end_date.present?
      record.class.where(
        quota_order_number_id: record.quota_order_number_id
      ){
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
      ){
        (validity_end_date > record.validity_start_date)
      }.empty?
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

  validation :ON6, 'The validity period of the geographical area must span the validity period of the quota order number origin.' do

  end
end
