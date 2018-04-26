module RegulationAntidumpingContext
  extend ActiveSupport::Concern

  def antidumping_regulation_for_filter_ops
    {
      antidumping_regulation_role: public_send(primary_key[1]),
      related_antidumping_regulation_id: public_send(primary_key[0])
    }
  end

  def antidumping_regulation_for
    res = BaseRegulation.where(antidumping_regulation_for_filter_ops).first
    res = ModificationRegulation.where(antidumping_regulation_for_filter_ops).first if res.blank?

    res
  end
end
