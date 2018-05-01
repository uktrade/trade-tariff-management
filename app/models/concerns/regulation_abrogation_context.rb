module RegulationAbrogationContext
  extend ActiveSupport::Concern

  def antidumping_regulation_for_filter_ops
    {
      primary_key[0] => public_send(primary_key[0]),
      primary_key[1] => public_send(primary_key[1])
    }
  end

  def antidumping_regulation_for
    res = BaseRegulation.where(antidumping_regulation_for_filter_ops).first
    res = ModificationRegulation.where(antidumping_regulation_for_filter_ops).first if res.blank?

    res
  end
end
