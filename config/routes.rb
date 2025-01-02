Rails.application.routes.draw do
  mount_devise_token_auth_for 'User', at: 'auth/v1/user'

  namespace :admin do
    namespace :v1 do
      get "home" => "home#index"
    end
  end

  namespace :storefront do
    namespace :v1 do
    end
  end

  # root 'home#index' # Substitua 'home#index' pelo controlador e ação que você deseja
end