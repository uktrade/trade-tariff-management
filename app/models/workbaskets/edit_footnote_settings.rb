module Workbaskets
  class EditFootnoteSettings < Sequel::Model(:edit_footnotes_workbasket_settings)

    include ::WorkbasketHelpers::SettingsBase

    def collection_models
      %w(
        Footnote
        FootnoteDescriptionPeriod
        FootnoteDescription
        FootnoteAssociationMeasure
        FootnoteAssociationGoodsNomenclature
      )
    end

    def settings
      res = JSON.parse(main_step_settings_jsonb)

      if res.blank?
        res = {
          description: original_footnote.description,
          validity_start_date: original_footnote.validity_start_date.strftime("%d/%m/%Y")
        }

        if original_footnote.validity_end_date.present?
          res[:validity_end_date] = original_footnote.validity_end_date.strftime("%d/%m/%Y")
        end

        commodity_list = original_footnote.goods_nomenclatures
        if commodity_list.present?
          res[:commodity_codes] = prepare_collection(
            commodity_list,
            :goods_nomenclature_item_id
          )
        end

        measures_list = original_footnote.measures
        if measures_list.present?
          res[:measure_sids] = prepare_collection(
            measures_list,
            :measure_sid
          )
        end
      end

      res
    end

    def prepare_collection(list, data_field_name)
      list.map do |item|
        item.public_send(data_field_name)
      end.reject do |i|
        i.blank?
      end.uniq
         .join(', ')
    end

    def measure_sids_jsonb
      '{}'
    end

    def original_footnote
      @original_footnote ||= Footnote.where(
        footnote_id: original_footnote_id,
        footnote_type_id: original_footnote_type_id
      ).first
    end

    def updated_footnote
      footnotes_list = collection_by_type(Footnote)

      if footnotes_list.count > 1
        footnotes_list.detect do |item|
          item.footnote_id != original_footnote.footnote_id
        end
      else
        footnotes_list.first
      end || original_footnote
    end
  end
end
