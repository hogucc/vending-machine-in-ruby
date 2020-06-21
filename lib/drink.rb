# frozen_string_literal: true

class Drink
  def initialize
    @drink = { coke: { name: "コーラ", price: 120, stock: 5 },
               redbull: { name: "レッドブル", price: 200, stock: 5 },
               water: { name: "水", price: 100, stock: 5 }
             }
  end

  def name(target)
    @drink[target][:name]
  end

  def price(target)
    @drink[target][:price]
  end

  def stock(target)
    @drink[target][:stock]
  end

  def minus_stock(target)
    @drink[target][:stock] -= 1
  end
end
