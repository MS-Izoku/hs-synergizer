# frozen_string_literal: true

class CardsController < ApplicationController
  def index
    cards = Card.all
    #render json: CardSerializer.new(cards)
    card_check(cards)
  end

  def wild_cards
    cards = Card.wild_cards
    card_check(cards)
    #render json: CardSerializer.new(cards)
  end

  def standard_cards
    cards = Card.standard_cards
    render json: CardSerializer.new(cards)
  end

  def standard_cards_by_mechanic
    cards = Card.all_by_mechanic(params[:name] , true)
    card_check(cards)
  end

  def standard_spells
    cards = Card.standard_cards
    card_check(cards)
  end

  def wild_cards_by_mechanic
    cards = Card.all_by_mechanic(params[:name] , false)
    card_check(cards)
  end

  def show
    card = Card.find_by(id: params[:id])
    card_check(card)
  end

  private

  def card_check(cards , options={})
    if !cards
      render json: {error: "No Cards Found"} , status: 404
    else
      render json: CardSerializer.new(cards , options)
    end
  end

end
