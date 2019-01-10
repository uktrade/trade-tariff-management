module Db
  class Rollback < Sequel::Model(:db_rollbacks)
    plugin :serialization

    serialize_attributes :yaml, :date_filters

    class << self
      def max_per_page
        15
      end

      def default_per_page
        15
      end

      def max_pages
        999
      end
    end
  end
end
