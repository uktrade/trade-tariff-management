module Api
  module V1
    class CommoditiesController < ApplicationController
      def show
        @commodity = Commodity.includes(:measures, :heading).find(params[:id])

        respond_with @commodity
      end

      # TODO: Remove this hack once the write api is done.
      def update
        @commodity = Commodity.find(params[:id])
        @commodity.synonyms = params[:commodity][:synonyms]
        @commodity.save

        respond_with @commodity
      end
    end
  end
end
