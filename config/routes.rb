Rails.application.routes.draw do
  root "products#index"

  resources :homes
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  devise_for :users
  resources :products do
    resources :likes
  	get "/add_to_cart", to: "products#add_to_cart"
    get "/add_to_wishlist", to: "products#add_to_wishlist"
    get "/remove_to_wishlist", to: "products#remove_to_wishlist"


  get "/like_products", to: "products#add_to_like"
  get "/dislike_products", to: "products#remove_to_like"
  end
  resources :cart_items do
  	get "/remove", to: "cart_items#destroy"
  end
  resources :wishlists do
    get "/remove_to_wishlist", to: "products#remove_to_wishlist"

  end 
  get "/search", to: "products#search"

  match '/auth/:provider/callback', :to => 'sessions#create', via: [:get, :post]
  match '/auth/failure', :to => 'sessions#failure', via: [:get, :post]


  resources :sub_categories
  resources :categories
  resources :contacts

  
  post "/create-checkout-session", to: "cart_items#checkout"

  get "/carts/success", to: "cart_items#success"
  get "/carts/cancel", to: "cart_items#cancel"
  get "/success", to: "cart_items#success_page"
  get "/cancel", to: "cart_items#cancel_page"
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
