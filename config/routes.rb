# require 'sidekiq/web'
# require 'sidekiq-scheduler/web'
# require_relative '../lib/middlewares/static_token_auth'

Rails.application.routes.draw do
  # Sidekiq::Web.use StaticTokenAuth
  # mount Sidekiq::Web => '/sidekiq/:token'

  mount_devise_token_auth_for 'User', at: 'auth/v1/user'

  namespace :admin, defaults: { format: :json } do
    namespace :v1 do
      get "home" => "home#index"
      resources :categories, only: [:index, :show, :create, :update, :destroy]
      resources :coupons
      resources :games, only: [], shallow: true do
        resources :licenses
      end
      resources :orders, only: [:index, :show]
      resources :products
      resources :system_requirements
      resources :users

      namespace :dashboard do
        resources :sales_ranges, only: :index
        resources :summaries, only: :index
        resources :top_five_products, only: :index
      end
    end
  end

  namespace :storefront, defaults: { format: :json } do
    namespace :v1 do
      get "home" => "home#index"
      resources :products, only: [:index, :show]
      resources :categories, only: :index
      post "/coupons/:coupon_code/validations", to: "coupon_validations#create"
      resources :checkouts, only: :create
      resources :games, only: :index
      resources :orders, only: [:index, :show]
      resources :wish_items, only: [:index, :create, :destroy]
    end
  end

  namespace :juno do
    namespace :v1 do
      resources :payment_confirmations, only: :create
    end
  end
end


# Rails.application.routes.draw do
#   mount_devise_token_auth_for 'User', at: 'auth/v1/user'
#   namespace :admin do
#     namespace :v1 do
#       get "home" => "home#index"
#     end
#   end
#   namespace :storefront do
#     namespace :v1 do
#     end
#   end
#   # root 'home#index' # Substitua 'home#index' pelo controlador e ação que você deseja
# end
