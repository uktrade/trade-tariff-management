require 'date'

module Sequel
  module Plugins
    module TimeMachine
      def self.configure(model, opts={})
        model.period_start_date_column = opts[:period_start_column]
        model.period_end_date_column = opts[:period_end_column]

        model.delegate :point_in_time, to: model
      end

      module ClassMethods
        attr_accessor :period_start_date_column, :period_end_date_column

        Plugins.def_dataset_methods self, [:actual, :with_actual]

        # Inheriting classes have the same start/end date columns
        def inherited(subclass)
          super

          ds = dataset

          subclass.period_start_date_column = period_start_date_column
          subclass.period_end_date_column = period_end_date_column
          subclass.instance_eval do
            set_dataset(ds)
          end
        end

        def period_start_date_column
          @period_start_date_column.presence || Sequel.qualify(table_name, :validity_start_date)
        end

        def period_end_date_column
          @period_end_date_column.presence || Sequel.qualify(table_name, :validity_end_date)
        end

        def point_in_time
          Thread.current[::TimeMachine::THREAD_DATETIME_KEY]
        end

        def relevant_query?
          Thread.current[::TimeMachine::THREAD_RELEVANT_KEY]
        end
      end

      module InstanceMethods
        # Use for fetching associated records with relevant validity period
        # to parent record.
        def actual_or_relevant(klass)
          if self.class.point_in_time.present?
            klass.filter{|o| o.<=(self.class.period_start_date_column, self.class.point_in_time) & (o.>=(self.class.period_end_date_column, self.class.point_in_time) | ({self.class.period_end_date_column => nil})) }
          elsif self.class.relevant_query?
            klass.filter{|o| o.<=(klass.period_start_date_column, self.send(self.class.period_start_date_column.column)) & (o.>=(klass.period_end_date_column, self.send(self.class.period_end_date_column.column)) | ({klass.period_end_date_column => nil})) }
          else
            klass
          end
        end

        def duplicates_by_attributes
          good_nomenclature = GoodsNomenclature.find(goods_nomenclature_item_id: self.goods_nomenclature_item_id)
          uptree_goods_nomenclature_item_ids = good_nomenclature.sti_instance.uptree.map(&:goods_nomenclature_item_id)
          children_goods_nomenclature_item_ids = good_nomenclature.sti_instance.children.map(&:goods_nomenclature_item_id)
          goods_nomenclature_item_ids = uptree_goods_nomenclature_item_ids + children_goods_nomenclature_item_ids

          #p ""
          #p " CURRENT RECORD"
          #p ""
          #p "    measure_sid: #{self.measure_sid}"
          #p ""
          #p "    oid: #{self.oid}"
          #p ""
          #p "    validity_start_date: #{self.validity_start_date.strftime('%Y-%m-%d')}"
          #p ""
          #p "    validity_end_date: #{self.validity_end_date.try(:strftime, '%Y-%m-%d')}"
          #p ""
          #p "    goods_nomenclature_item_id: #{self.goods_nomenclature_item_id}"
          #p ""
          #p "    uptree + children: #{goods_nomenclature_item_ids.inspect}"
          #p ""

          scope = self.class.where(
            #
            # 1: Filter by record attributes
            #
            goods_nomenclature_item_id: goods_nomenclature_item_ids,
            measure_type_id: self.measure_type_id,
            geographical_area_sid: self.geographical_area_sid,
            ordernumber: self.ordernumber,
            additional_code_type_id: self.additional_code_type_id,
            additional_code_id: self.additional_code_id,
            reduction_indicator: self.reduction_indicator
          )

          scope = scope.where("measure_sid != ? ", self.measure_sid) if self.measure_sid.present?

          scope = if self.validity_end_date.present?
                    scope.where(
                      "(validity_start_date <= ? AND (validity_end_date >= ? OR validity_end_date IS NULL)) OR
                       (validity_start_date >= ? AND (validity_end_date <= ? OR validity_end_date IS NULL))",
                       self.validity_start_date, self.validity_start_date,
                       self.validity_start_date, self.validity_end_date,
                    )
                  else
                    scope.where(
                      "(validity_start_date <= ? AND (validity_end_date >= ? OR validity_end_date IS NULL))",
                      self.validity_start_date,
                      self.validity_start_date,
                    )
                  end

          #p ""
          #p " DETECTED: #{scope.count}"
          #p ""

          #scope.map.with_index do |record, index|
            #p ""
            #p "  [#{index}]"
            #p ""
            #p "     measure_sid: #{record.measure_sid}"
            #p ""
            #p "     oid: #{record.oid}"
            #p ""
            #p "     goods_nomenclature_item_id: #{record.goods_nomenclature_item_id}"
            #p ""
            #p "     validity_start_date: #{record[:validity_start_date]}"
            #p ""
            #p "     validity_end_date: #{record[validity_end_date]}"
            #p ""
            #p "     geographical_area_sid: #{record.geographical_area_sid}"
            #p ""
            #p "     measure_type_id: #{record.measure_type_id}"
            #p ""
            #p "     ordernumber: #{record.ordernumber}"
            #p ""
            #p "     additional_code_type_id: #{record.additional_code_type_id}"
            #p ""
            #p "     additional_code_id: #{record.additional_code_id}"
            #p ""
            #p "     reduction_indicator: #{record.reduction_indicator}"
          #end

          scope
        end
      end

      module DatasetMethods
        # Use for fetching record inside TimeMachine block.
        #
        # Example:
        #
        #   TimeMachine.now { Commodity.actual.first }
        #
        # Will fetch first commodity that is valid at this point in time.
        # Invoking outside time machine block will probably yield no as
        # current time variable will be nil.
        #
        def actual
          if model.point_in_time.present?
            filter{|o| o.<=(model.period_start_date_column, model.point_in_time) & (o.>=(model.period_end_date_column, model.point_in_time) | ({model.period_end_date_column => nil})) }
          else
            self
          end
        end

        #
        # This scope allows along with actual records
        # fetch records with validity_start_date in future
        #
        def actual_or_starts_in_future
          filter do |o|
            o.>=(model.period_end_date_column, model.point_in_time) |
            ({model.period_end_date_column => nil})
          end
        end

        # Use for extending datasets and associations, so that specified
        # klass would respect current time in TimeMachine.
        #
        # Example
        #
        #   TimeMachine.now { Footnote.actual
        #                             .with_actual(FootnoteDescriptionPeriod)
        #                             .joins(:footnote_description_periods)
        #                             .first }
        #
        # Useful for forming time bound associations.
        #
        def with_actual(assoc, parent = nil)
          klass = assoc.to_s.classify.constantize

          if parent && klass.relevant_query?
            filter{|o| o.<=(klass.period_start_date_column, parent.send(parent.class.period_start_date_column.column)) & (o.>=(klass.period_end_date_column, parent.send(parent.class.period_end_date_column.column)) | ({klass.period_end_date_column => nil})) }
          elsif klass.point_in_time.present?
            filter{|o| o.<=(klass.period_start_date_column, klass.point_in_time) & (o.>=(klass.period_end_date_column, klass.point_in_time) | ({klass.period_end_date_column => nil})) }
          else
            self
          end
        end
      end
    end
  end
end
