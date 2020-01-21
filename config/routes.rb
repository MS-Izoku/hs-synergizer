# frozen_string_literal: true

Rails.application.routes.draw do
  resources :forum_threads
  #use_doorkeeper
  # resources :users
  #get '/users/profile' , to: 'users#profile'
  #post '/users' , to: '/users#create'

  get '/home' , to: 'index#landing'

  get '/cards/index/:page', to: 'cards#index'
  scope '/cards/standard' do
    get '/', to: 'cards#standard_cards'
    get 'by_mechanic/mechanic_name:', to: 'cards#standard_cards_by_mechanic'
    get '/by-tribe/:tribe_name', to: 'cards#standard_cards_by_tribe'
    get '/spells', to: 'cards#standard_spells'
  end

  scope '/cards/wild' do
    get '/', to: "cards#wild_cards"
    get '/by-mechanic/:id', to: 'cards#wild_cards_by_mechanic'
    get '/by-tribe/:id', to: 'cards#wild_cards_by_tribe'
    get '/spells', to: 'cards#wild_spells'
  end

  get '/cards/:id' , to: 'cards#show'

  resources :mechanics, only: %i[index show]
  resources :keyword , only: [:index , :show]
  
  resources :deck , except: [:index , :update , :create]

  resources :saved_deck , only: [:create , :delete]
end
