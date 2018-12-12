module WorkbasketScripts
  class SetPublishedStatusForImportedData
    class << self
      def run
        target_tables.map do |table_name|
          log_it("[#{table_name}] ----------------- started")

          Sequel::Model.db.execute(
            update_sql(table_name)
          )

          sleep 5

          log_it("[#{table_name}] ----------------- finished")
        end
      end

    private

      def target_tables
        Sequel::Model.db.fetch(target_tables_sql).all.map do |el|
          el[:table_name]
        end.select do |table_name|
          table_name.ends_with?("_oplog")
        end
      end

      def target_tables_sql
        <<-eos
          SELECT table_name
          FROM information_schema.columns
          WHERE column_name = 'operation_date'
        eos
      end

      def update_sql(table_name)
        <<-eos
          UPDATE #{table_name}
          SET status = 'published'
          WHERE status IS NULL OR status = ''
        eos
      end

      def log_it(message)
        puts ""
        puts "-" * 100
        puts ""
        puts " #{message}"
        puts ""
        puts "-" * 100
        puts ""
      end
    end
  end
end
