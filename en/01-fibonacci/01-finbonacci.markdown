# Fibonacci #

## Objectives ##

- To learn TDD Cycle : Red, Green, Refactor.
- Focus on getting it to work first, cleanup by refactoring and then focus on optimization.
- When refactoring, start green and end in green.
- Learn recursive solution and optimize the execution by using non-recursive solution.
- Using existing tests as regression tests when making major changes to existing code.

## Problem Statement ##

In mathematics, the Fibonacci numbers are the numbers in the following integer sequence:
0, 1, 1, 2, 3, 5, 8, 13, 21, 34, 55, 89, 144…

![Fibonacci Numbers](../figures/FibonacciTable.png)

## Solution ##

By definition, the first two numbers in the Fibonacci sequence are 0 and 1, and each subsequent number is the sum of the previous two.

## Algebraic Equation ##

In mathematical terms, the sequence fibonacci(n) of Fibonacci numbers is defined by the recurrence relation fibonacci(n) = fibonacci(n-1) + fibonacci(n-2) with seed values fibonacci(0) = 0, fibonacci(1) = 1
 
## Visual Representation ##

![Fibonacci Numbers](../figures/pascal_fibo3.jpg)

![Calculating Fibonacci Numbers](../figures/fibonacci.png)

## Guidelines ##

1. Each row in the table is an example. Make each example executable.

Input    Output
-----    ------
  0         0
  1         1
  2         1
  3         2
  4         3
  5         5

2. The final solution should be able to take any random number and calculate the Fibonacci number without any modification to the production code.

## Version 0 ##

```ruby
require 'test/unit'

class FibonacciTest < Test::Unit::TestCase
  def test_fibonacci_of_zero_is_zero
    fail "fail"
  end
end
```

Got proper require to execute the test. Proper naming of test following naming convention.

This example illustrates how to convert Requirements --> Examples --> Executable Specs. Each test for this problem takes an argument, does some computation and returns a result. It illustrates Direct Input and Direct Output. There are no side effects. Side effect free functions are easy to test. 

## Discovery of Public API ##
### Version 1 ###

finonacci_test.rb

```ruby
require 'test/unit'

class Fibonacci
  def self.of(number)
    0
  end
end

class FibonacciTest < Test::Unit::TestCase
  def test_fibonacci_of_zero_is_zero
    fib_of_zero = Fibonacci.of(0)
    assert_equal(fib_of_zero, 0)
  end
end
```

## Don't Change the Test code and Code Under Test at the Same Time ##
### Version 2 ###
```ruby
require 'test/unit'

class Fibonacci
  def self.of(number)
    0
  end
end

class FibonacciTest < Test::Unit::TestCase
  def test_fibonacci_of_zero_is_zero
    fib_of_zero = Fibonacci.of(0)
    assert_equal(0, fib_of_zero)
  end
end
```

Found the right assertion to use.Overcame the temptation to change the test code and code under test at the same time.Thereby test driving the development of the production code.Got the test to pass quickly by using a fake implementation.The implementation returns a constant.

## Dirty Implementation ##
### Version 4 ###
Made fib(1) = 1 pass very quickly using a dirty implementation.

```ruby
require 'test/unit'

class Fibonacci
  def self.of(number)
    number
  end
end

class FibonacciTest < Test::Unit::TestCase
  def test_fibonacci_of_zero_is_zero
    fib_of_zero = Fibonacci.of(0)
    assert_equal(0, fib_of_zero)
  end
  
  def test_fibonacci_of_one_is_one
    fib_of_one = Fibonacci.of(1)
    assert_equal(1, fib_of_one)
  end
end
```

## Forcing the Implementation to Change via Tests ##
### Version 5 ###
Broken test forced the implementation to change. Dirty implementation passes the test.

```ruby
require 'test/unit'

class Fibonacci
  def self.of(number)
    if number == 2
      return 1
    else
      return number
    end
  end
end

class FibonacciTest < Test::Unit::TestCase
  def test_fibonacci_of_zero_is_zero
    fib_of_zero = Fibonacci.of(0)
    assert_equal(0, fib_of_zero)
  end
  
  def test_fibonacci_of_one_is_one
    fib_of_one = Fibonacci.of(1)
    assert_equal(1, fib_of_one)
  end
  
  def test_fibonacci_of_two_is_one
    fib_of_two = Fibonacci.of(2)
    assert_equal(1, fib_of_two)
  end
end
```

## Refactoring in the Green State ##
### Version 6 ###
The new test broke the implementation. Commented out the new test to refactor the test in green state. This code is ready to be generalized.

```ruby
require 'test/unit'

class Fibonacci
  def self.of(number)
    if number == 0
      return 0
    elsif number <= 2
      return 1
    end
  end
end

class FibonacciTest < Test::Unit::TestCase
  def test_fibonacci_of_zero_is_zero
    fib_of_zero = Fibonacci.of(0)
    assert_equal(0, fib_of_zero)
  end
  
  def test_fibonacci_of_one_is_one
    fib_of_one = Fibonacci.of(1)
    assert_equal(1, fib_of_one)
  end
  
  def test_fibonacci_of_two_is_one
    fib_of_two = Fibonacci.of(2)
    assert_equal(1, fib_of_two)
  end
  
  def xtest_fibonacci_of_three_is_two
    fib_of_three = Fibonacci.of(3)
    assert_equal(2, fib_of_three)
  end
end
```

## Generalized Solution ##
### Version 7 ###
Input    Output
-----    ------
  0         0
  1         1
  2         1
  3         2

So the pattern emerges and we see the result is the sum of previous to fibonacci numbers return 2 is actually return 1 + 1 which from the above table is fib(n-1) + fib(n-2), so the solution is fib(n-1) + fib(n-2)

```ruby
require 'test/unit'

class Fibonacci
  def self.of(number)
    if number == 0
      return 0
    elsif number <= 2
      return 1
    end
    return 2
  end
end

class FibonacciTest < Test::Unit::TestCase
  def test_fibonacci_of_zero_is_zero
    fib_of_zero = Fibonacci.of(0)
    assert_equal(0, fib_of_zero)
  end
  
  def test_fibonacci_of_one_is_one
    fib_of_one = Fibonacci.of(1)
    assert_equal(1, fib_of_one)
  end
  
  def test_fibonacci_of_two_is_one
    fib_of_two = Fibonacci.of(2)
    assert_equal(1, fib_of_two)
  end
  
  def test_fibonacci_of_three_is_two
    fib_of_three = Fibonacci.of(3)
    assert_equal(2, fib_of_three)
  end
end
```

## Recursive Solution ##
### Version 8 ###
Input    Output
-----    ------
  0         0
  1         1
  2         1
  3         2

```ruby
require 'test/unit'

class Fibonacci
  def self.of(number)
    if number == 0
      return 0
    elsif number <= 2
      return 1
    end
    return of(number - 1) + of(number - 2)
  end
end

class FibonacciTest < Test::Unit::TestCase
  def test_fibonacci_of_zero_is_zero
    fib_of_zero = Fibonacci.of(0)
    assert_equal(0, fib_of_zero)
  end
  
  def test_fibonacci_of_one_is_one
    fib_of_one = Fibonacci.of(1)
    assert_equal(1, fib_of_one)
  end
  
  def test_fibonacci_of_two_is_one
    fib_of_two = Fibonacci.of(2)
    assert_equal(1, fib_of_two)
  end
  
  def test_fibonacci_of_three_is_two
    fib_of_three = Fibonacci.of(3)
    assert_equal(2, fib_of_three)
  end
end
```

The generalized solution uses recursion.

## Cleanup ##
### Version 9 ###
Recursive solution:

Input    Output
-----    ------
  0         0
  1         1
  2         1
  3         2

```ruby
require 'test/unit'

class Fibonacci
  def self.of(n)
    return 0 if n == 0
    return 1 if n == 1
    return of(n - 1) + of(n - 2)
  end
end

class FibonacciTest < Test::Unit::TestCase
  def test_fibonacci_of_zero_is_zero
    fib_of_zero = Fibonacci.of(0)
    assert_equal(0, fib_of_zero)
  end
  
  def test_fibonacci_of_one_is_one
    fib_of_one = Fibonacci.of(1)
    assert_equal(1, fib_of_one)
  end
  
  def test_fibonacci_of_two_is_one
    fib_of_two = Fibonacci.of(2)
    assert_equal(1, fib_of_two)
  end
  
  def test_fibonacci_of_three_is_two
    fib_of_three = Fibonacci.of(3)
    assert_equal(2, fib_of_three)
  end

  def test_fibonacci_of_ten_is_what
    fib_of_ten = Fibonacci.of(10)
    assert_equal(55, fib_of_ten)
  end
  
end
```

Green before and after refactoring. Used idiomatic Ruby to cleanup code. Named variables expressive of the domain.

## Optimization ##
### Version 10 ###
Non-Recursive solution:

Input    Output
-----    ------
  0         0
  1         1
  2         1
  3         2

```ruby
require 'test/unit'

class Fibonacci
  def self.of(n)    
    current, successor = 0,1
    n.times do
      current, successor = successor, current + successor
    end
    return current
  end
end

class FibonacciTest < Test::Unit::TestCase
  def test_fibonacci_of_zero_is_zero
    fib_of_zero = Fibonacci.of(0)
    assert_equal(0, fib_of_zero)
  end
  
  def test_fibonacci_of_one_is_one
    fib_of_one = Fibonacci.of(1)
    assert_equal(1, fib_of_one)
  end
  
  def test_fibonacci_of_two_is_one
    fib_of_two = Fibonacci.of(2)
    assert_equal(1, fib_of_two)
  end
  
  def test_fibonacci_of_three_is_two
    fib_of_three = Fibonacci.of(3)
    assert_equal(2, fib_of_three)
  end

  def test_fibonacci_of_ten_is_what
    fib_of_ten = Fibonacci.of(10)
    assert_equal(55, fib_of_ten)
  end
  
end
```

This version illustrates using existing tests as safety net when making major changes to the code. Notice that we only focus only on one thing at a time, the focus can shift from one version to the other.

## Exercises: ##
			
1. Run the mini-test based fibonacci and make sure all tests pass. 
    ($ ruby fibonacci_test.rb)
2. Move the fibonacci class into its own file and make all the tests pass.
3. Convert the given mini-test test to rspec version fibonacci_spec.rb.
4. Get the output of the mini-test in color. 
5. Watch the Factorial screencast and convert the unit test to rspec spec.
