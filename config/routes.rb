Rails.application.routes.draw do
  get "up" => "rails/health#show", :as => :rails_health_check

  get "manifest" => "rails/pwa#manifest", :as => :pwa_manifest
  get "service-worker" => "rails/pwa#service_worker", :as => :pwa_service_worker

  resource :session
  resources :passwords, param: :token

  resources :notes, except: %i[new]
  resources :settings, only: %i[index]

  get "offline", to: "static_pages#offline", as: :offline

  root "notes#index"
end
