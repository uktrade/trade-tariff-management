module CreateMeasures
  module ValidationHelpers
    class PrimaryKeyGenerator

      PRIMARY_KEYS = {
        "QuotaDefinition" => :quota_definition_sid,
        "Footnote" => :footnote_id,
        "FootnoteDescriptionPeriod" => :footnote_description_period_sid,
        "QuotaOrderNumber" => :quota_order_number_sid,
        "QuotaOrderNumberOrigin" => :quota_order_number_origin_sid,
        "MeasureCondition" => :measure_condition_sid
      }

      attr_accessor :record,
                    :extra_increment_value

      def initialize(record, extra_increment_value=nil)
        @record = record
      end

      def assign!
        p_key = PRIMARY_KEYS[record.class.name]

        if p_key.present?
          sid = record.class
                      .pluck(p_key)
                      .map(&:to_i)
                      .max + 1

          sid += extra_increment_value if extra_increment_value.present?

          record.public_send("#{p_key}=", sid)
        end
      end
    end
  end
end
