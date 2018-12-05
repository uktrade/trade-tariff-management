module XmlGeneration
  class TransactionGrouper
    def group(records)
      records
        .sort_by(&:subrecord_code)
        .sort_by(&:record_code)
        .group_by(&:record_code)
        .values
    end
  end
end
