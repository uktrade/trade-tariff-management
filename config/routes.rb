require "sidekiq/web"

Rails.application.routes.draw do
  mount Sidekiq::Web, at: "sidekiq"

  get 'home/index'
  root to: 'home#index'

  get "healthcheck" => "healthcheck#index"

  namespace :xml_generation do
    resources :exports, only: [:index, :show, :create]
  end

  resources :goods_nomenclatures, only: [:index]
  resources :regulations, only: [:index]
  resources :duty_expressions, only: [:index]
  resources :quota_order_numbers, only: [:index]

  scope module: :additional_codes do
    resources :additional_codes, only: [:index]
    resources :additional_code_types, only: [:index]
  end

  scope module: :certificates do
    resources :certificates, only: [:index]
    resources :certificate_types, only: [:index]
  end

  scope module: :footnotes do
    resources :footnote_types, only: [:index]
    resources :footnotes, only: [:index]
  end

  scope module: :measures do
    resources :measures
    resources :measure_types, only: [:index]
    resources :measure_type_series, only: [:index]
    resources :measure_condition_codes, only: [:index]
    resources :measure_actions, only: [:index]
    resources :measurement_units, only: [:index]
    resources :measurement_unit_qualifiers, only: [:index]
    resources :monetary_units, only: [:index]
  end

  namespace :regulation_form_api do
    resources :regulation_groups, only: [:index]
    resources :base_regulations, only: [:index]
    resources :complete_abrogation_regulations, only: [:index]
    resources :explicit_abrogation_regulations, only: [:index]
  end

  resources :regulations
end
