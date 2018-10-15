require "rails_helper"

describe Api::XmlFilesController do
  describe "GET #index" do
    let!(:files) { [create(:xml_export_file), create(:xml_export_file)] }

    it "responses with application/json 200" do
      get :index, params: { date: Date.today }

      expect(response.status).to eq(200)
      expect(response.content_type).to eq "application/json"
    end

    it "returns array of files" do
      get :index, params: { date: 3.days.ago }

      body = JSON.parse(response.body)
      expect(body.length).to eq(2)
      expect(body.map { |i| i["id"] }.sort).to eq(files.map(&:id).sort)
    end

    it "uses yesterday as default date" do
      file = create(:xml_export_file, issue_date: Date.yesterday)
      get :index, params: {}

      body = JSON.parse(response.body)
      expect(body.length).to eq(1)
      expect(body[0]["id"]).to eq(file.id)
    end
  end

  describe "GET #show" do
    let!(:xml_export_file) { create(:xml_export_file) }

    context "when file does not exist" do
      it "responses with 404" do
        get :show, params: { timestamp: Time.now.strftime("%Y%m%dT%H%M%S") }

        expect(response.status).to eq(404)
      end
    end

    context "when file exists" do
      it "responses with 200" do
        xml = double("Xml", url: "http://example.com")
        allow_any_instance_of(XmlExport::File).to receive(:xml).and_return(xml)

        get :show, params: { timestamp: xml_export_file.issue_date.strftime("%Y%m%dT%H%M%S") }

        expect(response.status).to eq(302)
        expect(response).to redirect_to(xml.url)
      end
    end
  end
end
