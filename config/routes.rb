EliminationCircle::Application.routes.draw do
  root 'pages#home'
  get '/ideas' => "pages#ideas"
  
  get '/signup' => "users#new"
  get '/signin' => "sessions#new"
  post '/signin' => "sessions#create"
  delete '/signout' => "sessions#destroy"
  
  resources :users, except: [:index, :new, :destroy]
  resources :games, except: [:index, :edit, :update] do
    member do
      get 'register' # Register a player for this game 
      post 'launch'  # Launch a game that was not pre-registered
      delete 'kill'  # Eliminate a player from this game
      delete 'remove_player/:profile_id/', # Remove a player from this game
             :action => 'remove_player'    # (assuming game has not yet begun)
    end
  end
end
