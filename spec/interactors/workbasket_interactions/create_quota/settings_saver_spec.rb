require "rails_helper"

describe WorkbasketInteractions::CreateQuota::SettingsSaver do
  let(:workbasket) { create(:workbasket) }
  let(:geographical_area) { create(:geographical_area) }
  let(:goods_nomenclature) { create(:goods_nomenclature) }
  let(:base_regulation) { create(:base_regulation, replacement_indicator: 0) }
  let(:test_quota_description) { "test quota description" }
  let(:settings_ops) do
    {
      "operation_date" => "01/01/2019",
      "measure_type_id" => "1",
      "quota_ordernumber" => "090909",
      "quota_precision" => "3",
      "quota_description" => test_quota_description,
      "quota_is_licensed" => "false",
      "quota_licence" => "",
      "reduction_indicator" => "",
      "additional_codes" => "",
      "commodity_codes" => goods_nomenclature.goods_nomenclature_item_id,
      "commodity_codes_exclusions" => "",
      "geographical_area_id" => geographical_area.geographical_area_id,
      "excluded_geographical_areas" => [""],
      "start_date" => "2019-01-17",
      "quota_period" => "Annual",
      "regulation_id" => base_regulation.base_regulation_id
    }
  end

  context '#initialize' do
    let(:settings_saver) { WorkbasketInteractions::CreateQuota::SettingsSaver.new(workbasket, 'main', '', settings_ops) }

    it 'sets workbasket name to the quota order number in #setting_params' do
      expect(settings_saver.settings_params['workbasket_name']).to eq test_quota_description
    end
  end
end
