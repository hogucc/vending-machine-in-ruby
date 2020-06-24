# frozen_string_literal: true

require "./lib/drink"

class VendingMachine
  attr_reader :sales_amount, :sales_histories

  def initialize
    @stocks = {}
    add_stocks(Drink.coke)
    add_stocks(Drink.redbull)
    add_stocks(Drink.water)
    @sales_amount = 0
    @sales_histories = []
  end

  def current_stocks
    @stocks.values.map do |drinks|
      drink = drinks.first
      next if drink.nil?
      { name: drink.name, price: drink.price, stock: drinks.count }
    end.compact
  end

  def buy_drink(name, suica)
    return nil unless stock_available?(name)
    price = @stocks[name].first.price
    return nil unless suica.payable?(price)
    save_sales_history(@stocks[name].first.name, suica)
    drink = @stocks[name].shift
    @sales_amount += price
    suica.pay(price)
    drink
  end

  def stock_available?(name)
    @stocks[name].size > 0
  end

  def save_sales_history(drink_name, suica)
    data = {
      drink_name: drink_name,
      sold_at: Time.now,
      user_age: suica.user_age,
      user_sex: suica.user_sex
    }
    @sales_histories << data
  end

  private
    def add_stocks(drink, count: 5)
      count.times do
        unless @stocks[drink.name]
          @stocks[drink.name] = []
        end
        @stocks[drink.name] << drink
      end
    end
end
