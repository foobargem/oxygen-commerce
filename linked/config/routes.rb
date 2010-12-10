Linked::Application.routes.draw do

  devise_for :admins,
    :path => 'admin',
    :path_names => {
      :sign_in => 'login',
      :sign_out => 'logout'
    },
    :controllers => {
      :sessions => 'admin/sessions'
    }

  match 'admin' => redirect('/admin/dashboard'), :as => 'admin_root'
  #match 'sessions/admin' => redirect('/admin/dashboard')
  

  resources :sessions
  match 'logout' => 'sessions#destroy', :as => :logout
  match 'login' => 'sessions#new', :as => :login

  resources :reservations
  


  namespace :admin do

    match 'dashboard' => 'dashboard#show'

    resources :reservations

    resources :products do
      member do
        get 'new_coupons'
        put 'create_coupons'
      end
      resources :coupons
    end

  end


  root :to => 'reservations#index'

end
