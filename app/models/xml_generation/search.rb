module XmlGeneration
  class Search

    SEQUENCE_OF_DATA_FETCH = [
      GeographicalArea,
      GeographicalAreaDescription,
      GeographicalAreaDescriptionPeriod,
      GeographicalAreaMembership,

      MonetaryUnit,
      MonetaryUnitDescription,
      MonetaryExchangePeriod,
      MonetaryExchangeRate,

      MeasurementUnitQualifier,
      MeasurementUnitQualifierDescription,
      MeasurementUnit,
      MeasurementUnitDescription,
      Measurement,

      QuotaOrderNumber,
      QuotaOrderNumberOrigin,
      QuotaOrderNumberOriginExclusion,
      QuotaDefinition,
      QuotaAssociation,
      QuotaReopeningEvent,
      QuotaUnsuspensionEvent,
      QuotaUnblockingEvent,
      QuotaBalanceEvent,
      QuotaCriticalEvent,
      QuotaExhaustionEvent,
      QuotaSuspensionPeriod,
      QuotaBlockingPeriod,

      GoodsNomenclatureGroup,
      GoodsNomenclatureGroupDescription,
      GoodsNomenclature,
      GoodsNomenclatureDescription,
      GoodsNomenclatureDescriptionPeriod,
      GoodsNomenclatureIndent,
      GoodsNomenclatureOrigin,
      GoodsNomenclatureSuccessor,
      NomenclatureGroupMembership,

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
      MeasureExcludedGeographicalArea,

      AdditionalCodeType,
      AdditionalCodeTypeDescription,
      AdditionalCodeTypeMeasureType,
      AdditionalCode,
      AdditionalCodeDescription,
      AdditionalCodeDescriptionPeriod,

      MeursingAdditionalCode,
      MeursingTablePlan,
      MeursingTableCellComponent,
      MeursingHeading,
      MeursingHeadingText,
      MeursingSubheading,

      DutyExpression,
      DutyExpressionDescription,

      CertificateType,
      CertificateTypeDescription,
      Certificate,
      CertificateDescription,
      CertificateDescriptionPeriod,

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
      ProrogationRegulationAction,

      FootnoteType,
      FootnoteTypeDescription,
      Footnote,
      FootnoteDescription,
      FootnoteDescriptionPeriod,
      FootnoteAssociationAdditionalCode,
      FootnoteAssociationGoodsNomenclature,
      FootnoteAssociationMeasure,
      FootnoteAssociationMeursingHeading,
      FootnoteAssociationErn,

      ExportRefundNomenclature,
      ExportRefundNomenclatureDescription,
      ExportRefundNomenclatureDescriptionPeriod,
      ExportRefundNomenclatureIndent,

      Language,
      LanguageDescription,
      TransmissionComment,
      PublicationSigle
    ]

    attr_accessor :date

    def initialize(date)
      @date = date.strftime("%Y-%m-%d")
    end

    def result
      ::XmlGeneration::NodeEnvelope.new(data)
    end

    private

      def data
        SEQUENCE_OF_DATA_FETCH.map do |record_class|
          record_class.where("operation_date = ?", date)
                      .all
        end.flatten
      end
  end
end
