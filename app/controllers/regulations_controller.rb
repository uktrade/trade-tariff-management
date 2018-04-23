class RegulationsController < ::BaseController

  expose(:regulation_saver) do
    regulation_ops = params.require(:regulation_form).permit
    regulation_ops[:permitted] = true
    regulation_ops = regulation_ops.to_h

    ::RegulationSaver.new(regulation_ops)
  end

  expose(:regulation) do
    regulation_saver.regulation
  end

  def collection
    base_regs = BaseRegulation.q_search(:base_regulation_id, params[:q])
    mod_regs = ModificationRegulation.q_search(:modification_regulation_id, params[:q])
    base_regs.to_a.concat mod_regs.to_a
  end

  def new
    @form = RegulationForm.new
  end

  def create
    Rails.logger.info ""
    Rails.logger.info "-" * 100
    Rails.logger.info ""
    Rails.logger.info "regulation_form: #{params[:regulation_form].inspect}"
    Rails.logger.info ""
    Rails.logger.info "-" * 100
    Rails.logger.info ""

    if regulation_saver.valid?
      regulation_saver.persist!

      redirect_to root_url
    else
      @form = RegulationForm.new nil, params[:regulation_form]
      regulation_saver.errors.each do |k,v|
        @form.errors.add(k, v)
      end

      render :new
    end
  end
end
