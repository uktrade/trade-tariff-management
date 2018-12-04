require "rails_helper"

RSpec.describe XmlExport::File do
  include EnvironmentHelper

  describe "#save_with_envelope_id" do
    subject(:xml_export_file) { build(:xml_export_file) }

    it "persists the record" do
      expect { xml_export_file.save_with_envelope_id }.
        to change { xml_export_file.exists? }.from(false).to(true)
    end

    it "generates the envelope ID" do
      expect(xml_export_file.envelope_id).to be_nil

      xml_export_file.save_with_envelope_id

      expect(xml_export_file.envelope_id).to be_a_valid_envelope_id
    end

    it "allows an initial envelope ID offset to be defined" do
      envelope_id_offset_for_current_year =
        "XML_ENVELOPE_ID_OFFSET_YEAR_#{Date.current.year}"

      with_environment(envelope_id_offset_for_current_year => "4224") do
        xml_export_file_1 = xml_export_file
        xml_export_file_2 = build(:xml_export_file)

        xml_export_file_1.save_with_envelope_id
        xml_export_file_2.save_with_envelope_id

        expect(xml_export_file_1.envelope_id).to end_with "4225"
        expect(xml_export_file_2.envelope_id).to end_with "4226"
      end
    end

    it "requires unique envelope IDs and uses a transaction", :truncation do
      xml_export_file_1 = xml_export_file
      xml_export_file_1.save_with_envelope_id
      xml_export_file_2 = build(:xml_export_file)

      insert_duplicate = Proc.new do
        xml_export_file_2.save_with_envelope_id(
          envelope_id: xml_export_file_1.envelope_id
        )
      end

      expect(insert_duplicate).to raise_error Sequel::UniqueConstraintViolation
      expect(xml_export_file_2.exists?).to eq false
    end
  end

  private

  def be_a_valid_envelope_id
    current_year = Date.current.strftime("%y")
    match(/#{current_year}[0-9]{4}/)
  end
end
