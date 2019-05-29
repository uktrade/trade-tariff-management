module Workbaskets
  class EditGeographicalAreaSettings < Sequel::Model(:edit_geographical_areas_workbasket_settings)
    include ::WorkbasketHelpers::SettingsBase

    def collection_models
      %w(
        GeographicalArea
        GeographicalAreaDescriptionPeriod
        GeographicalAreaDescription
        GeographicalAreaMembership
      )
    end

    def settings
      res = JSON.parse(main_step_settings_jsonb)

      if res.blank?
        res = {
          description: original_geographical_area.description,
          validity_start_date: original_geographical_area.validity_start_date.strftime("%d/%m/%Y")
        }

        if original_geographical_area.validity_end_date.present?
          res[:validity_end_date] = original_geographical_area.validity_end_date.strftime("%d/%m/%Y")
        end

        if original_geographical_area.parent_geographical_area_group_sid.present?
          res[:parent_geographical_area_group_id] = original_geographical_area.parent_geographical_area
                                                                              .try(:description)
        end
      end

      res[:geographical_code] = original_geographical_area.geographical_code
      res[:geographical_area_id] = original_geographical_area.geographical_area_id

      res
    end

    def prepare_collection(list, data_field_name)
      list.map do |item|
        item.public_send(data_field_name)
      end.reject(&:blank?).uniq
         .join(', ')
    end

    def measure_sids_jsonb
      '{}'
    end

    def original_geographical_area
      @original_geographical_area ||= GeographicalArea.where(
        geographical_area_sid: original_geographical_area_sid,
        geographical_area_id: original_geographical_area_id
      ).first
    end

    def updated_geographical_area
      geographical_areas_list = collection_by_type(GeographicalArea)

      if geographical_areas_list.count > 1
        geographical_areas_list.detect do |item|
          item.geographical_area_id != original_geographical_area.geographical_area_id
        end
      else
        geographical_areas_list.first
      end || original_geographical_area
    end

    def validity_start_date
      settings[:validity_start_date]
    end

    def validity_end_date
      settings[:validity_end_date]
    end

    def description
      settings[:description]
    end

    def geographical_area_id
      settings[:original_geographical_area_id]
    end

    def geographical_code
      original_geographical_area.geographical_code
    end
  end
end
