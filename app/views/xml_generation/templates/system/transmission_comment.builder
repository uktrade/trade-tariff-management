xml.tag!("oub:transmission.comment") do |transmission_comment|
  transmission_comment.tag!("oub:comment.sid") do transmission_comment
    xml_data_item(transmission_comment, self.comment_sid)
  end

  transmission_comment.tag!("oub:language.id") do transmission_comment
    xml_data_item(transmission_comment, self.language_id)
  end

  transmission_comment.tag!("oub:comment.text") do transmission_comment
    xml_data_item(transmission_comment, self.comment_text)
  end
end
