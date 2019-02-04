module XmlGeneration
  class WorkbasketSearch

    def initialize(workbasket_ids)
      @workbasket_ids = workbasket_ids
      # @start_date = date_filters[:start_date].strftime("%Y-%m-%d")
      # @end_date = date_filters[:end_date].strftime("%Y-%m-%d") if date_filters[:end_date].present?
    end

    def result
      data
    end

    def target_workbaskets
      # ::Workbaskets::Workbasket.xml_export_collection(
      #   @start_date, @end_date
      # )
      ::Workbaskets::Workbasket.xml_export(
        workbasket_ids: @workbasket_ids
      )
    end

    def data
      target_workbaskets.map do |workbasket|
        workbasket.settings
                  .collection
      end.flatten
    end
  end
end
