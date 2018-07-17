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

      def initialize(record)
        p_key = PRIMARY_KEYS[record.class.name]

        if p_key.present?
          sid = if record.is_a?(Footnote)
            #
            # TODO:
            #
            # Footnote, FootnoteDescription, FootnoteDescriptionPeriod
            # in current db having:
            #
            #   footnote_id character varying(5)
            #
            # but in FootnoteAssociationMeasure
            #
            #   footnote_id character varying(3)
            #
            # This is wrong and break saving of FootnoteAssociationMeasure
            # if footnote_id is longer than 3 symbols
            #
            # Also, then we are trying to fix it via:
            #
            #     alter_table :footnote_association_measures_oplog do
            #       set_column_type :footnote_id, String, size: 5
            #     end
            #
            # System raises error:
            #
            # PG::FeatureNotSupported: ERROR:  cannot alter type of a column used by a view or rule
            # DETAIL:  rule _RETURN on view footnote_association_measures depends on column "footnote_id"
            #
            # So, we fix it later!

            f_max_id = Footnote.where { Sequel.ilike(:footnote_id, "F%") }
                               .order(Sequel.desc(:footnote_id))
                               .first
                               .try(:footnote_id)

            f_max_id.present? ? "F#{f_max_id.gsub("F", "").to_i + 1}" : "F01"
          else
            record.class.max(p_key).to_i + 1
          end

          record.public_send("#{p_key}=", sid)
        end
      end
    end
  end
end
