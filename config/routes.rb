Rails.application.routes.draw do
  resources :cats
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
  post "/checkout_razor", to: "cart_items#checkout_razor"

  get "/carts/success", to: "cart_items#success"
  get "/carts/cancel", to: "cart_items#cancel"
  get "/success", to: "cart_items#success_page"
  

  post "/cash_on_dilevery", to: "cart_items#cash_on_dilevery"

  get "/cart_items_razor_success", to: "cart_items#cart_items_razor_success"

  get "/destroy/:product_id", to: "cart_items#destroy"

  get "/orders", to: "orders#index"
  get "/cancel/:order_id", to: "orders#cancel"


  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
