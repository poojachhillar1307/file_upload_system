Rails.application.routes.draw do
  devise_for :users
  root to: "files#index"
  
  resources :files do
    member do
      get 'share'
    end
  end
end
