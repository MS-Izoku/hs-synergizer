class DecksController < ApplicationRecord
    def index
        render json: DeckSerializer.new(Deck.all)
    end
    
    def show
        deck = Deck.find_by(id: params[:id])
        # cards = Deck.
        render json: DeckSerializer.new(deck , options)
    end
end