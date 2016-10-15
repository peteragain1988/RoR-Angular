Rails.application.routes.draw do
  mount Resque::Server, at: "/resque"
  require 'sidekiq/web'
  mount Sidekiq::Web, at: '/sidekiq'
  # constraints: {format: %w(json axlsx)}
  namespace :api do
    namespace :v1 do

      resources :companies do
        resources :events, :employees, :departments, :facilities, :clients, :options, :inventory, :facility_leases
        get 'catering/menu/categories', to: 'menu_categories#index'
        get 'catering/menu/categories/:id', to: 'menu_categories#show'
        post 'facilities/:id/leases', to: 'facility_leases#create'
      end

      namespace :my do
        resources :employees, :departments, :facilities, :clients
        resources :events do
          resources :dates do
            get 'release', on: :member
          end
        end
        get 'events/dates/:id/release', to: 'event_dates#release'

      end

      post 'my/events/dates/:id/release', to: 'inventory#create'

      post 'security/request_password_reset'
      post 'security/reset_password'

      delete 'my/inventory/:inventory_id/confirmed', to: 'confirmed_inventory_options#delete'
      # post '/login' => 'sessions#create'
      resource :sessions, only: [:create, :destroy]
      get '/auth/check', to: 'sessions#check'

    end

    namespace :v2, :defaults => { :format => 'json' } do
      resources :sessions, only: [:create, :index]

      resources :inventory do
        resources :confirmations
      end

      resources :tickets do
        # Manual creation for superadmin
        # get 'manual', to: 'tickets#manual'
        collection do
          get :manual
          post :manual, to: 'tickets#manual_create'
          get 'anz/:auth_token', to: 'tickets#anz_index'
        end
        #get 'manual', to: 'tickets#manual_create'
        get '/ticket/:id/download', to: 'tickets#pdf_download'
      end
      
      post 'tickets/get_status', to: 'tickets#get_status'
      get 'tickets/get_status', to: 'tickets#get_status'
      
      get 'tickets/anz/facility/:facility_name', to: 'tickets#anz_index'
      
      post 'tickets/create', to: 'tickets#create'
      
      post 'tickets/ticket/:id/download', to: 'tickets#pdf_download'
      get 'tickets/ticket/:id/download', to: 'tickets#pdf_download'
      
      resources :confirmations, only: [:index, :update, :destroy, :show]

      resources :menus, :leases, :dates

      resources :mail_templates do
        member do
          get 'send', to: 'mail_templates#prepare_send'
        end
      end

      resources :events do
        resources :dates do
          get 'release', to: 'dates#release'
        end
      end

      resources :facilities do
        resources :facility_leases
      end

      resources :catering do
        resources :menus
      end


      resources :companies do
        resources :clients
        resources :facilities
        resources :facility_leases
        resources :employees
        resources :departments, only: [:index]
      end

      put 'companies', to: 'companies#create'
      # Employee account confirmation and password reset
      resources :employees do
        collection do
          post '/password_reset', to: 'employees#password_reset'
          post '/report_incorrect_data', to: 'employees#report_incorrect_data'
        end
      end


      resources :reporting do
        collection do
          get 'suite_orders'
          get '/dates/:id/confirmations', to: 'reporting#confirmations_for_date'
          get '/dates/:id/unconfirmed', to: 'reporting#unconfirmed_for_date'
          get '/dates/:id/catering', to: 'reporting#catering'
        end

      end

      resources :notifications, :only => [:create] do
      end

      # User Masquerading
      get 'masquerading/available', to: 'user_masquerading#available_users'
      get 'masquerading/current', to: 'user_masquerading#current'

      namespace :my do
        resources :inventory do
          member do
            get '/client/:client_id/tickets/zip', to: 'inventory#tickets_zip'
          end
        end
        
        
        resources :events do
          collection do
            get :upcoming
          end

          member do
            get 'tickets/zip', to: 'events#tickets_zip'
          end
        end

        resources :confirmations
      end
    end
  end

  if Rails.env.development?
      get '/rails/mailers'         => "rails/mailers#index"
      get '/rails/mailers/*path'   => "rails/mailers#preview"
  end

  get '*path', to: 'home#index'
  root 'home#index'
end
