# frozen_string_literal: true

Kaminari.configure do |config|
  config.default_per_page = 25
  config.max_per_page = 25
  # config.window = 4
  # config.outer_window = 0
  # config.left = 0
  # config.right = 0
  # config.page_method_name = :page
  # config.param_name = :page
  # config.params_on_first_page = false
end

#
# This is a Kaminari Sequel patch.
# without it Kaminari always using default settings above ^
# and ignoring any values you add to model settings.
#
module Kaminari
  module Sequel
    module PageMethod
      def page_method(num)
        per_page =
          if model.max_per_page && (model.default_per_page > model.max_per_page)
            model.max_per_page
          else
            model.default_per_page
          end

        limit(per_page)
          .offset(per_page * ((num = num.to_i - 1) < 0 ? 0 : num))
          .with_extend(
            Kaminari::Sequel::DatasetMethods,
            Kaminari::PageScopeMethods
          )
      end
    end
  end
end
