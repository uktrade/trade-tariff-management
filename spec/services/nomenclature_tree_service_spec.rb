require 'rails_helper'

describe NomenclatureTreeService do
  describe '#nomenclature_tree' do
    it "returns a correct tree" do
      create(:goods_nomenclature, goods_nomenclature_item_id: '0805000000', producline_suffix: '80', indents: 0)
      create(:goods_nomenclature, goods_nomenclature_item_id: '0805100000', producline_suffix: '80', indents: 1)
      create(:goods_nomenclature, goods_nomenclature_item_id: '0805102200', producline_suffix: '10', indents: 2)
      create(:goods_nomenclature, goods_nomenclature_item_id: '0805102200', producline_suffix: '80', indents: 3)
      create(:goods_nomenclature, goods_nomenclature_item_id: '0805102210', producline_suffix: '80', indents: 4)
      create(:goods_nomenclature, goods_nomenclature_item_id: '0805102290', producline_suffix: '80', indents: 4)
      create(:goods_nomenclature, goods_nomenclature_item_id: '0805102400', producline_suffix: '80', indents: 3)
      create(:goods_nomenclature, goods_nomenclature_item_id: '0805102410', producline_suffix: '80', indents: 4)
      create(:goods_nomenclature, goods_nomenclature_item_id: '0805102490', producline_suffix: '80', indents: 4)
      create(:goods_nomenclature, goods_nomenclature_item_id: '0805102800', producline_suffix: '80', indents: 3)
      create(:goods_nomenclature, goods_nomenclature_item_id: '0805102810', producline_suffix: '80', indents: 4)
      create(:goods_nomenclature, goods_nomenclature_item_id: '0805102890', producline_suffix: '80', indents: 4)
      create(:goods_nomenclature, goods_nomenclature_item_id: '0805108000', producline_suffix: '80', indents: 2)
      create(:goods_nomenclature, goods_nomenclature_item_id: '0805108010', producline_suffix: '80', indents: 3)
      create(:goods_nomenclature, goods_nomenclature_item_id: '0805108090', producline_suffix: '80', indents: 3)

      root_node = described_class.nomenclature_tree('0805000000')

      expect(root_node.name).to eq("0805000000")
      expect(root_node.children.count).to eq(1)

      gn_0805100000 = root_node.children.first
      expect(gn_0805100000.name).to eq("0805100000")
      expect(gn_0805100000.children.count).to eq(2)

      gn_0805102200_10 = gn_0805100000.children.first
      expect(gn_0805102200_10.name).to eq("0805102200")
      expect(gn_0805102200_10.children.count).to eq(3)

      gn_0805108000 = gn_0805100000.children.second
      expect(gn_0805108000.name).to eq("0805108000")
      expect(gn_0805108000.children.count).to eq(2)

    end
  end
end
