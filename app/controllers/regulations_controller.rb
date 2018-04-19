class RegulationsController < ::BaseController

  def collection
    base_regs = BaseRegulation.q_search(:base_regulation_id, params[:q])
    mod_regs = ModificationRegulation.q_search(:modification_regulation_id, params[:q])
    base_regs.to_a.concat mod_regs.to_a
  end

  def new
    @form = RegulationForm.new
  end

  def create
    puts params

    @form = RegulationForm.new params.require(:regulation_form)

    render :new
  end
end
