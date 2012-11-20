# Calculator Example #

## Objective ##

- Learn about assertion

Let's write a simple calculator program driven by test. What statements can you make about the calculator program that is true? How about :

*  It should add given two numbers.

Let's write a spec for this statement. Create a file called calculator_spec.rb with the following contents:

```ruby
describe Calculator do
  it "should add given two numbers" do
    calculator = Calculator.new
    result = calculator.add(1,2)
    
    result.should == 3
  end
end
```

We first create an instance of Calculator class. The second step is invoking the method add to calculate sum of two numbers. The third step is checking if the result is the same as we expect. In this step, we have converted the statement that is true to an assertion.

According to the dictionary assertion is a confident and forceful statement of fact or belief. If we did not write any test then we would manually check the result for correctness. We automate this manual check by using an assertion.

Go to the directory where the spec file resides and run the test like this:

```ruby
$ rspec calculator_spec.rb --color
```

This test fails. Define calculator class at the top of the calculator_spec.rb file with the code shown below:

```ruby
class Calculator
  def add(x,y)
    x+y
  end
end
```

Run the test again. Now the test passes. You can now move the calculator class to its own file called calculator.rb. Add

```ruby
require_relative 'calculator'
```

to the top of the calculator_spec.rb. Run the test again. It should pass.

## Exercises ##

1. Write specs for the following statements:

*  It should subtract given two numbers.
*  It should multiply given two numbers.
*  It should divide given two numbers.

2. Refactor the duplication you see by using let or before method.

3. Write specs for edge cases such as invalid input, division by 0 etc.

\newpage
