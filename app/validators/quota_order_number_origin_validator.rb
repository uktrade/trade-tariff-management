class QuotaOrderNumberOriginValidator < TradeTariffBackend::Validator

  #
  # TODO: We need to make sure and confirm code of this comformance rule
  #
  validation :QONO1, 'Order number can not be blank.', on: [:create, :update] do
    validates :presence, of: :quota_order_number_sid
  end

  validation :QONO2, 'Geographical area can not be blank.', on: [:create, :update] do
    validates :presence, of: :geographical_area_id
  end

  validation :ON5, 'There may be no overlap in time of two quota order number origins with the same quota order number SID and geographical area id.' do |record|
    # TODO: confirm geographical_area_sid or geographical_area_id
    if record.validity_end_date.present?
      record.class.where(
        quota_order_number_sid: record.quota_order_number_sid,
        geographical_area_sid: record.geographical_area_sid
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
        quota_order_number_sid: record.quota_order_number_sid,
        geographical_area_sid: record.geographical_area_sid
      ){
        validity_end_date > record.validity_start_date
      }.empty?
    end
  end
end
