require "sidekiq/web"

Rails.application.routes.draw do
  mount Sidekiq::Web, at: "sidekiq"

  get 'home/index'
  root to: 'home#index'

  get "healthcheck" => "healthcheck#index"

  namespace :xml_generation do
    resources :exports, only: [:index, :show, :create]
  end
  namespace :db do
    resources :rollbacks, only: [:index, :create]
  end

  resources :goods_nomenclatures, only: [:index]
  resources :regulations, only: [:index]
  resources :duty_expressions, only: [:index]
  resources :quota_order_numbers, only: [:index]

  scope module: :additional_codes do
    resources :additional_codes, only: [:index] do
      get :preview, on: :collection
    end

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
    resources :measures, only: [:new, :create, :index] do
      collection do
        post :search
        get :all_measures_data
      end
    end

    resources :measure_types, only: [:index]
    resources :measure_type_series, only: [:index]
    resources :measure_condition_codes, only: [:index]
    resources :measure_actions, only: [:index]
    resources :measurement_units, only: [:index]
    resources :measurement_unit_qualifiers, only: [:index]
    resources :monetary_units, only: [:index]
    resources :geographical_areas, only: [:index]
  end

  namespace :measures do
    resources :bulks, only: [:create, :edit, :update, :destroy] do
      member do
        resources :bulk_items, only: [] do
          collection do
            get :validation_details
            post :remove_items
          end
        end
      end
    end
  end

  scope module: :workbaskets do
    resources :create_measures, only: [:create, :show, :edit, :update]
  end

  namespace :regulation_form_api do
    resources :regulation_groups, only: [:index]
    resources :base_regulations, only: [:index]
  end

  resources :regulations
  resources :users, only: [:index]
end
