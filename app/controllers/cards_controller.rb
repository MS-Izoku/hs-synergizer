# frozen_string_literal: true

class CardsController < ApplicationController
  def index
    cards = Card.all
    render json: cards.to_json
  end

  def wild_cards
    cards = Card.wild_cards
    render json: cards.to_json
  end

  def standard_cards
    cards = Card.standard_cards
    render json: cards.to_json
  end
end
