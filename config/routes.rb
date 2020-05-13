Rails.application.routes.draw do
  get "/" => "home#index"
  resources :menu_items
  resources :orders
  resources :users
  resources :order_items
  resources :menus
  resources :customers
  post "/order_items/add", to: "order_items#add", as: :add
  post "/order_items/remove", to: "order_items#remove", as: :remove
  post "/menus/setmenu", to: "menus#set", as: :setmenu
  get "/signin" => "sessions#new", as: :new_sessions
  post "/signin" => "sessions#create", as: :sessions
  delete "/signout" => "sessions#destroy", as: :destroy_session
end
