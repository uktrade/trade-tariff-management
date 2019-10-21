module WorkbasketForms
  class CreateQuotaAssociationForm
    extend ActiveModel::Naming
    include ActiveModel::Conversion

    attr_accessor :workbasket,
                  :settings_errors,
                  :workbasket_title,
                  :parent_order_id,
                  :child_order_id

    def initialize(settings = {}, current_user = nil)
      @workbasket_title =  settings[:workbasket_title]
      @parent_order_id = settings[:parent_order_id]
      @child_order_id = settings[:child_order_id]
      @current_user = current_user
      @settings_errors = {}
    end

    def save
      if @workbasket_title.empty?
        @settings_errors[:workbasket_title] = "Workbasket title must be entered"
      end

      if is_license_quota?(@parent_order_id)
        @settings_errors[:parent_order_id] = "Quota order ID must not begin with 094"
      end

      if is_license_quota?(@child_order_id)
        @settings_errors[:child_order_id] = "Quota order ID must not begin with 094"
      end

      if @settings_errors.empty?
        parent_order = QuotaOrderNumber.find(quota_order_number_id: @parent_order_id)
        if parent_order.nil?
          @settings_errors[:parent_order_id] = "Parent quota order ID must exist"
        elsif parent_order.validity_end_date.present?
          @settings_errors[:parent_order_id] = "Parent quota order must not have an end date"
        end

        child_order = QuotaOrderNumber.find(quota_order_number_id: @child_order_id)
        if child_order.nil?
          @settings_errors[:child_order_id] = "Child quota order ID must exist"
        elsif child_order.validity_end_date.present?
          @settings_errors[:child_order_id] = "Child quota order must not have an end date"
        end
      end

      if @settings_errors.empty?
        @workbasket = Workbaskets::Workbasket.new(
          title: @workbasket_title,
          status: :new_in_progress,
          type: :create_quota_association,
          user: @current_user
        ).save

        @workbasket.settings.update(
                              parent_quota_order_id: @parent_order_id,
                              child_quota_order_id: @child_order_id
        )
      end

      @settings_errors.empty?
    end

    private def is_license_quota?(quota_order_id)
      quota_order_id.start_with? '094'
    end
  end
end
