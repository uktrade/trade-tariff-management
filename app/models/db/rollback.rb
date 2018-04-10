module Db
  class Rollback < Sequel::Model(:db_rollbacks)

    class << self
      def max_per_page
        15
      end
    end
  end
end
