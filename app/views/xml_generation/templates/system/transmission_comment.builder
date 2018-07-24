xml.tag!("oub:transmission.comment") do |transmission_comment|
  xml_data_item_v2(transmission_comment, "comment.sid", self.comment_sid)
  xml_data_item_v2(transmission_comment, "language.id", self.language_id)
  xml_data_item_v2(transmission_comment, "comment.text", self.comment_text)
end
