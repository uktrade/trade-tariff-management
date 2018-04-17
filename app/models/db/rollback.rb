module Db
  class Rollback < Sequel::Model(:db_rollbacks)

    plugin :serialization

    serialize_attributes :yaml, :date_filters

    class << self
      def max_per_page
        15
      end
    end
  end
end
