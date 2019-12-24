# frozen_string_literal: true

Rails.application.routes.draw do
  resources :cards, only: [:index]
  get '/standard-cards', to: 'cards#standard_cards'
  get '/wild-cards', to: 'cards#wild_cards'

  get '/standard-cards/by-mechanic/:id', to: 'cards#standard_cards_by_mechanic', as: 'standard_by_mechanic'
  get '/standard-cards/by-tribe/:id', to: 'cards#standard_cards_by_tribe', as: 'standard_by_tribe'
  get '/standard-cards/spells', to: 'cards#standard_spells', as: 'standard_spells'

  get '/cards/:id', to: 'cards#show'

  resources :mechanics, only: %i[index show]
  resources :cards , only: [:index , :show]
  resourees :deck
end
