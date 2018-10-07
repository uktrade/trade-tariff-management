module WorkbasketForms
  class CrossCheckForm

    extend ActiveModel::Naming
    include ActiveModel::Conversion

    attr_accessor :mode,
                  :submit_for_approval,
                  :reject_reasons
  end
end
