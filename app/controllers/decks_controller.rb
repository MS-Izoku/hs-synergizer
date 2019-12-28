# frozen_string_literal: true

class DecksController < ApplicationRecord
  def show
    deck = Deck.find_by(id: params[:id])
    options = {}
    render json: DeckSerializer.new(deck, options)
  end

  def create
    # requires an array of dbf_ids
    deck = Deck.find_by(id: params[:id])
    options = {}
    if deck.nil?
      render json: { error: 'Deck Not Found' }, status: 404
    else
      render json: DeckSerializer.new(deck, options)
      end
  end

  def update

  end

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
  def deck_params
    params.require(:deck).permit(:deck_code)
  end
end
