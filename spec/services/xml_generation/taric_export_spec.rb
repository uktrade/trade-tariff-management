require "rails_helper"

RSpec.describe XmlGeneration::TaricExport do
  let(:operation_date) { Date.current }

  let(:xml_export_file) do
    build(
      :xml_export_file,
      workbasket: false,
      date_filters: {
        start_date: operation_date,
      }
    )
  end

  it "generates valid XML" do
    create(
      :measure,
      status: :awaiting_cds_upload_create_new,
      operation_date: operation_date,
    )

    parsed_xml = parsed_xml_for_export(xml_export_file)

    expect(parsed_xml.errors).to be_empty
  end

  it "uses the envelope ID in the XML" do
    create(
      :measure,
      status: :awaiting_cds_upload_create_new,
      operation_date: operation_date,
    )

    parsed_xml = parsed_xml_for_export(xml_export_file)

    expect(xml_export_file.envelope_id).to be_present
    expect(parsed_xml.root.attributes["id"].value).
      to eq xml_export_file.envelope_id.to_s
  end

  context "envelope ID isn't set" do
    it "stops generating the XML" do
      create(
        :measure,
        status: :awaiting_cds_upload_create_new,
        operation_date: operation_date,
      )

      xml_export_file.save
      taric_export = described_class.new(xml_export_file)

      expect(xml_export_file.envelope_id).to be_nil
      expect{ taric_export.run }.
        to raise_error %r{Cannot export Taric XML without an envelope_id}
    end
  end

  private

  def parsed_xml_for_export(xml_export_file)
    xml_export_file.save_with_envelope_id
    taric_export = described_class.new(xml_export_file)
    taric_export.run

    Nokogiri::XML(taric_export.xml_data)
  end
end
