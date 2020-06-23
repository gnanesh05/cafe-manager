Rails.application.routes.draw do
  get "/" => "home#index"
  resources :menu_items
  resources :orders
  resources :users
  resources :order_items
  resources :menus
  resources :customers

  post "/orders/repeat_order", to: "orders#repeat_order", as: :repeat_order
  post "/orders/deliver_order", to: "orders#deliver_order", as: :deliver_order
  post "/users/change_role", to: "users#change_role", as: :change_role
  post "/users/change_identity", to: "users#change_identity", as: :change_identity
  post "/order_items/offline_customer", to: "order_items#offline_customer", as: :offline_customer
  post "/order_items/add", to: "order_items#add", as: :add
  post "/order_items/remove", to: "order_items#remove", as: :remove
  post "/order_items/create_order_item", to: "order_items#create_order_item", as: :create_order_item
  post "/menus/setmenu", to: "menus#set", as: :setmenu
  get "/signin" => "sessions#new", as: :new_sessions
  post "/signin" => "sessions#create", as: :sessions
  delete "/signout" => "sessions#destroy", as: :destroy_session
  delete "/remove" => "order_items#delete", as: :delete
  get "/report" => "customers#report"
  get "/user_report" => "customers#user_report"
  get "/about" => "about#index"
end
