# frozen_string_literal: true

class Drink
  attr_accessor :name, :price

  def initialize(name, price)
    @name = name
    @price = price
  end

  def self.define_drink(name, price)
    define_singleton_method(name) do
      new(name, price)
    end
  end

  define_drink("coke", 120)
  define_drink("redbull", 200)
  define_drink("water", 100)
end
