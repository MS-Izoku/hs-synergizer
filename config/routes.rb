Rails.application.routes.draw do
  resources :cards , only: [:index]
  get '/standard_cards' , to: 'cards#standard_cards'
  get '/wild_cards' , to: 'cards#wild_cards'

  get '/cards/:id' , to: 'cards#show'
end
