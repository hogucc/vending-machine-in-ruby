require 'minitest/autorun'
require './lib/vending_machine'
require './lib/suica'

class VendingMachineTest < Minitest::Test
  def setup
    @machine = VendingMachine.new
  end
  
  def test_step_1_get_current_stocks
    expected = [
      { name: "coke", price: 120, stock: 5 }
    ]
    assert_equal expected, @machine.current_stocks
  end

  def test_step_2_can_buy_drink
    suica = Suica.new(charge: 120, age: 10, sex: "男性")
    drink = @machine.buy_drink("coke", suica)
    assert_equal "coke", drink.name
    expected = [
      {
        name: "coke",
        price: 120,
        stock: 4,
      }
    ]
    assert_equal expected, @machine.current_stocks
    assert_equal 120, @machine.sales_amount
    assert_equal 0, suica.charged_money_amount
  end

  def test_step2_cannot_buy_due_to_charged_money_not_enough
    suica = Suica.new(charge: 119, age: 10, sex: "男性")
    assert_nil @machine.buy_drink("coke", suica)

    expected = [
      {
        name: "coke",
        price: 120,
        stock: 5,
      }
    ]

    assert_equal expected, @machine.current_stocks
    assert_equal 0, @machine.sales_amount
    assert_equal 119, suica.charged_money_amount
  end

  def test_step2_cannot_buy_due_to_stock_not_available
    assert @machine.stock_available?("coke")
    suica = Suica.new(charge: 10000, age: 10, sex: "男性")
    @machine.buy_drink("coke", suica)
    @machine.buy_drink("coke", suica)
    @machine.buy_drink("coke", suica)
    @machine.buy_drink("coke", suica)
    assert @machine.stock_available?("coke")
    @machine.buy_drink("coke", suica)
    refute @machine.stock_available?("coke")
    assert_nil @machine.buy_drink("coke", suica)
    assert_equal 600, @machine.sales_amount
    assert_equal 9400, suica.charged_money_amount
    assert_equal [], @machine.current_stocks
  end
end
