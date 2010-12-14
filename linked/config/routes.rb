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

    resources :products do
      member do
        get 'new_coupons'
        put 'create_coupons'
        get 'add_coupon_fields'
        get 'remove_coupon_fields'
        get 'new_coupons_from_import'
        get 'new_import'
        put 'import_from_excel_file'
      end
      resources :coupons
      resources :reservations
    end

  end


  root :to => 'reservations#index'

end
