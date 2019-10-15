module WorkbasketForms
  class CreateQuotaSuspensionForm
    extend ActiveModel::Naming
    include ActiveModel::Conversion

    attr_accessor :workbasket,
                  :settings_errors,
                  :workbasket_title,
                  :quota_order_number_id

    def initialize(settings = {}, current_user = nil)
      @workbasket_title =  settings[:workbasket_title]
      @current_user = current_user
      @settings_errors = {}
    end

    def save
    end
  end
end
