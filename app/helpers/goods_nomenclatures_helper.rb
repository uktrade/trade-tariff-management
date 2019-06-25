module GoodsNomenclaturesHelper
  def format_nomenclature_code(nomenclature)
    "#{nomenclature[0..1]} #{nomenclature[2..3]} #{nomenclature[4..5]} #{nomenclature[6..7]} #{nomenclature[8..9]}"
  end
end
