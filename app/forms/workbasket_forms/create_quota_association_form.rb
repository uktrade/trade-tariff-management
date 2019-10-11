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

      if QuotaOrderNumber.find(quota_order_number_id: @parent_order_id).nil?
        @settings_errors[:parent_order_id] = "Parent quota order ID must exist"
      end

      if QuotaOrderNumber.find(quota_order_number_id: @child_order_id).nil?
        @settings_errors[:child_order_id] = "Child quota order ID must exist"
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
  end
end
