require "rails_helper"

RSpec.describe XmlExport::File do
  include EnvironmentHelper

  describe "#save_with_envelope_id" do
    subject(:xml_export_file) { build(:xml_export_file) }

    it "persists the record" do
      expect { xml_export_file.save_with_envelope_id }.
        to change(xml_export_file, :exists?).from(false).to(true)
    end

    it "generates the envelope ID" do
      expect(xml_export_file.envelope_id).to be_nil

      xml_export_file.save_with_envelope_id

      expect(xml_export_file.envelope_id.to_s).to be_a_valid_envelope_id
    end

    context "envelope ID offset is set" do
      it "allows an initial envelope ID offset to be defined" do
        with_environment(envelope_id_offset_for_current_year => "4224") do
          xml_export_file_2 = build(:xml_export_file)

          xml_export_file.save_with_envelope_id
          xml_export_file_2.save_with_envelope_id

          expect(xml_export_file.envelope_id.to_s).to end_with "4225"
          expect(xml_export_file_2.envelope_id.to_s).to end_with "4226"
        end
      end

      it "uses the higher of the offset or the last envelope ID" do
        with_environment(envelope_id_offset_for_current_year => "4224") do
          xml_export_file_2 = build(:xml_export_file)

          first_envelope_id = "#{Date.current.strftime('%y')}0008"
          xml_export_file.save_with_envelope_id(envelope_id: first_envelope_id)

          xml_export_file_2.save_with_envelope_id

          expect(xml_export_file.envelope_id.to_s).to end_with "0008"
          expect(xml_export_file_2.envelope_id.to_s).to end_with "4225"
        end
      end
    end

    context "envelope ID offset isn't set" do
      it "follows on from the previous ID for this year" do
        xml_export_file_2 = build(:xml_export_file)

        first_envelope_id = "#{Date.current.strftime('%y')}1234"
        xml_export_file.save_with_envelope_id(envelope_id: first_envelope_id)
        xml_export_file_2.save_with_envelope_id

        expect(xml_export_file_2.envelope_id.to_s).to end_with("1235")
      end
    end

    it "requires unique envelope IDs and uses a transaction", :truncation do
      xml_export_file.save_with_envelope_id
      xml_export_file_2 = build(:xml_export_file)

      insert_duplicate = Proc.new do
        xml_export_file_2.save_with_envelope_id(
          envelope_id: xml_export_file.envelope_id
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

  def envelope_id_offset_for_current_year
    "XML_ENVELOPE_ID_OFFSET_YEAR_#{Date.current.year}"
  end
end
