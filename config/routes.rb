require "sidekiq/web"

Rails.application.routes.draw do
  if Rails.env.development?
    mount Sidekiq::Web, at: "sidekiq"
  end

  root to: 'workbaskets#index'

  get "healthcheck" => "healthcheck#index"

  get  "/auth/:provider/callback", to: "sessions#create"
  post "/auth/:provider/callback", to: "sessions#create"
  get  "/logout",                  to: "sessions#destroy", as: "gds_sign_out"
  get  "/log_in",                  to: "log_in#index", as: "log_in"

  resources :workbaskets, only: [:index]

  namespace :xml_generation do
    resources :exports, only: [:index, :show, :create]
  end

  unless TradeTariffBackend.production?
    namespace :db do
      resources :rollbacks, only: [:index, :create]
    end
  end

  # Need to prevent production server running these
  if ENV['ALLOW_TESTER_TO_BYPASS_CDS'] == 'ALLOW'
    namespace :admin do
      resources :workbasket_status, only: [:index, :update]
    end
  end

  namespace :api do
    get "/v1/taricdelta(/:date)",   to: "xml_files#index"
    get "/v1/taricfile/:timestamp", to: "xml_files#show"
  end

  resources :goods_nomenclatures, only: [:index, :show] do
    collection do
      post :search
    end
  end
  resources :regulations, only: [:index]
  resources :duty_expressions, only: [:index]
  resources :quota_order_numbers, only: [:index]

  scope module: :additional_codes do
    resources :additional_codes, only: [:index] do
      collection do
        post :search

        get :preview
      end
    end

    resources :additional_code_types, only: [:index]
  end

  namespace :additional_codes do
    resources :bulks, only: [:show, :create, :edit, :update, :destroy] do
      member do
        get '/work_with_selected', to: "bulks#work_with_selected"
        post '/work_with_selected', to: "bulks#persist_work_with_selected"
        get :submitted_for_cross_check
        get :withdraw_workbasket_from_workflow

        resources :bulk_items, only: [] do
          collection do
            get :validation_details
            post :remove_items
          end
        end
      end
    end
  end

  scope module: :certificates do
    resources :certificates, only: [:index] do
      collection do
        get :search
        get :validate_search_settings
      end
    end
    resources :certificate_types, only: [:index]
  end

  scope module: :footnotes do
    resources :footnote_types, only: [:index]
    resources :footnotes, only: [:new, :index] do
      collection do
        get :search
        get :validate_search_settings
      end
    end
  end

  scope module: :quotas do
    resources :quotas, only: [:index] do
      collection do
        post :search
      end
    end
  end

  namespace :quotas do
    resources :bulks, only: [:show, :create, :edit, :update, :destroy] do
      member do
        get '/work_with_selected', to: "bulks#work_with_selected"
        post '/work_with_selected', to: "bulks#persist_work_with_selected"
        get '/configure_cloned', to: "bulks#configure_cloned"
        post '/configure_cloned', to: "bulks#persist_configure_cloned"
        get :submitted_for_cross_check

        resources :bulk_items, only: [] do
          collection do
            get :validation_details
            post :remove_items
          end
        end
      end
    end
  end

  scope module: :measures do
    resources :measures, only: [:index] do
      collection do
        post :search

        get :download
        get :quick_search
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
    resources :geographical_areas, only: [:index] do
      collection do
        get :check_multiple
      end
    end
  end

  namespace :measures do
    resources :bulks, only: [:show, :create, :edit, :update, :destroy] do
      member do
        get '/work_with_selected_measures', to: "bulks#work_with_selected_measures"
        post '/work_with_selected_measures', to: "bulks#persist_work_with_selected_measures"

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

    scope module: :workflows do
      resources :workbaskets, only: [] do
        member do
          resource :schedule_export_to_cds, only: [:new, :create]
          resource :cross_check, only: [:new, :create, :show]
          resource :approve, only: [:new, :create, :show]
          resource :workflow_transitions, only: [] do
            post :submit_for_approval
          end
        end
      end
    end

    resources :create_additional_code, only: [:new, :show, :edit, :update, :destroy] do
      member do
        get :submitted_for_cross_check
        get :move_to_editing_mode
        get :withdraw_workbasket_from_workflow
      end
    end

    resources :create_regulation, only: [:new, :show, :edit, :update, :destroy] do
      member do
        put :attach_pdf

        get :submitted_for_cross_check
        get :move_to_editing_mode
        get :withdraw_workbasket_from_workflow
      end
    end

    resources :create_geographical_area, only: [:new, :show, :edit, :update, :destroy] do
      member do
        post :validate_group_memberships
        post :validate_country_or_region_memberhips
        post :validate_membership

        get :submitted_for_cross_check
        get :move_to_editing_mode
        get :withdraw_workbasket_from_workflow
      end
    end

    resources :create_certificate, only: [:new, :show, :edit, :update, :destroy] do
      member do
        get :submitted_for_cross_check
        get :move_to_editing_mode
        get :withdraw_workbasket_from_workflow
      end
    end

    resources :create_measures, only: [:new, :show, :edit, :update, :destroy] do
      member do
        get :submitted_for_cross_check
        get :move_to_editing_mode
        get :withdraw_workbasket_from_workflow
      end
    end

    resources :bulk_edit_of_measures, only: [:show, :destroy] do
      member do
        get :submitted_for_cross_check
        get :move_to_editing_mode
        get :withdraw_workbasket_from_workflow
      end
    end

    resources :create_quota, only: [:new, :show, :edit, :update, :destroy] do
      member do
        get :submitted_for_cross_check
        get :move_to_editing_mode
        get :withdraw_workbasket_from_workflow
      end
    end

    resources :create_footnote, only: [:new, :show, :edit, :update, :destroy] do
      member do
        get :submitted_for_cross_check
        get :move_to_editing_mode
        get :withdraw_workbasket_from_workflow
      end
    end

    resources :edit_footnote, only: [:new, :show, :edit, :update, :destroy] do
      member do
        get :submitted_for_cross_check
        get :move_to_editing_mode
        get :withdraw_workbasket_from_workflow
      end
    end

    resources :edit_certificate, only: [:new, :show, :edit, :update, :destroy] do
      member do
        get :submitted_for_cross_check
        get :move_to_editing_mode
        get :withdraw_workbasket_from_workflow
      end
    end

    resources :edit_geographical_area, only: [:new, :show, :edit, :update, :destroy] do
      member do
        get :submitted_for_cross_check
        get :move_to_editing_mode
        get :withdraw_workbasket_from_workflow
      end
    end

    resource :manage_nomenclature, only: [:new, :create]

    resources :edit_nomenclature, only: [:edit, :update, :show, :destroy] do
      member do
        get :submitted_for_cross_check
        get :move_to_editing_mode
        get :withdraw_workbasket_from_workflow
      end
    end

    resources :edit_regulation, only: [:new, :create, :edit, :update, :show, :destroy] do
      member do
        get :submitted_for_cross_check
        get :move_to_editing_mode
        get :withdraw_workbasket_from_workflow
      end
    end
  end

  scope module: :geo_areas do
    resources :geo_areas, only: [:index] do
      collection do
        get :validate_search_settings
      end
    end
  end

  namespace :regulation_form_api do
    resources :regulation_groups, only: [:index]
    resources :base_regulations, only: [:index]
  end

  resources :users, only: [:index]

  scope module: :nomenclature do
    resources :sections, only: [:index, :show]
    resources :chapters, only: [:show]
  end

  scope module: :quota_associations do
    resources :quota_associations, only: [:index]
    resources :create_quota_association, only: [:index, :new] do
      collection do
        post 'search'
      end
    end
  end
end
