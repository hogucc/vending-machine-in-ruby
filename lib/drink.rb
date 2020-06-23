# frozen_string_literal: true

class Drink
  attr_accessor :name, :price

  def initialize(name, price)
    @name = name
    @price = price
  end

  def self.coke
    self.new("coke", 120)
  end

  def self.redbull
    self.new("redbull", 200)
  end

  def self.water
    self.new("water", 100)
  end
end
