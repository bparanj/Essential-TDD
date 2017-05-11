require 'minitest/autorun'

class ReverseDigit
  def initialize(n)
    @n = n
  end

  def reverse
    reversed_digit = extract_rightmost_digit

    until all_digits_reversed?
      remove_rightmost_digit
      reversed_digit = reversed_digit * 10 + extract_rightmost_digit
    end
    reversed_digit
  end

  private

  def extract_rightmost_digit
    @n % 10
  end

  def remove_rightmost_digit
    @n = @n / 10
  end

  def all_digits_reversed?
    (@n / 10) == 0
  end
end

describe ReverseDigit do
  it 'should return the same number for single digit number' do
    rd = ReverseDigit.new(1)
    result = rd.reverse
    assert_equal 1, result
  end  
    
  it 'should return the reversed number for a two digit number' do
    rd = ReverseDigit.new(15)
    result = rd.reverse
    assert_equal 51, result
  end  
  
  it 'should return 897 for 798' do
    rd = ReverseDigit.new(798)
    result = rd.reverse
    assert_equal 897, result
  end
  
  it 'should return 51897 for 79815' do
    rd = ReverseDigit.new(79815)
    result = rd.reverse
    assert_equal 51897, result
  end
end