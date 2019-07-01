require 'rails_helper'

RSpec.describe(TreeNode) do

  describe "has_children?" do
    it "returns false when no children" do
      expect(described_class.new("dummy name", "dummy content").has_children?).to be false
    end

    it "returns true when children are added" do
      root_node = described_class.new("dummy name", "dummy content")
      root_node.children << described_class.new("child name", "a child node")

      expect(root_node.has_children?).to be true
    end
  end
end
