module XmlGeneration
  class WorkbasketSearch
    attr_accessor :workbasket_id

    def initialize(date_filters, workbasket_id)
      @workbasket_id = workbasket_id
    end

    def result
      data
    end

    def target_workbaskets
      ::Workbaskets::Workbasket.where('id = ?', workbasket_id).all
    end

    def data
      target_workbaskets.map do |workbasket|
        workbasket.settings
                  .collection
      end.flatten
    end
  end
end
