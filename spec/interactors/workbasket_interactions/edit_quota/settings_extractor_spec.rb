require "rails_helper"

describe WorkbasketInteractions::EditQuota::SettingsExtractor do
  let!(:quota_definition) { create(:quota_definition, :actual, workbasket_type_of_quota: 'Annual') }
  let!(:quota_order_number) { create(:quota_order_number, quota_order_number_sid: quota_definition.quota_order_number_sid ) }
  let!(:quota_order_number_origin) { create(:quota_order_number_origin, quota_order_number_sid: quota_order_number.quota_order_number_sid) }

  it 'returns quota period' do
    extractor = WorkbasketInteractions::EditQuota::SettingsExtractor.new(quota_definition.quota_definition_sid)
    quota_periods = extractor.send(:extract_quota_periods_settings)
    expect(quota_periods[:'0'][:type]).to eq 'Annual'
  end
end
