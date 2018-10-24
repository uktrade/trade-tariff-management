module Api
  class XmlFilesController < ApiController
    # timestamp format YYYY-MM-DD
    def index
      date = params[:date] || Date.yesterday.to_s
      files = XmlExport::File.where("issue_date::date >= ?", Date.parse(date)).to_a
      serialized = Api::XmlFilesIndexSerializer.call(files)

      render json: serialized
    end

    # timestamp format YYYYMMDDTHHMMSS
    def show
      file = XmlExport::File.where("date_trunc('second', issue_date) = ?", Time.zone.parse(params[:timestamp]).utc).first

      if file&.xml.present?
        redirect_to file.xml.url
      else
        head :not_found
      end
    end
  end
end
