require "rails_helper"

RSpec.describe "creating a new XML generation export" do
  before { create(:user) }

  it "creates a XML export file record" do
    expect { post xml_generation_exports_path }
      .to change(XmlExport::File, :count).by(1)
  end

  it "sets the envelope ID for the XML export file record" do
    post xml_generation_exports_path

    expect(XmlExport::File.last.envelope_id).to be_present
  end
end
