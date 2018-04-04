class RegulationsController < ::BaseController

  def collection
    base_regs = BaseRegulation.actual.not_replaced_and_partially_replaced.q_search(params[:q])
    mod_regs = ModificationRegulation.actual.not_replaced_and_partially_replaced.q_search(params[:q])
    base_regs.to_a.concat mod_regs.to_a
  end
end
