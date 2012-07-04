class FootnoteType < ActiveRecord::Base
  set_primary_keys :record_code, :subrecord_code

  has_many :footnotes
  has_many :footnote_description
  has_many :footnote_description_periods
  has_one :footnote_type_description

  APPLICATION_CODES = {
    1 => "CN nomencalture",
    2 => "TARIC nomencalture",
    3 => "Export refund nomencalture",
    5 => "Additional codes",
    6 => "CN Measures",
    7 => "Other Measures",
    8 => "Measuring Heading",
  }
end
