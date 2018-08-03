module WorkbasketValueObjects
  module Shared
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

          record.public_send("#{p_key}=", sid)
        end
      end
    end
  end
end
