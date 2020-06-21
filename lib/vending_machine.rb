# frozen_string_literal: true

class VendingMachine
  def initialize
    @drink = Drink.new
    @sales = 0
    @sales_histories = []
  end

  def buy_drink(drink_type, suica)
    if can_buy_drink?(drink_type, suica)
      price = @drink.price(drink_type)
      @drink.minus_stock(drink_type)
      plus_sales(price)
      suica.minus_charge(price)
      update_sales_history(@drink.name(drink_type), suica)
      puts "売り上げ金額:#{@sales}、飲み物の在庫：#{@drink.stock(drink_type)}、suicaの残高は#{suica.charge}円です。"
    end
  end

  def sales_history
    @sales_histories.each do |history|
      puts "#{history[:bought_time]}に#{history[:drink_name]}が購入されました。買った人：#{history[:user_age]}歳 #{history[:user_sex]}"
    end
  end

  private
    def update_sales_history(drink_name, suica)
      @sales_histories << { drink_name: drink_name, bought_time: suica.bought_time, user_age: suica.user_age, user_sex: suica.user_sex }
    end

    def can_buy_drink?(drink_type, suica)
      if suica.charge < @drink.price(drink_type)
        puts "残高が足りません"
        false
      elsif @drink.stock(drink_type) == 0
        puts "品切れ中です"
        false
      else
        true
      end
    end

    def plus_sales(price)
      @sales += price
    end
end
