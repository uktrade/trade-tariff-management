class FootnoteAssociationMeursingHeading < ActiveRecord::Base
  set_primary_keys :record_code, :subrecord_code

  belongs_to :meursing_table_plan
  #TODO FIXME
  # belongs_to :footnote_type, foreign_key: :footnote_type
  belongs_to :footnote
end
