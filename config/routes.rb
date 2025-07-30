Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  root 'homes#index'
  resource :session, path: 'admin', controller: 'auth/sessions', only: [] do
    get :sign_in, action: :new
    post :sign_in, action: :create
    delete :sign_out, action: :destroy
  end
  resource :password, param: :token, controller: 'auth/passwords', path: 'admin', only: [] do
    get :new_password, action: :edit
    put :new_password, action: :update
    get :forgot_password, action: :new
    post :forgot_password, action: :create
    get :check_mail_change_password, action: :check_mail
  end
  resource :registration, controller: 'auth/registrations', path: 'admin', only: [] do
    get :sign_up, action: :new
    post :sign_up, action: :create
    get :check_mail_verify_email, action: :check_mail
  end
  namespace :admin do
    resources :dashboards, only: [:index]
    resources :managers
    resources :users
    resources :genres
  end



  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"
end
