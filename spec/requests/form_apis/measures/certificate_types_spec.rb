require 'rails_helper'

describe "Measure Form APIs: Certificate types", type: :request do

  include_context "form_apis_base_context"

  let(:actual_certificate_type_x) do
    add_certificate_type({
      certificate_type_code: "X",
      validity_start_date: 1.year.ago},
      "Wine reference certificate type"
    )
  end

  let(:actual_certificate_type_y) do
    add_certificate_type({
      certificate_type_code: "Y",
      validity_start_date: 1.year.ago},
      "Combined Nomenclature certificate type"
    )
  end

  let(:not_actual_certificate_type_z) do
    add_certificate_type({
      certificate_type_code: "Z",
      validity_start_date: 1.year.ago,
      validity_end_date: 3.months.ago},
      "Taric Measure certificate type"
    )
  end

  context "Index" do
    before do
      actual_certificate_type_x
      actual_certificate_type_y
      not_actual_certificate_type_z
    end

    it "should return JSON collection of all actual certificate_types" do
      get "/certificate_types.json", headers: headers

      expect(collection.count).to eq(2)

      expecting_certificate_type_in_result(0, actual_certificate_type_x)
      expecting_certificate_type_in_result(1, actual_certificate_type_y)
    end

    it "should filter certificate_types by keyword" do
      get "/certificate_types.json", params: { q: "Combined Nomen" }, headers: headers

      expect(collection.count).to eq(1)
      expecting_certificate_type_in_result(0, actual_certificate_type_y)

      get "/certificate_types.json", params: { q: "X" }, headers: headers

      expect(collection.count).to eq(1)
      expecting_certificate_type_in_result(0, actual_certificate_type_x)
    end
  end

  private

    def add_certificate_type(ops={}, description)
      ct = create(:certificate_type, ops)
      add_description(ct, description)

      ct
    end

    def add_description(certificate_type, description)
      create(:certificate_type_description,
        certificate_type_code: certificate_type.certificate_type_code,
        description: description
      )
    end

    def expecting_certificate_type_in_result(position, certificate_type)
      expect(collection[position]["certificate_type_code"]).to be_eql(certificate_type.certificate_type_code)
      expect(collection[position]["description"]).to be_eql(certificate_type.description)
    end
end
