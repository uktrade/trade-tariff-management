class FootnoteAssociationMeasure < ActiveRecord::Base
  set_primary_keys :record_code, :subrecord_code
  
  belongs_to :measure, foreign_key: :measure_sid
  belongs_to :footnote
  belongs_to :footnote_type
end
