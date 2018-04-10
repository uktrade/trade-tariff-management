module Db
  class RollbackDecorator < JobBaseDecorator

    def clear_date
      to_readable_date_time(:clear_date)
    end
  end
end
