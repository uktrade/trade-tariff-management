require 'api_constraints'

Rails.application.routes.draw do
  get "healthcheck" => "healthcheck#index"

  namespace :api, defaults: {format: 'json'}, path: "/" do
    # How (or even if) API versioning will be implemented is still an open question. We can defer
    # the choice until we need to expose the API to clients which we don't control.
    scope module: :v1, constraints: ApiConstraints.new(version: 1, default: true) do
     # TODO
    end
  end

  root to: 'application#nothing'

  get '*path', to: 'application#render_not_found'
end
