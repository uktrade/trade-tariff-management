require 'rails_helper'

describe "Measure Form APIs: Certificates", type: :request do

  include_context "form_apis_base_context"

  let(:actual_certificate_333) do
    add_certificate({
      certificate_code: "333",
      certificate_type_code: "X",
      validity_start_date: 1.year.ago},
      "Wine reference certificate"
    )
  end

  let(:actual_certificate_444) do
    add_certificate({
      certificate_code: "444",
      certificate_type_code: "Y",
      validity_start_date: 1.year.ago},
      "Combined Nomenclature certificate"
    )
  end

  let(:not_actual_certificate_555) do
    add_certificate({
      certificate_code: "555",
      certificate_type_code: "Z",
      validity_start_date: 1.year.ago,
      validity_end_date: 3.months.ago},
      "Taric Measure certificate"
    )
  end

  context "Index" do
    before do
      actual_certificate_333
      actual_certificate_444
      not_actual_certificate_555
    end

    it "should return JSON collection of all actual certificates" do
      get "/certificates.json", headers: headers

      expect(collection.count).to eq(2)

      expecting_certificate_in_result(0, actual_certificate_333)
      expecting_certificate_in_result(1, actual_certificate_444)
    end

    it "should filter certificates by keyword" do
      get "/certificates.json", params: { q: "Combined Nomen" }, headers: headers

      expect(collection.count).to eq(1)
      expecting_certificate_in_result(0, actual_certificate_444)

      get "/certificates.json", params: { q: "33" }, headers: headers

      expect(collection.count).to eq(1)
      expecting_certificate_in_result(0, actual_certificate_333)
    end

    it "should filter certificates by certificate_type_code" do
      get "/certificates.json", params: { certificate_type_code: "Y" }, headers: headers

      expect(collection.count).to eq(1)
      expecting_certificate_in_result(0, actual_certificate_444)

      get "/certificates.json", params: { certificate_type_code: "X" }, headers: headers

      expect(collection.count).to eq(1)
      expecting_certificate_in_result(0, actual_certificate_333)
    end

    it "should filter certificates by keyword and certificate_type_code at the same time" do
      get "/certificates.json", params: { certificate_type_code: "Y", q: "Combined No" }, headers: headers

      expect(collection.count).to eq(1)
      expecting_certificate_in_result(0, actual_certificate_444)

      get "/certificates.json", params: { certificate_type_code: "X", q: "NEGATIVE TEST" }, headers: headers

      expect(collection.count).to eq(0)
    end
  end

  private

    def add_certificate(ops={}, description)
      cert = create(:certificate, ops)
      add_description(cert, description)

      cert
    end

    def add_description(certificate, description)
      base_ops = {
        certificate_code: certificate.certificate_code,
        certificate_type_code: certificate.certificate_type_code
      }

      period = create(:certificate_description_period,
        base_ops.merge(validity_start_date: certificate.validity_start_date)
      )

      create(:certificate_description,
        base_ops.merge(
          description: description,
          certificate_description_period_sid: period.certificate_description_period_sid
        )
      )
    end

    def expecting_certificate_in_result(position, certificate)
      expect(collection[position]["certificate_code"]).to be_eql(certificate.certificate_code)
      expect(collection[position]["description"]).to be_eql(certificate.description)
    end
end
