module WorkbasketForms
  class EditRegulationForm
    extend ActiveModel::Naming
    include ActiveModel::Conversion

    attr_accessor :reason_for_changes,
                  :base_regulation_id,
                  :legal_id,
                  :description,
                  :reference_url,
                  :validity_start_date,
                  :validity_end_date,
                  :regulation_group_id,
                  :action


    def initialize(settings)
      @settings = settings
      @reason_for_changes = settings[:reason_for_changes]
      @base_regulation_id = settings[:base_regulation_id]
      @legal_id = settings[:legal_id]
      @description = settings[:description]
      @reference_url = settings[:reference_url]
      @validity_start_date = settings[:validity_start_date]
      @validity_end_date = settings[:validity_end_date]
      @regulation_group_id = settings[:regulation_group_id]
    end

  end
end
