module DbMigrationHelpers
  class XmlExportViewRePopulator
    MODELS_TO_UPDATE = [
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
      MeasureConditionCode,
      MeasureConditionCodeDescription,
      MeasurePartialTemporaryStop,
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
      FootnoteAssociationAdditionalCode,
      FootnoteAssociationGoodsNomenclature,
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
    ].freeze

    class << self
      def new_view_definition(model)
        original = original_view_definition(model)
        splitted_parts = original.split("FROM")
        first_part = splitted_parts[0]
        add_workbasket_attrs(model, first_part) + "\n FROM " + splitted_parts[1..-1].join("FROM")
      end

      def original_view_definition(model)
        run_query(
          get_view_definition_sql(model)
        )[:definition][:definition]
      end

      def get_view_definition_sql(model)
        <<-eos
          SELECT definition FROM pg_views
          WHERE viewname = '#{viewname(model)}';
        eos
      end

      def run_query(sql)
        db_connection.fetch(sql)
      end

      def add_workbasket_attrs(model, first_part)
        new_columns_definition = ", "

        new_columns_definition += %i[
          status
          workbasket_id
          workbasket_sequence_number
        ].map do |field_name|
          "#{viewname(model)}1.#{field_name}"
        end.join(",\n ")

        first_part + new_columns_definition
      end

      def viewname(model)
        model.table_name
             .to_s
      end

      def db_connection
        @db_connection = ::Sequel::Model.db
      end
    end
  end
end
