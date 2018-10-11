module Api
  class XmlFilesController < ApiController
    def index
      date = params[:date] || Date.yesterday.to_s
      files = XmlExport::File.where("issue_date::date >= ?", Date.parse(date)).to_a
      serialized = Api::XmlFilesIndexSerializer.call(files)

      render json: serialized
    end

    def show
      file = XmlExport::File.where("issue_date::date = ?", Date.parse(params[:date])).first

      if file&.xml.present?
        redirect_to file.xml.url
      else
        head :not_found
      end
    end
  end
end
