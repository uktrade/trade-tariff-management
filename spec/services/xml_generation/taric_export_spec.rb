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
    create(:measure, :for_upload_today)

    parsed_xml = parsed_xml_for_export(xml_export_file)

    expect(parsed_xml.errors).to be_empty
  end

  it "uses the envelope ID in the XML" do
    create(:measure, :for_upload_today)

    parsed_xml = parsed_xml_for_export(xml_export_file)

    expect(xml_export_file.envelope_id).to be_present
    expect(parsed_xml.root.attributes["id"].value).
      to eq xml_export_file.envelope_id.to_s
  end

  describe "attachments" do
    it "attaches the XML data in multiple formats" do
      create(:measure, :for_upload_today)

      perform_taric_export(xml_export_file)

      # It's unclear if all these formats are required
      expect(xml_export_file.xml).to be_present
      expect(xml_export_file.base_64).to be_present
      expect(xml_export_file.zip).to be_present
      expect(xml_export_file.meta).to be_present
    end

    describe "Base64 version" do
      it "matches the XML once decoded" do
        create(:measure, :for_upload_today)

        perform_taric_export(xml_export_file)
        decoded_xml = Base64.decode64(xml_export_file.base_64.read)

        expect(decoded_xml).to eq xml_export_file.xml.read
      end
    end

    describe "zip version" do
      it "includes the XML file" do
        create(:measure, :for_upload_today)

        perform_taric_export(xml_export_file)

        Zip::File.open_buffer(xml_export_file.zip.to_io) do |zip|
          expect(zip.entries.count).to eq 1

          entry = zip.entries.first

          # The current implementation may be wrong - the filename is B64,
          # but the content is the standard XML, not the Base64 XML.
          expect(entry.name).to end_with "-EUFileSequence.B64"
          expect(entry.get_input_stream.read).to eq xml_export_file.xml.read
        end
      end
    end
  end

  context "envelope ID isn't set" do
    it "stops generating the XML" do
      create(:measure, :for_upload_today)

      xml_export_file.save
      taric_export = described_class.new(xml_export_file)

      expect(xml_export_file.envelope_id).to be_nil
      expect{ taric_export.run }.
        to raise_error %r{Cannot export Taric XML without an envelope_id}
    end
  end

  describe "transaction grouping" do
    it "groups similar entities into transactions" do
      measure, measure_2 = create_list(:measure, 2, :for_upload_today)
      footnote = create(:footnote, :for_upload_today)

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
