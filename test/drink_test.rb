require 'minitest/autorun'
require './lib/drink'

class DrinkTest < Minitest::Test
  def test_coke
    drink = Drink.coke
    assert_equal "coke", drink.name
    assert_equal 120, drink.price
  end
end
