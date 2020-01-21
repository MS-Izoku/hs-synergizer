class IndexController < ApplicationController
    def landing
        decks = Deck.all[0..8]
        render json: decks
    end
end