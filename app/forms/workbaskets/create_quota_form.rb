module Workbaskets
  class CreateQuotaForm < ::Workbaskets::BaseForm

    attr_accessor :order_number,
                  :description,
                  :licensed,
                  :license_id
  end
end
