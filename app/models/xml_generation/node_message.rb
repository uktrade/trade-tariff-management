module XmlGeneration
  class NodeMessage

    MEASURE_RELATED = [
      MeasureTypeSeries,
      MeasureTypeSeriesDescription,
      MeasureType,
      MeasureTypeDescription,
      MeasureAction,
      MeasureActionDescription,
      Measure,
      MeasureComponent,
      MeasureConditionCode,
      MeasureConditionCodeDescription,
      MeasureCondition,
      MeasureConditionComponent,
      MeasurePartialTemporaryStop,
      MeasureExcludedGeographicalArea
    ]

    ADDITIONAL_CODES = [
      AdditionalCodeType,
      AdditionalCodeTypeDescription,
      AdditionalCodeTypeMeasureType,
      AdditionalCode,
      AdditionalCodeDescription,
      AdditionalCodeDescriptionPeriod
    ]

    DUTY_EXPRESSIONS = [
      DutyExpression,
      DutyExpressionDescription
    ]

    CERTIFICATES = [
      CertificateType,
      CertificateTypeDescription,
      Certificate,
      CertificateDescription,
      CertificateDescriptionPeriod
    ]

    REGULATIONS = [
      RegulationRoleType,
      RegulationRoleTypeDescription,
      RegulationReplacement,
      RegulationGroup,
      RegulationGroupDescription,
      BaseRegulation,
      ModificationRegulation,
      CompleteAbrogationRegulation,
      ExplicitAbrogationRegulation,
      FullTemporaryStopRegulation,
      FtsRegulationAction,
      ProrogationRegulation,
      ProrogationRegulationAction
    ]

    FOOTNOTES = [
      FootnoteType,
      FootnoteTypeDescription,
      Footnote,
      FootnoteDescription,
      FootnoteDescriptionPeriod,
      FootnoteAssociationAdditionalCode,
      FootnoteAssociationGoodsNomenclature,
      FootnoteAssociationMeasure,
      FootnoteAssociationMeursingHeading,
      FootnoteAssociationErn
    ]

    EXPORT_REFUND_NOMENCLATURES = [
      ExportRefundNomenclature,
      ExportRefundNomenclatureDescription,
      ExportRefundNomenclatureDescriptionPeriod,
      ExportRefundNomenclatureIndent
    ]

    SYSTEM = [
      Language,
      LanguageDescription,
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
        if it_is?(record, MEASURE_RELATED)
          :measures
        elsif it_is?(record, ADDITIONAL_CODES)
          :additional_codes
        elsif it_is?(record, DUTY_EXPRESSIONS)
          :duty_expressions
        elsif it_is?(record, REGULATIONS)
          :regulations
        elsif it_is?(record, FOOTNOTES)
          :footnotes
        elsif it_is?(record, EXPORT_REFUND_NOMENCLATURES)
          :export_refund_nomenclatures
        elsif it_is?(record, CERTIFICATES)
          :certificates
        elsif it_is?(record, SYSTEM)
          :system
        else
          # TODO: add more types
        end
      end

      def it_is?(record, list)
        list.map(&:to_s)
            .include?(record.class.name)
      end
  end
end
