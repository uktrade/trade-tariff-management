module XmlGeneration
  class Search

    SEQUENCE_OF_DATA_FETCH = [
      MeasureType,
      MeasureTypeDescription,
      Measure,
      DutyExpression,
      DutyExpressionDescription,
      MeasureComponent,
      MeasureConditionCode,
      MeasureConditionCodeDescription,
      MeasureCondition,
      MeasureConditionComponent,
      TransmissionComment
    ]

    attr_accessor :date, :mode

    def initialize(date, mode)
      @mode = mode
      @date = date.strftime("%Y-%m-%d")
    end

    def result
      ::XmlGeneration::NodeEnvelope.new(data)
    end

    private

      def data
        SEQUENCE_OF_DATA_FETCH.map do |record_class|
          if mode == "samples"
            generate_samples(record_class)
          else
            fetch_relevant_data(record_class)
          end
        end.flatten
      end

      def generate_samples(record_class)
        record = record_class.order(
          Sequel.lit('RANDOM()')
        ).limit(1)
         .first

        [record]
      end

      def fetch_relevant_data(record_class)
        record_class.where("operation_date = ?", date).all
      end
  end
end
