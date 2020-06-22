# frozen_string_literal: true

class Suica
  MINIMUM_CHARGE_MONEY = 100
  attr_reader :charged_money_amount, :user_age, :user_sex, :bought_time
  def initialize(charge: 0, age: 0, sex: "男性")
    @charged_money_amount = charge
    @user_age = age
    @user_sex = sex
    @bought_time =  Time.now
  end

  def charge(money)
    return nil if money < MINIMUM_CHARGE_MONEY
    @charged_money_amount += money
  end

  def pay(money)
    @charged_money_amount -= money
  end
end
