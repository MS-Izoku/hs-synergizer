# frozen_string_literal: true

class Tribe < ApplicationRecord
  has_many :cards

  def self.names
    names = []
    Tribe.all.collect do |tribe|
      names.push(tribe.name)
    end
    return names
  end
end
