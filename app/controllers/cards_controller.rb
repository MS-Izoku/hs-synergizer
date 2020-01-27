# frozen_string_literal: true

class CardsController < ApplicationController
  def index
    cards = Card.joins(:card_set).where(collectable: true).where.not(card_sets: { name: ['NYI', 'Hero Classes', 'Token'] })
    cards = cards.paginate(page: params[:page])
    #render json: { cards: CardSerializer.new(cards), page_count: cards.total_pages }
    render json: create_paginated_json(cards)
  end

  def wild_cards
    cards = Card.wild_cards.paginate(page: params[:page], per_page: index_pagination_count(1))
    render json: CardSerializer.new(cards)
  end

  def standard_cards
    # cards = Card.standard_cards.paginate(page: params[:page], per_page: index_pagination_count(1))
    cards = Card.standard_cards.paginate(page: params[:page])
    render json: CardSerializer.new(cards)
  end

  def standard_cards_by_mechanic
    cards = CardMechanic.where(mechanic_id: params[:id]).cards
    # cards = cards.paginate(page: params[:page], per_page: index_pagination_count(20))
    # render json: CardSerializer.new(cards)
    render_if_cards_exist(cards, index_pagination_count(1))
  end

  def standard_spells
    cards = Card.standard_cards
    if !cards
      render json: { error: 'No Cards Found' }, status: 404
    else
      render json: cards
    end
  end

  def show
    card = Card.find_by(id: params[:id])
    if !card
      render json: { error: 'Card Not Found' }, status: 404
    else
      render json: CardSerializer.new(card)
    end
  end

  private

  # a quick helper method to get x many pages, given that 8 is standard
  def index_pagination_count(pages)
    8 * pages
  end

  def create_paginated_json(cards)
    {
      cards: CardSerializer.new(cards),
      page_count: cards.total_pages,
      page: params[:page]
    }
  end
end
