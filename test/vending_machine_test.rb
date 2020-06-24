# frozen_string_literal: true

require "minitest/autorun"
require "./lib/vending_machine"
require "./lib/suica"
require "timecop"

class VendingMachineTest < Minitest::Test
  def setup
    @machine = VendingMachine.new
  end

  def test_step_1_get_current_stocks
    expected = [
      { name: "coke", price: 120, stock: 5 },
      { name: "redbull", price: 200, stock: 5 },
      { name: "water", price: 100, stock: 5 }
    ]
    assert_equal expected, @machine.current_stocks
  end

  def test_step_2_can_buy_coke
    suica = Suica.new(charge: 120, age: 10, sex: :male)
    drink = @machine.buy_drink("coke", suica)
    assert_equal "coke", drink.name
    expected = [
      { name: "coke", price: 120, stock: 4 },
      { name: "redbull", price: 200, stock: 5 },
      { name: "water", price: 100, stock: 5 }
    ]
    assert_equal expected, @machine.current_stocks
    assert_equal 120, @machine.sales_amount
    assert_equal 0, suica.charged_money_amount
  end

  def test_step2_cannot_buy_due_to_charged_money_not_enough
    suica = Suica.new(charge: 119, age: 10, sex: :male)
    assert_nil @machine.buy_drink("coke", suica)

    expected = [
      { name: "coke", price: 120, stock: 5 },
      { name: "redbull", price: 200, stock: 5 },
      { name: "water", price: 100, stock: 5 }
    ]

    assert_equal expected, @machine.current_stocks
    assert_equal 0, @machine.sales_amount
    assert_equal 119, suica.charged_money_amount
  end

  def test_step2_cannot_buy_due_to_stock_not_available
    assert @machine.stock_available?("coke")
    suica = Suica.new(charge: 10000, age: 10, sex: :male)
    4.times do
      @machine.buy_drink("coke", suica)
    end

    assert @machine.stock_available?("coke")
    @machine.buy_drink("coke", suica)
    assert_equal @machine.stock_available?("coke"), false
    assert_nil @machine.buy_drink("coke", suica)
    assert_equal 600, @machine.sales_amount
    assert_equal 9400, suica.charged_money_amount
    assert_equal [
      { name: "redbull", price: 200, stock: 5 },
      { name: "water", price: 100, stock: 5 }
    ], @machine.current_stocks
  end

  def test_step_3_get_avaliable_drink_list_after_bought_5_coke
    suica = Suica.new(charge: 10000, age: 10, sex: :male)
    5.times do
      @machine.buy_drink("coke", suica)
    end
    expected = [
      { name: "redbull", price: 200, stock: 5 },
      { name: "water", price: 100, stock: 5 }
    ]
    assert_equal expected, @machine.current_stocks
  end

  def test_step_3_can_buy_redbull
    suica = Suica.new(charge: 200, age: 10, sex: :male)
    drink = @machine.buy_drink("redbull", suica)
    assert_equal "redbull", drink.name
    expected = [
      { name: "coke", price: 120, stock: 5 },
      { name: "redbull", price: 200, stock: 4 },
      { name: "water", price: 100, stock: 5 }
    ]
    assert_equal expected, @machine.current_stocks
    assert_equal 200, @machine.sales_amount
    assert_equal 0, suica.charged_money_amount
  end

  def test_step_3_can_buy_water
    suica = Suica.new(charge: 100, age: 10, sex: :male)
    drink = @machine.buy_drink("water", suica)
    assert_equal "water", drink.name
    expected = [
      { name: "coke", price: 120, stock: 5 },
      { name: "redbull", price: 200, stock: 5 },
      { name: "water", price: 100, stock: 4 }
    ]
    assert_equal expected, @machine.current_stocks
    assert_equal 100, @machine.sales_amount
    assert_equal 0, suica.charged_money_amount
  end

  def test_step_5_get_sales_histories
    time_1 = Time.now
    Timecop.freeze(time_1) do
      suica = Suica.new(charge: 120, age: 10, sex: :male)
      @machine.buy_drink("coke", suica)
      sales_histories = @machine.sales_histories
      expected = [
        { drink_name: "coke", sold_at: time_1, user_age: 10, user_sex: :male }
      ]
      assert_equal expected, sales_histories
    end

    time_2 = time_1 + 60
    Timecop.freeze(time_2) do
      suica = Suica.new(charge: 1000, age: 25, sex: :female)
      @machine.buy_drink("water", suica)
      sales_histories = @machine.sales_histories
      expected = [
        { drink_name: "coke", sold_at: time_1, user_age: 10, user_sex: :male },
        { drink_name: "water", sold_at: time_2, user_age: 25, user_sex: :female }
      ]
      assert_equal expected, sales_histories
    end

    time_3 = time_2 + 60
    Timecop.freeze(time_3) do
      suica = Suica.new(charge: 0, age: 5, sex: :male)
      @machine.buy_drink("redbull", suica)
      sales_histories = @machine.sales_histories
      expected = [
        { drink_name: "coke", sold_at: time_1, user_age: 10, user_sex: :male },
        { drink_name: "water", sold_at: time_2, user_age: 25, user_sex: :female }
      ]
      assert_equal expected, sales_histories
    end
  end
end
