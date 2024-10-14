Rails.application.routes.draw do
  get 'password_resets/new'
  get 'password_resets/edit'
  get 'sessions/new'
  resources :users do
    collection do
      get :search  # or post :search if you're using POST method
    end
    member do
      get :following, :followers
      get :liking
    end
  end
  resources :account_activations, only: [:edit]
  resources :password_resets
  resources :microposts, only: [:create, :destroy, :edit] do
    collection do
      get :filter  # or post :search if you're using POST method
    end
    member do
      get :micropost_liking 
    end
  end
  resources :relationships, only: [:create, :destroy]
  resources :likes, only: [:create, :destroy], defaults: { format: :js }
  #resources :active_likes, only: [:create, :destroy]
  post '/users/3', to: 'microposts#create'
  post '/home', to: 'microposts#create'
  # scope module: 'admin' do
  #   resources :users
  # end
  #get '/users_destroy', to: 'users#destroy'
  #root 'users#index'

  get 'help', to: 'static_pages#help'
  get 'home', to: 'static_pages#home'
  get 'about', to: 'static_pages#about'
  root 'static_pages#home'

  get 'signup', to: 'users#new'
  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  get '/logout', to: 'sessions#destroy'
end
