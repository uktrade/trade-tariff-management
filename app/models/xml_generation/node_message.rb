module XmlGeneration
  class NodeMessage

    MEASURE_RELATED = [
      MeasureType,
      MeasureTypeDescription,
      Measure,
      DutyExpression,
      DutyExpressionDescription,
      MeasureComponent,
      MeasureConditionCode,
      MeasureConditionCodeDescription,
      MeasureCondition,
      MeasureConditionComponent
    ]

    SYSTEM = [
      TransmissionComment
    ]

    attr_accessor :record

    def initialize(record)
      @record = record
    end

    def id
      rand(2..999)
    end

    def partial_path
      "#{base_partial_path}/#{partial_folder_name}/#{record_class}.builder"
    end

    def record_code
      # TODO
      rand(100..999)
    end

    def subrecord_code
      # TODO
      rand(10..99)
    end

    def record_sequence_number
      # TODO
      rand(100..999)
    end

    def update_type
      case record.operation
      when :create
        "3"
      when :update
        "1"
      when :destroy
        "2"
      else
        "3" # create (by default)
      end
    end

    private

      def record_class
        record.class
              .name
              .titleize
              .split()
              .map(&:downcase)
              .join("_")
      end

      def base_partial_path
        ::XmlGeneration::TaricExport.base_partial_path
      end

      def partial_folder_name
        if MEASURE_RELATED.include?(record.class)
          :measures
        elsif SYSTEM.include?(record.class)
          :system
        else
          # TODO: add more types
        end
      end
  end
end
