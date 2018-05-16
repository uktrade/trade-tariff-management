xml.instruct!(:xml, version: "1.0", encoding: "utf-8")
xml.tag!("BatchFileInterfaceMetadata", xmlns: "http://www.hmrc.gsi.gov.uk/mdg/batchFileInterfaceMetadataSchema",
                                       "xmlns:vc" => "http://www.w3.org/2007/XMLSchema-versioning",
                                       "xsi:schemaLocation" => "http://www.hmrc.gsi.gov.uk/mdg/batchFileInterfaceMetadataSchema schema.xsd",
                                       "xmlns:xsi" => "http://www.w3.org/2001/XMLSchema-instance") do |env|
  env.tag!("sourceSystem") do record
    self.class::SOURCE_SYSTEM
  end

  env.tag!("sourceSystemType") do record
    self.class::SOURCE_SYSTEM_TYPE
  end

  env.tag!("sourceSystemOS") do record
    self.class::SOURCE_SYSTEM_OS
  end

  env.tag!("interfaceName") do record
    self.class::INTERFACE_NAME
  end

  env.tag!("interfaceVersion") do record
    self.class::INTERFACE_VERSION
  end

  env.tag!("correlationID") do record
    self.class::CORRELATION_ID
  end

  env.tag!("conversationID") do record
    self.class::CONVERSATION_ID
  end

  env.tag!("transactionID") do record
    self.class::TRANSACTION_ID
  end

  env.tag!("messageID") do record
    self.class::MESSAGE_ID
  end

  env.tag!("extractStartDateTime") do record
    self.extract_start_date_time
  end

  env.tag!("extractEndDateTime") do record
    self.extract_end_date_time
  end

  env.tag!("extractDatabaseDateTime") do record
    self.extract_database_date_time
  end

  env.tag!("checksum") do record
    self.xml_file_checksum
  end

  env.tag!("checksumAlgorithm") do record
    self.class::CHECKSUM_ALGORITHM
  end

  env.tag!("fileSize") do record
    self.xml_file_size
  end

  env.tag!("compressed") do record
    self.class::COMPRESSED
  end

  env.tag!("compressionAlgorithm") do record
    self.class::COMPRESSION_ALGORITHM
  end

  env.tag!("compressedChecksum") do record
    self.compressed_checksum
  end

  env.tag!("compressedChecksumAlgorithm") do record
    self.class::COMPRESSED_CHECKSUM_ALGORITHM
  end

  env.tag!("sourceLocation") do record
    self.class::SOURCE_LOCATION
  end

  env.tag!("sourceFileName") do record
    self.class::SOURCE_FILE_NAME
  end

  env.tag!("sourceFileEncoding") do record
    self.class::SOURCE_FILE_ENCODING
  end

  env.tag!("destinations") do |destinations_node|
    self.destinations.map do |destination|
      destinations_node.tag!("destination") do |destination_node|
        destination_node.tag!("destinationSystem") do record
          destination.destination_system
        end

        destination_node.tag!("destinationLocation") do record
          destination.destination_location
        end

        destination_node.tag!("destinationFileName") do record
          destination.destination_file_name
        end

        destination_node.tag!("destinationFileEncoding") do record
          destination.destination_file_encoding
        end
      end
    end
  end
end
