# frozen_string_literal: true

class Suica
  MINIMUM_CHARGE_MONEY = 100

  attr_reader :charged_money_amount, :user_age, :user_sex, :bought_time

  def initialize(charge: 0, age: nil, sex: nil)
    @charged_money_amount = charge
    @user_age = age
    @user_sex = sex
  end

  def charge(money)
    return nil if money < MINIMUM_CHARGE_MONEY

    @charged_money_amount += money
  end

  def pay(money)
    raise "残高が足りません" unless self.payable?(money)
    @charged_money_amount -= money
  end

  def payable?(money)
    @charged_money_amount >= money
  end
end
