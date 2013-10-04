require 'minitest/autorun'
require_relative 'calculator'
require 'purdytest'

class TestCalculator < MiniTest::Test

  def test_addition
    calculator = Calculator.new
    result = calculator.add(1,2)
    
    assert_equal 3, result
  end

end