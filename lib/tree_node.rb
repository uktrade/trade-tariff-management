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
end
