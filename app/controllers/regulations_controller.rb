class RegulationsController < ::BaseController

  expose(:regulation_saver) do
    regulation_ops = params[:regulation_form]
    regulation_ops.send("permitted=", true)
    regulation_ops = regulation_ops.to_h

    ::RegulationSaver.new(current_user, regulation_ops)
  end

  expose(:regulation) do
    regulation_saver.regulation
  end

  expose(:pdf_document) do
    regulation.pdf_document_record
  end

  def collection
    base_regs = BaseRegulation.q_search(:base_regulation_id, params[:q])
    mod_regs = ModificationRegulation.q_search(:modification_regulation_id, params[:q])
    base_regs.to_a.concat mod_regs.to_a
  end

  def index
    respond_to do |format|
      format.html
      format.json { render json: json_list, status: :ok }
    end
  end

  def new
    @form = RegulationForm.new
  end

  def show
    self.regulation = params[:target_class].constantize.filter(
      oid: params[:id]
    ).first
  end

  def create
    if regulation_saver.valid?
      regulation_saver.persist!

      redirect_to regulation_url(
        regulation.oid,
        target_class: regulation.class.to_s
      )
    else
      @form = RegulationForm.new nil, params[:regulation_form]
      regulation_saver.errors.each do |k,v|
        @form.errors.add(k, v)
      end

      render :new
    end
  end
end
