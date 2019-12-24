# frozen_string_literal: true

class CardsController < ApplicationController
  def index
    cards = Card.all
    render json: CardSerializer.new(cards)
  end

  def wild_cards
    cards = Card.wild_cards
    render json: CardSerializer.new(cards)
  end

  def standard_cards
    cards = Card.standard_cards
    render json: CardSerializer.new(cards)
  end

  def standard_cards_by_mechanic
    cards = CardMechanic.where(mechanic_id: params[:id]).cards
    render json: CardSerializer.new(cards)
  end

  def standard_spells
    cards = CardSet.where(standard: true).cards.where(card_type: "Spell")
    render json: CardSerializer.new(cards)
  end

  def show
    card = Card.find_by(id: params[:id])
    if !card
      render json: { error: "Card Not Found" }, status: 404
    else
      render json: CardSerializer.new(card)
    end
  end
end
