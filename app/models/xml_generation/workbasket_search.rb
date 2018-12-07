module XmlGeneration
  class WorkbasketSearch

    attr_accessor :start_date,
                  :end_date

    def initialize(date_filters)
      @start_date = date_filters[:start_date].strftime("%Y-%m-%d")
      @end_date = date_filters[:end_date].strftime("%Y-%m-%d") if date_filters[:end_date].present?
    end

    def result
      data
    end

    def target_workbaskets
      ::Workbaskets::Workbasket.xml_export_collection(
        start_date, end_date
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
