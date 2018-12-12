class BaseOrModificationRegulationSearch
  attr_accessor :keyword

  def initialize(keyword)
    @keyword = keyword
  end

  def result
    base_regulations.to_a.concat modification_regulations.to_a
  end

private

  def base_regulations
    BaseRegulation.q_search(
      :base_regulation_id,
      keyword
    )
  end

  def modification_regulations
    ModificationRegulation.q_search(
      :modification_regulation_id,
      keyword
    )
  end
end
