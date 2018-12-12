class RegulationsController < ::BaseController
  expose(:json_list) do
    list = []

    collection.map do |record|
      list << (params[:full].present? ? record.to_json : record.json_mapping(true))
    end

    list
  end

  expose(:search_ops) {
    (params[:search] || {}).merge(
      page: params[:page]
    )
  }

  expose(:regulation_search_form) do
    ::RegulationsSearchForm.new(search_ops)
  end

  expose(:regulation_search) do
    ::RegulationsSearch.new(search_ops)
  end

  expose(:search_results) do
    regulation_search.results
  end

  expose(:regulation) do
    regulation_saver.regulation
  end

  expose(:pdf_document) do
    regulation.pdf_document_record
  end

  expose(:refulation_form) do
    ::WorkbasketForms::CreateRegulationForm.new(nil)
  end

  def collection
    ::BaseOrModificationRegulationSearch.new(params[:q]).result
  end

  def index
    respond_to do |format|
      format.html
      format.json { render json: json_list, status: :ok }
    end
  end

  def show
    self.regulation = params[:target_class].constantize.filter(
      oid: params[:id]
    ).first
  end
end
