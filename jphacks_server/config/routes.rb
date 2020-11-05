Rails.application.routes.draw do
  resources :materials, param: :uuid do
    resources :comments, only: %i[index]
  end
  root to: 'home#index'

  namespace :api, format: "json" do
    resources :materials, only: %i[show], param: :uuid do
      resources :comments, only: %i[index create], param: :uuid do
        post :plus
      end
      resources :impressions, only: %i[create]
    end
  end
end
