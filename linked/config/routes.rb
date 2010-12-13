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

  match 'admin' => redirect('/admin/reservations'), :as => 'admin_root'
  

  resources :sessions
  match 'logout' => 'sessions#destroy', :as => :logout
  match 'login' => 'sessions#new', :as => :login


  resource :coupon, :controller => :coupon do
    member do
      get "new_reservations"
      put "create_reservations"
      get "add_reservation_fields"
      get "remove_reservation_fields"
    end
    resources :reservations
  end
  


  namespace :admin do

    match 'dashboard' => 'dashboard#show'

    resources :reservations

    resources :products do
      member do
        get 'new_coupons'
        put 'create_coupons'
        get "add_coupon_fields"
        get "remove_coupon_fields"
      end
      resources :coupons
    end

  end


  root :to => 'reservations#index'

end
