module WorkbasketForms
  class CreateQuotaForm < ::WorkbasketForms::BaseForm
    attr_accessor :order_number,
                  :description,
                  :quota_is_licensed,
                  :quota_licence
  end
end
