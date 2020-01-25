# frozen_string_literal: true

class DecksController < ApplicationRecord
  skip_before_action :authorized , only: [:show]
  def show
    deck = Deck.find_by(id: params[:id])
    options = {}
    render json: DeckSerializer.new(deck, options)
  end

  def create
    deck = Deck.new

    options = {
      include: %i[cards player_class]
    }
    if deck.save
      render DeckSerializer.new(deck, options)
    else
      render json: {error: "Deck was unable to be created"} , status: 400
    end
  end

  def create_from_deck_code
    deck = Deck.new_create_deck_from_code(params[:deck_code])
    render json: DeckSerializer.new(deck, options)
  end

  def update; end

  def delete
    deck = Deck.find_by(id: params[:id])
    options = {}
    if deck.nil?
      render json: { error: 'Deck Not Found' }, status: 404
    else
      render json: DeckSerializer.new(deck, options)
    end
  end

  private

  def deck_options
    { include: %i[cards player_class] }
  end

  def deck_params
    params.require(:deck).permit(:deck_code)
  end
end
