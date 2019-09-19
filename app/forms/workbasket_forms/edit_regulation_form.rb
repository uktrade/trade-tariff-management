module WorkbasketForms
  class EditRegulationForm
    extend ActiveModel::Naming
    include ActiveModel::Conversion

    attr_accessor :workbasket_name,
                  :reason_for_changes,
                  :base_regulation_id,
                  :legal_id,
                  :description,
                  :reference_url,
                  :start_date,
                  :end_date,
                  :regulation_group_id,
                  :action


    def initialize(settings)
      @settings = settings
    end

  end
end
