module RegulationAntidumpingContext
  extend ActiveSupport::Concern

  def antidumping_regulation_for
    BaseRegulation.where(
      antidumping_regulation_role: ,
      related_antidumping_regulation_id:
    ).first
  end
end
