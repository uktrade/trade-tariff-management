require "rails_helper"

RSpec.describe XmlGeneration::TaricExport do
  let(:operation_date) { Date.current }
  let!(:workbasket) { create(:workbasket, status: :awaiting_cds_upload_create_new) }
  let(:xml_export_file) do
    build(
      :xml_export_file,
      workbasket: true,
      workbasket_selected: workbasket.id
    )
  end

  it "generates valid XML" do
    create(:measure, :for_upload_today, workbasket_id: workbasket.id)
    parsed_xml = parsed_xml_for_export(xml_export_file)

    expect(parsed_xml.errors).to be_empty
  end

  it "uses the envelope ID in the XML" do
    create(:measure, :for_upload_today, workbasket_id: workbasket.id)

    parsed_xml = parsed_xml_for_export(xml_export_file)
    expect(xml_export_file.envelope_id).to be_present
    expect(parsed_xml.root.attributes["id"].value).
      to eq xml_export_file.envelope_id.to_s
  end

  describe "attachments" do
    it "attaches the XML data in multiple formats" do
      create(:measure, :for_upload_today, workbasket_id: workbasket.id)

      perform_taric_export(xml_export_file)

      # It's unclear if all these formats are required
      expect(xml_export_file.xml).to be_present
      expect(xml_export_file.meta).to be_present
    end
  end

  context "envelope ID isn't set" do
    it "stops generating the XML" do
      create(:measure, :for_upload_today, workbasket_id: workbasket.id)

      xml_export_file.save
      taric_export = described_class.new(xml_export_file)

      expect(xml_export_file.envelope_id).to be_nil
      expect { taric_export.run }.
        to raise_error %r{Cannot export Taric XML without an envelope_id}
    end
  end

  describe "transaction grouping" do
    it "groups similar entities into transactions" do
      measure, measure_2 = create_list(:measure, 2, :for_upload_today, workbasket_id: workbasket.id)
      footnote = create(:footnote, :for_upload_today, workbasket_id: workbasket.id)

      parsed_xml = parsed_xml_for_export(xml_export_file)
      transactions = extract_transactions(parsed_xml)

      expect(transactions.count).to eq 2

      expect(transactions[0]).to have_record_codes [footnote.record_code]

      expect(transactions[1]).
        to have_record_codes [measure.record_code, measure_2.record_code]
    end
  end

  private

  def parsed_xml_for_export(xml_export_file)
    taric_export = perform_taric_export(xml_export_file)
    Nokogiri::XML(taric_export.xml_data).remove_namespaces!
  end

  def perform_taric_export(xml_export_file)
    xml_export_file.save_with_envelope_id
    taric_export = described_class.new(xml_export_file)
    taric_export.run
    taric_export
  end

  def extract_transactions(xml)
    xml.xpath("//transaction")
  end

  RSpec::Matchers.define :have_record_codes do |expected|
    match do |_actual|
      @actual = @actual.xpath(".//record.code").map(&:text)
      expect(@actual).to eq expected
    end
  end
end
