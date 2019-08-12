class TreeNode
  attr_accessor :name, :content, :children

  def initialize(name, content)
    @name = name
    @content = content
    @children = []
  end

  def has_children?
    !children.empty?
  end

  def is_ancestor_of?(goods_nomenclature)
    goods_nomenclature.uptree.map do |nomenclature|
      [nomenclature[:goods_nomenclature_item_id], nomenclature[:producline_suffix]]
    end.include?([@content[:goods_nomenclature_item_id], @content[:producline_suffix]])
  end
end
