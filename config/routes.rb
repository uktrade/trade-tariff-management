require "sidekiq/web"

Rails.application.routes.draw do
  mount Sidekiq::Web, at: "sidekiq"

  get 'home/index'
  get "healthcheck" => "healthcheck#index"

  namespace :xml_generation do
    resources :exports, only: [:index, :show, :create]
  end

  scope module: :measures do
    resources :measures
    resources :certificates, only: [:index]
    resources :certificate_types, only: [:index]
    resources :regulations, only: [:index]
    resources :measure_types, only: [:index]
    resources :measure_type_series, only: [:index]
    resources :measure_condition_codes, only: [:index]
    resources :goods_nomenclatures, only: [:index]
    resources :additional_codes, only: [:index]
    resources :additional_code_types, only: [:index]
    resources :duty_expressions, only: [:index]
    resources :measure_actions, only: [:index]
    resources :measurement_units, only: [:index]
    resources :measurement_unit_qualifiers, only: [:index]
    resources :footnote_types, only: [:index]
    resources :footnotes, only: [:index]
  end

  root to: 'home#index'
end
