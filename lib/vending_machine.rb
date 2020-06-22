# frozen_string_literal: true

require "./lib/drink"

class VendingMachine
  attr_reader :sales_amount

  def initialize
    @stocks = {}
    add_stocks(Drink.coke)
    add_stocks(Drink.redbull)
    add_stocks(Drink.water)
    @sales_amount = 0
    @sales_histories = []
  end

  def current_stocks
    @stocks.map do |name, drinks|
      drink = drinks.first
      next if drink.nil?
      { name: drink.name, price: drink.price, stock: drinks.count}
    end.compact
  end

  def buy_drink(name, suica)
    return nil unless stock_available?(name)
    price = @stocks[name].first.price
    return nil if suica.charged_money_amount < price
    update_sales_history(@stocks[name].first.name, suica)
    drink = @stocks[name].shift
    plus_sales(price)
    suica.pay(price)
    drink
  end

  def stock_available?(name)
    @stocks[name].size > 0
  end

  def sales_history
    @sales_histories.each do |history|
      puts "#{history[:bought_time]}に#{history[:drink_name]}が購入されました。買った人：#{history[:user_age]}歳 #{history[:user_sex]}"
    end
  end

  private
    def add_stocks(drink)
      5.times do
        unless @stocks[drink.name]
          @stocks[drink.name] = []
        end
        @stocks[drink.name] << drink
      end
    end

    def update_sales_history(drink_name, suica)
      @sales_histories << { drink_name: drink_name, bought_time: suica.bought_time, user_age: suica.user_age, user_sex: suica.user_sex }
    end

    def plus_sales(price)
      @sales_amount += price
    end
end
