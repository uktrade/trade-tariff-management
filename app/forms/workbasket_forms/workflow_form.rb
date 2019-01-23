module WorkbasketForms
  class WorkflowForm
    extend ActiveModel::Naming
    include ActiveModel::Conversion

    attr_accessor :mode,
                  :submit_for_approval,
                  :reject_reasons,
                  :export_date
  end
end
