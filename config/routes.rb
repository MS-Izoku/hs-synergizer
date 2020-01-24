# frozen_string_literal: true

Rails.application.routes.draw do
  use_doorkeeper
  # resources :users
  #get '/users/profile' , to: 'users#profile'
  #post '/users' , to: '/users#create'

  get '/cards/standard', to: 'cards#standard_cards' , as: 'standard_cards'
  get '/standard/by-mechanic/:id', to: 'cards#standard_cards_by_mechanic', as: 'standard_by_mechanic'
  get '/standard/by-tribe/:id', to: 'cards#standard_cards_by_tribe', as: 'standard_by_tribe'
  get '/standard/spells', to: 'cards#standard_spells', as: 'standard_spells'

  get '/cards/wild', to: 'cards#wild_cards' , as: 'wild_cards'
  get '/wild/by-mechanic/:id', to: 'cards#wild_cards_by_mechanic', as: 'wild_by_mechanic'
  get '/wild/by-tribe/:id', to: 'cards#wild_cards_by_tribe', as: 'wild_by_tribe'
  get '/wild/spells', to: 'cards#wild_spells', as: 'wild_spells'

  get 'cards/index/:page' , to: 'cards#index'

  #resources :cards , only: [:index , :show]
  resources :mechanics, only: %i[index show]
  resources :keyword , only: [:index , :show]
  
  resources :deck , except: [:index , :edit , :new]
  #resources :tribe , except: [:new , :create , :update , :edit]

end
