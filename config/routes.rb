Rails.application.routes.draw do

  devise_for :users, controllers: {
  omniauth_callbacks: 'users/omniauth_callbacks',
  registrations: 'users/registrations',
  sessions: 'users/sessions'
  }
  devise_scope :user do
    post '/users/sign_out' => 'devise/sessions#destroy'
  end

  root 'items#index'
  resources :items do
    resources :likes, only: [:create, :destroy]
    get :confirmation
    post 'pay', to: 'items#pay'
    get :done
  end
  
  resources :items, only: :show_mypage, path: "m:id" do
    collection do
      get 'show_mypage'
      get :exhibition_suspension
    end
  end
 
  namespace :api do
    resources :items, only: :new, defaults: { format: 'json' }
    get '/items/new_delivery', to: 'items#new_delivery', defaults: { format: 'json' }
  end

  resources :users, only: [:show, :new] do
    get :compilation
    get :identification
    get :logout
  end
  
  resources :signups, only: [:index] do
    collection do
      get 'user_information' #情報の一部を入力
      post 'user_information', to: 'signups#user_information_validates' #入力した情報のバリデーションチェック
      get 'phone_number_verification' #残りの情報を入力
      post 'phone_number_verification',to: 'signups#create' #入力した情報を保存
      get 'done'
    end
  end

  resources :cards,only:[:index,:new,:show]do
    collection do
      get 'index',to: 'cards#index'
      post 'pay', to: 'cards#pay'
      post 'delete', to: 'cards#delete'
      post 'show', to: 'cards#show'
    end
  end
    
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
