module XmlGeneration
  class NodeMessage
    GEOGRAPHICAL_AREAS = [
      GeographicalArea,
      GeographicalAreaDescription,
      GeographicalAreaDescriptionPeriod,
      GeographicalAreaMembership
    ].freeze

    MONETARY = [
      MonetaryUnit,
      MonetaryUnitDescription,
      MonetaryExchangePeriod,
      MonetaryExchangeRate
    ].freeze

    MEASUREMENTS = [
      MeasurementUnitQualifier,
      MeasurementUnitQualifierDescription,
      MeasurementUnit,
      MeasurementUnitDescription,
      Measurement
    ].freeze

    QUOTA = [
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
      QuotaBlockingPeriod
    ].freeze

    GOODS_NOMENCLATURES = [
      GoodsNomenclatureGroup,
      GoodsNomenclatureGroupDescription,
      GoodsNomenclature,
      GoodsNomenclatureDescription,
      GoodsNomenclatureDescriptionPeriod,
      GoodsNomenclatureIndent,
      GoodsNomenclatureOrigin,
      GoodsNomenclatureSuccessor,
      NomenclatureGroupMembership
    ].freeze

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
    ].freeze

    ADDITIONAL_CODES = [
      AdditionalCodeType,
      AdditionalCodeTypeDescription,
      AdditionalCodeTypeMeasureType,
      AdditionalCode,
      AdditionalCodeDescription,
      AdditionalCodeDescriptionPeriod
    ].freeze

    MEURSING = [
      MeursingAdditionalCode,
      MeursingTablePlan,
      MeursingTableCellComponent,
      MeursingHeading,
      MeursingHeadingText,
      MeursingSubheading
    ].freeze

    DUTY_EXPRESSIONS = [
      DutyExpression,
      DutyExpressionDescription
    ].freeze

    CERTIFICATES = [
      CertificateType,
      CertificateTypeDescription,
      Certificate,
      CertificateDescription,
      CertificateDescriptionPeriod
    ].freeze

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
    ].freeze

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
    ].freeze

    EXPORT_REFUND_NOMENCLATURES = [
      ExportRefundNomenclature,
      ExportRefundNomenclatureDescription,
      ExportRefundNomenclatureDescriptionPeriod,
      ExportRefundNomenclatureIndent
    ].freeze

    SYSTEM = [
      Language,
      LanguageDescription,
      TransmissionComment,
      PublicationSigle
    ].freeze

    attr_accessor :record

    def initialize(record)
      @record = record
    end

    def record_code
      record.record_code
    end

    def subrecord_code
      record.subrecord_code
    end

    def update_type
      if record.operation == :create
        "3"
      elsif record_is_a_pending_deletion?
        "2"
      elsif record.operation == :update
        "1"
      elsif record.operation == :destroy
        "2"
      end
    end

    def partial_path
      "#{base_partial_path}/#{partial_folder_name}/#{record_class}.builder"
    end

    private

    def record_is_a_pending_deletion?
      workbasket = Workbaskets::Workbasket.find(id: record.workbasket_id)
      return true if workbasket.settings.class == Workbaskets::DeleteQuotaSuspensionSettings

      [FootnoteAssociationMeasure, QuotaAssociation].include?(record.class) && record.operation == :update
    end

    def record_class
      record.class
        .name
        .titleize
        .split
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
      elsif it_is?(record, GEOGRAPHICAL_AREAS)
        :geographical_areas
      elsif it_is?(record, GOODS_NOMENCLATURES)
        :goods_nomenclatures
      elsif it_is?(record, MEASUREMENTS)
        :measurements
      elsif it_is?(record, MEURSING)
        :meursing
      elsif it_is?(record, MONETARY)
        :monetary
      elsif it_is?(record, QUOTA)
        :quota
      elsif it_is?(record, SYSTEM)
        :system
      end
    end

    def it_is?(record, list)
      list.map(&:to_s)
        .include?(record.class.name)
    end
  end
end
