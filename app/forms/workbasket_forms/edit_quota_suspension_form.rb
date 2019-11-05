module WorkbasketForms
  class EditQuotaSuspensionForm
    extend ActiveModel::Naming
    include ActiveModel::Conversion

    attr_accessor :workbasket,
                  :settings_errors,
                  :workbasket_title,
                  :quota_order_number_id

    def initialize(settings = {}, current_user = nil)
      @workbasket_title =  settings[:workbasket_title]
      @quota_order_number_id = settings[:quota_order_number_id]
      @quota_definition_sid = settings[:quota_definition_sid]
      @quota_suspension_period_sid = settings[:quota_suspension_period_sid]
      @current_user = current_user
      @settings_errors = {}
    end

    def save
      if @workbasket_title.empty?
        @settings_errors[:workbasket_title] = "Workbasket title must be entered"
      end

      if quota_order_number.nil?
        @settings_errors[:quota_order_number_id] = "Quota order number ID must exist"
      end

      if quota_order_number && !quota_order_number.validity_end_date.nil?
        @settings_errors[:quota_order_number_id] = "Quota order number must not have an end date"
      end

      if quota_order_number_id.first(3) == '094'
        @settings_errors[:quota_order_number_id] = "Quota order number cannot start 094"
      end

      if @settings_errors.empty?
        @workbasket = Workbaskets::Workbasket.new(
          title: @workbasket_title,
          status: :new_in_progress,
          type: :edit_quota_suspension,
          user: @current_user
        ).save

        @workbasket.settings.update(quota_order_number_id: quota_order_number_id)
      end

      @settings_errors.empty?
    end

    def quota_order_number
      QuotaOrderNumber.where(quota_order_number_id: quota_order_number_id).order(Sequel.desc(:added_at)).first
    end
  end
end
