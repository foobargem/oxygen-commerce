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

  match 'admin' => redirect('/admin/products'), :as => 'admin_root'
  

  resources :sessions
  match 'logout' => 'sessions#destroy', :as => :logout
  match 'login' => 'sessions#new', :as => :login


  #resource :coupon, :controller => :coupon do
    #member do
      #get "new_reservations"
      #put "create_reservations"
      #get "add_reservation_fields"
      #get "remove_reservation_fields"
    #end
  #end
  resources :reservations do
    collection do
      get "toggle_shoe_options"
    end
    resources :orders do
      collection do
        get "toggle_shoe_options"
      end
    end
  end

  match "/orders/toggle_shoe_options" => "orders#toggle_shoe_options"
  
  match "/reservations/toggle_shoe_options" => "reservations#toggle_shoe_options"



  namespace :admin do

    match 'dashboard' => 'dashboard#show'

    resources :products do
      member do
        get "edit_booking_constraints"
        put "update_booking_constraints"

        get 'new_coupons'
        put 'create_coupons'
        get 'add_coupon_fields'
        get 'remove_coupon_fields'
        get 'new_coupons_from_import'
        get 'new_import'
        put 'import_from_excel_file'

        #get 'new_constraints'
      end
      resources :constraints
      resources :coupons do
        member do
          get "lock"
          get "release"
        end
      end
    end

    resources :reservations do
      collection do
        get "export_to_excel"
      end
      resources :orders
    end

    resources :resorts
  end


  root :to => 'reservations#index'

end
