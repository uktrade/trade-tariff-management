require "rails_helper"

RSpec.describe CdsResponse::ResponseProcessor do
  include_context 'create_measures_base_context'

  let(:valid_transactions) { file_fixture("cds_response_samples/valid_transactions.xml").read }
  let(:invalid_transactions) { file_fixture("cds_response_samples/invalid_transactions.xml").read }
  let(:invalid_file) { file_fixture("cds_response_samples/invalid_file.xml").read }

  before(:each) {
    @workbasket = workbasket_creating_measure(status: 'sent_to_cds')
  }

  it "identifies a response for a valid workbasket" do
    create(:xml_export_file, envelope_id: 18023, workbasket_selected: @workbasket.id)

    process_files = { "valid_response.xml" => valid_transactions }

    expect(described_class.process(process_files)).to eq "published workbasket"
    expect(@workbasket.reload.status).to eq("published")
    expect(@workbasket.collection.first.status).to eq("published")
  end

  it "identifies a response for an invalid workbasket" do
    create(:xml_export_file, envelope_id: 18029, workbasket_selected: @workbasket.id)

    process_files = { "invalid_response.xml" => invalid_transactions }

    expect(described_class.process(process_files)).to eq "invalid workbasket"
    expect(@workbasket.reload.status).to eq("cds_error")
    expect(@workbasket.collection.first.status).to eq("cds_error")
  end

  it "identifies a response without valid or invalid indicators" do
    process_files = { "invalid_file.xml" => invalid_file }

    expect(described_class.process(process_files)).to eq "could not indentify repsonse from CDS"
  end

end

def workbasket_creating_measure(status:)
  workbasket = create(:workbasket, status: status, type: "create_measures")
  create(:measure, status: status, workbasket_id: workbasket.id, measure_type: measure_type, geographical_area: geographical_area)
  workbasket
end
