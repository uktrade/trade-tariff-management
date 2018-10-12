#
# We need to update operation_date column type to DateTime for all tables
# Steps:
# 0. drop view
# 1. drop index
# 2. change type
# 3. create index
# 4. create view

Sequel.migration do
  up do
    skip_index = [:workbaskets, :publication_sigles_oplog]
    skip_view = [:workbaskets]
    Sequel::Model.db.tables.select{ |t| Sequel::Model.db[t].columns.include?(:operation_date) }.each do |table_name|
      index_name = [
        table_name.to_s.split("_").map(&:first).join,
        table_name.to_s.split("_").map{|w| w.first(3)}.join,
        table_name.to_s.split("_").map{|w| w.last(3)}.join,
        "operation_date"
      ].join("_")

      unless skip_view.include?(table_name)
        view_name = table_name.to_s.split("_oplog").first
        pk = view_name.classify.constantize.primary_key
        pk_assoc_hash = if pk.is_a?(Array)
                          pk.inject({}) { |memo, pk_part|
                            memo.merge!(:"#{view_name}1__#{pk_part}" => :"#{view_name}2__#{pk_part}")
                            memo
                          }
                        else
                          {:"#{view_name}1__#{pk}" => :"#{view_name}2__#{pk}"}
                        end
        column_names = (Sequel::Model.db[table_name].columns - [:updated_at, :created_at])
      end

      puts "Processing #{table_name} table"

      # drop view
      unless skip_view.include?(table_name)
        puts "Dropping view: #{view_name}"
        drop_view(view_name)
      end

      alter_table table_name do
        # drop index
        unless skip_index.include?(table_name)
          puts "Dropping index: #{index_name}"
          drop_index(:operation_date, name: index_name)
        end

        # change column type
        puts "Changing column type"
        set_column_type :operation_date, DateTime

        # create index
        unless skip_index.include?(table_name)
          puts "Creating index: #{index_name}"
          add_index(:operation_date, name: index_name)
        end
      end

      # create view
      unless skip_view.include?(table_name)
        puts "Creating view: #{view_name}"
        create_or_replace_view(
            view_name,
            Sequel::Model.db[:"#{table_name}___#{view_name}1"]
                .select(*column_names)
                .where(:"#{view_name}1__oid" => Sequel::Model.db[:"#{table_name}___#{view_name}2"]
                                                    .select(Sequel.function(:max, :oid))
                                                    .where(pk_assoc_hash))
                .where{ Sequel.~(:"#{view_name}1__operation" => "D") }
        )
      end
    end
  end

  # ==================================================================================

  down do
    skip_index = [:workbaskets, :publication_sigles_oplog]
    skip_view = [:workbaskets]
    Sequel::Model.db.tables.select{ |t| Sequel::Model.db[t].columns.include?(:operation_date) }.each do |table_name|
      index_name = [
          table_name.to_s.split("_").map(&:first).join,
          table_name.to_s.split("_").map{|w| w.first(3)}.join,
          table_name.to_s.split("_").map{|w| w.last(3)}.join,
          "operation_date"
      ].join("_")

      unless skip_view.include?(table_name)
        view_name = table_name.to_s.split("_oplog").first
        pk = view_name.classify.constantize.primary_key
        pk_assoc_hash = if pk.is_a?(Array)
                          pk.inject({}) { |memo, pk_part|
                            memo.merge!(:"#{view_name}1__#{pk_part}" => :"#{view_name}2__#{pk_part}")
                            memo
                          }
                        else
                          {:"#{view_name}1__#{pk}" => :"#{view_name}2__#{pk}"}
                        end
        column_names = (Sequel::Model.db[table_name].columns - [:updated_at, :created_at])
      end

      # drop view
      unless skip_view.include?(table_name)
        puts "Dropping view: #{view_name}"
        drop_view(view_name)
      end

      alter_table table_name do
        # drop index
        unless skip_index.include?(table_name)
          puts "Dropping index: #{index_name}"
          drop_index(:operation_date, name: index_name)
        end

        # change column type
        puts "Changing column type"
        set_column_type :operation_date, DateTime

        # create index
        unless skip_index.include?(table_name)
          puts "Creating index: #{index_name}"
          add_index(:operation_date, name: index_name)
        end
      end

      # create view
      unless skip_view.include?(table_name)
        puts "Creating view: #{view_name}"
        create_or_replace_view(
            view_name,
            Sequel::Model.db[:"#{table_name}___#{view_name}1"]
                .select(*column_names)
                .where(:"#{view_name}1__oid" => Sequel::Model.db[:"#{table_name}___#{view_name}2"]
                                                    .select(Sequel.function(:max, :oid))
                                                    .where(pk_assoc_hash))
                .where{ Sequel.~(:"#{view_name}1__operation" => "D") }
        )
      end
    end
  end
end
