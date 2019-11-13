module WorkbasketValueObjects
  module Shared
    class PrimaryKeyGenerator
      PRIMARY_KEYS = {
        "AdditionalCode" => :additional_code_sid,
        "AdditionalCodeDescriptionPeriod" => :additional_code_description_period_sid,
        "MeursingAdditionalCode" => :meursing_additional_code_sid,
        "QuotaDefinition" => :quota_definition_sid,
        "Footnote" => :footnote_id,
        "FootnoteDescriptionPeriod" => :footnote_description_period_sid,
        "QuotaOrderNumber" => :quota_order_number_sid,
        "QuotaOrderNumberOrigin" => :quota_order_number_origin_sid,
        "MeasureCondition" => :measure_condition_sid,
        "QuotaSuspensionPeriod" => :quota_suspension_period_sid,
        "GeographicalArea" => :geographical_area_sid,
        "GeographicalAreaDescriptionPeriod" => :geographical_area_description_period_sid,
        "CertificateDescriptionPeriod" => :certificate_description_period_sid,
        "GoodsNomenclature" => :goods_nomenclature_sid,
        "GoodsNomenclatureIndent" => :goods_nomenclature_indent_sid,
        "GoodsNomenclatureDescriptionPeriod" => :goods_nomenclature_description_period_sid
      }.freeze

      attr_accessor :record,
                    :extra_increment_value

      def initialize(record, extra_increment_value = nil)
        @record = record
        @extra_increment_value = extra_increment_value
      end

      def assign!
        p_key = PRIMARY_KEYS[record.class.name]

        if p_key.present?
          if record.class.name == "Footnote"
            sid = record.class
                        .pluck(p_key)
                        .map(&:to_i)
                        .max
                        .to_i

            sid = (sid + 1).to_s.ljust(5, '0')
          else
            sid = record.class.max(p_key).to_i + 1
          end
          sid += extra_increment_value if extra_increment_value.present?

          if sid.is_a?(String)
            sid = (sid.to_i + rand(100).to_i).to_s
          else
            sid += rand(1000)
          end

          record.public_send("#{p_key}=", sid)
        end
      end
    end
  end
end
