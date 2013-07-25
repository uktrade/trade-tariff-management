require 'forwardable'

require 'trade_tariff_backend/data_migration/block_accessor'
require 'trade_tariff_backend/data_migration/dependency'
require 'trade_tariff_backend/data_migration/runner'
require 'trade_tariff_backend/data_migration/null_runner'

module TradeTariffBackend
  class DataMigration
    attr_accessor :name

    def initialize(&block)
      instance_eval &block if block_given?
    end

    def name(name = '')
      if name.present?
        @name = name
      else
        @name
      end
    end

    def desc(desc = '')
      if desc.present?
        @desc = desc
      else
        @desc
      end
    end

    # If called with block set up migration runner
    # Otherwise return the preset runner
    def down(&block)
      if block_given?
        define_down_runner(&block)
      else
        @down_runner || NullRunner.new(self, :up)
      end
    end

    # If called with block set down migration runner
    # Otherwise return the preset runner
    def up(&block)
      if block_given?
        define_up_runner(&block)
      else
        @up_runner || NullRunner.new(self, :up)
      end
    end

    def can_rollup?
      up.applicable?
    end

    def can_rolldown?
      down.applicable?
    end

    private

    def define_up_runner(&block)
      raise ArgumentError.new("#define_up_runner expects block to be passed in") unless block_given?

      @up_runner = Runner.new(self, :up, &block)
    end

    def define_down_runner(&block)
      raise ArgumentError.new("#define_down_runner expects block to be passed in") unless block_given?

      @down_runner = Runner.new(self, :down, &block)
    end
  end

  # class DataMigrator
  #   class Presenter
  #     def self.present(migrations, presenter = ConsolePresenter)
  #       migrations.sort_by(&:created_at).each {|migration|
  #         presenter.present(migration)
  #       }
  #     end
  #   end

  #   class ConsolePreseter < Presenter
  #     def self.present(migration)
  #       puts "[ #{migration.state} ] #{migration.name}"
  #     end
  #   end
  # end
end
