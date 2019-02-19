require "rails_helper"

RSpec.describe "creating a new XML generation export" do
  before { create(:user) }
  let(:workbasket) { create(:workbasket, :create_measures, status: 'awaiting_cds_upload_create_new') }

  it "creates a XML export file record" do
    expect { post xml_generation_exports_path workbasket_id: workbasket.id }
      .to change(XmlExport::File, :count).by(1)
  end

  it "sets the envelope ID for the XML export file record" do
    post xml_generation_exports_path workbasket_id: workbasket.id

    expect(XmlExport::File.last.envelope_id).to be_present
  end
end
