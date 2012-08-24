# Basics #

This chapter is about the basics of TDD. It introduces the concepts using code exercises.

## Fibonacci ##

### Objectives ###

- To learn TDD Cycle : Red, Green, Refactor.
- Focus on getting it to work first, cleanup by refactoring and then focus on optimization.
- When refactoring, start green and end in green.
- Learn recursive solution and optimize the execution by using non-recursive solution.
- Using existing tests as regression tests when making major changes to existing code.

### Problem Statement ###

In mathematics, the Fibonacci numbers are the numbers in the following integer sequence:
0, 1, 1, 2, 3, 5, 8, 13, 21, 34, 55, 89, 144…

[ Image Goes Here ]

### Solution ###

By definition, the first two numbers in the Fibonacci sequence are 0 and 1, and each subsequent number is the sum of the previous two.

### Algebraic Equation ###

In mathematical terms, the sequence fibonacci(n) of Fibonacci numbers is defined by the recurrence relation fibonacci(n) = fibonacci(n-1) + fibonacci(n-2) with seed values fibonacci(0) = 0, fibonacci(1) = 1
 
### Visual Representation ###

[ Image Goes Here ]

[ Image Goes Here ]

### Guidelines ###

1. Each row in the table is an example. Make each example executable.
2. The final solution should be able to take any random number and calculate the Fibonacci number without any modification to the production code.

### Version 0 ###

```ruby
require 'test/unit'

# Version 1

class FibonacciTest < Test::Unit::TestCase
  def test_fibonacci_of_zero_is_zero
    fail "fail"
  end
end
```

Got proper require to execute the test. Proper naming of test following naming convention.


This example illustrates how to convert Requirements --> Examples --> Executable Specs. Each test for this problem takes an argument, does some computation and returns a result. It illustrates Direct Input and Direct Output. There are no side effects. Side effect free functions are easy to test. 
