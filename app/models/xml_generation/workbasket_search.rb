module XmlGeneration
  class WorkbasketSearch
    attr_accessor :workbasket_id

    def initialize(workbasket_id)
      @workbasket_id = workbasket_id
    end

    def result
      data
    end

    def target_workbaskets
      ::Workbaskets::Workbasket.where('id = ?', workbasket_id)
        .in_status(%w[awaiting_cds_upload_create_new awaiting_cds_upload_edit awaiting_cross_check]).all
    end

    def data
      target_workbaskets.map do |workbasket|
        workbasket.settings
                  .collection
      end.flatten
    end
  end
end
