# frozen_string_literal: true

class Suica
  attr_reader :charge, :user_age, :user_sex, :bought_time
  def initialize(charge: 0, age: 0, sex: "男性")
    @charge = charge
    @user_age = age
    @user_sex = sex
    @bought_time =  Time.now
  end

  def plus_charge(price)
    if price >= 100
      @charge += price
    else
      puts "100円未満はチャージできません"
    end
  end

  def minus_charge(price)
    @charge -= price
  end
end
