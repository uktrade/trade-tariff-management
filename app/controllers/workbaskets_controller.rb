class WorkbasketsController < ApplicationController

  expose(:workbaskets) do
    ::WorkbasketsSearch.new(
      current_user, params
    ).results
  end
end
