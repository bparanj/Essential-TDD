## Calculator Example ##

What statements can you make about the calculator program that is true?

*  It should add given two numbers.

Let's write a spec for this statement.

calculator_spec.rb

```ruby
require_relative 'calculator'

describe Calculator do
  
  it "should add given two numbers" do
    calculator = Calculator.new
    result = calculator.add(1,2)
    
    result.should == 3
  end
end
```

We have converted the statement that is true to an assertion. According to the dictionary assertion is a confident and forceful statement of fact or belief. If we did not write any test then we would manually check that the result is correct. We automate this check by using an assertion.

calculator.rb

```ruby
class Calculator
  def add(x,y)
    x+y
  end
end
```



