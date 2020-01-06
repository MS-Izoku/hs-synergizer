class SavedDecksController < ApplicationController
  def create
    render json: {message: "Deck Creation Success"} , status: :created unless check_for_deck.nil?
  end

  def delete
    saved_deck = check_for_deck
    unless saved_deck.nil?
      saved_deck.delete
      render json: saved_deck.to_json
    end
      render json: {error: saved_deck.error , message: "Deck Not Found"} , status: 404
  end

  private
  def check_for_deck
    user = User.find_by(id: params[:user_id])
    deck = Deck.find_by(id: params[:deck_id])
    if user && deck && !SavedDeck.find_by(user_id: user.id , deck_id: deck.id).nil?
      saved_deck = SavedDeck.create(user_id: user.id , deck_id: deck.id)
      saved_deck
    end
  end
end