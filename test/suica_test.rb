require 'minitest/autorun'
require './lib/suica'

class SuicaTest < Minitest::Test
  def setup
    @suica = Suica.new(charge: 1000, age: 10, sex: "男性")
  end

  def test_step_0_succeeded_charge
    assert_equal 1100, @suica.charge(100)
  end

  def test_step_0_failed_charge
    assert_nil @suica.charge(99)
  end

  def test_step_0_get_charged_money_amount
    assert_equal 1000, @suica.charged_money_amount
  end

  def test_step4_get_user_age
    assert_equal 10, @suica.user_age
  end

  def test_step4_get_user_sex
    assert_equal "男性", @suica.user_sex
  end
end
