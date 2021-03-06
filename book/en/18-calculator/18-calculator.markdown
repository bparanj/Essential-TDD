# String Calculator #

## Objectives ##

- Triangulate to solve the problem
- Experiment to learn and explore possible solution
- Refactoring when there is no duplication to write intent revealing code
- Simplifying method signature

### String Calculator ###

- Try not to read ahead.
- Do one task at a time. The trick is to learn to work incrementally.
- Make sure you only test for correct inputs. There is no need to test for invalid inputs for this kata.

```ruby
1. Create a simple String Calculator with a method add(string containing numbers)
  - The method can take 0, 1 or 2 numbers, and will return their sum (for an empty string it will return 0) for example '', '1' or '1,2'.
  - Start with the simplest test case of an empty string and move to 1 and two numbers.
  - Remember to solve things as simply as possible so that you force yourself to write tests you did not think about.
  - Remember to refactor after each passing test.
2. Allow the add method to handle an unknown amount of numbers.
3. Allow the add method to handle newlines between numbers (instead of commas)
	- The following input is ok: '1\n2,3' (will equal 6)
	- The following input is NOT ok: '1,\n' (no need to prove it - just clarifying)
4. Support different delimiters
	- To change a delimiter, the beginning of the string will contain a separate line that looks like this: '//[delimiter]\n[numbers...]' for example '//;\n1;2' should return three where the default delimiter is ';'
	- The first line is optional. All existing scenarios should still be supported.
```

This TDD Kata is by Roy Osherove found at : http://osherove.com/tdd-kata-1/. Follow the guidelines and write the specs. Compare your solution to the following solution.

### Version 1 ###

```ruby
class Calculator
  def calculate(input)
	  input.to_i
  end
end

describe Calculator do
  let(:calculator) {  Calculator.new }

  it "returns 0 for an empty string" do
    result = calculator.calculate("")
    
    result.should == 0
  end
  
  it "returns 1 for a string containing 1" do
    result = calculator.calculate("1")
    
    result.should == 1    
  end
    
end
```

From David Bernstein blog post at: http://tobeagile.com/2009/12/08/triangulation/

"If I get stuck and I don’t know how a complex algorithm should work I’ll write a test for an error case. Then I’ll write a test for the simplest non-error case I can think of and return a hard coded value. Then I’ll write another test case and see if I can figure out the algorithm at that point. In doing so I gain some momentum and perhaps some insight in how the algorithm should behave on an edge case and a few normal cases.

This is called triangulation and it was used in celestial navigation for thousands of years. It is easier to see you are moving when you compare your position to two or more points on the horizon rather than just one. The same applies to coding; it is often easier to figure out the behavior of an algorithm by examining a couple of test cases instead of just one.""

Let's now triangulate and implement the real solution. 

### Version 2 ###

```ruby
class Calculator
  def calculate(input)
    strings = input.split(',')
    numbers = strings.map{|x| x.to_i}
    numbers.inject{|sum, n| sum + n}
  end
end

describe Calculator do
  let(:calculator) {  Calculator.new }

  it "returns 0 for an empty string" do
    result = calculator.calculate("")
    
    result.should == 0
  end
  
  it "returns 1 for a string containing 1" do
    result = calculator.calculate("1")
    
    result.should == 1    
  end
  
  it "returns the sum of the numbers for '1,2'" do
    result = calculator.calculate("1,2")
    
    result.should == 3        
  end
  
end
```

Started with the simplest test case of an empty string and moved to 1 and two numbers. Experimented in irb to get the generic solution working. Copied the code to calculate method to get the test passing. This broke the test 1. Let's fix that now.

### Version 3 ###

Added a guard condition to handle the blank string edge case.

```ruby
class Calculator
  def calculate(input)
    if input.include?(',')
      strings = input.split(',')
      numbers = strings.map{|x| x.to_i}
      numbers.inject{|sum, n| sum + n}
    else
      input.to_i
    end
  end
end
```

### Version 4 ###

Refactored in green state. Made the methods smaller. Method names expressive and focused on doing just one thing.

```ruby
class Calculator
  def calculate(input)
    if input.include?(',')
      numbers = convert_string_to_integers(input)
      calculate_sum(numbers)
    else
      input.to_i
    end
  end
  
  private
  
  def convert_string_to_integers(input)
    strings = input.split(',')
    strings.map{|x| x.to_i}
  end
  
  def calculate_sum(numbers)
    numbers.inject{|sum, n| sum + n}
  end
end
```

Note that this refactoring was not about duplication. The focus was to write intent revealing code.

### Version 5 ###

From the requirements, the spec for the next task:

```ruby
it 'can add unknown amount of numbers' do
  result = calculator.calculate("1,2,3,4")
  
  result.should == 10           
end
```

This test passes without failing. So we mutate the code to make the test fail:

```ruby
def calculate_sum(numbers)
  return 0 if numbers.size == 4
  numbers.inject{|sum, n| sum + n}
end
```

Now we make the test pass by removing the short-circuit statement : 

```ruby
return 0 if numbers.size == 4
```

```ruby
def calculate_sum(numbers)
  numbers.inject{|sum, n| sum + n}
end
```

### Version 6 ###

Add the following statement to the calculator_spec.rb:

```ruby
require_relative 'calculator' 
```

Move the calculator class to its own file. All specs should pass.

### Version 7 ###

```ruby
it 'allows new line also as a delimiter' do
  result = calculator.calculate("1\n2,3")
  
  result.should == 6
end
```

This test fails. To make it pass the calculator method now calls normalize_delimiter() method:

```ruby
class Calculator

  def calculate(input)
    normalize_delimiter(input)
    if input.include?(',')
      numbers = convert_string_to_integers(input)
      calculate_sum(numbers)
    else
      input.to_i
    end
  end
  
  private
    
  def normalize_delimiter(input)
    input.gsub!("\n", ',')
  end
  ... Other methods are the same ...
end
```

### Version 8 ###

After experimenting in the irb and learning about the String API, the quick and dirty implementation looks like this:

```ruby
class Calculator

  def calculate(input)
    if input.start_with?('//')
      @delimiter = input[2]
      @string = input[4, input.length - 1]
    else
      @delimiter = "\n"
      @string = input
    end
      
    normalize_delimiter
    if @string.include?(',')
      numbers = convert_string_to_integers
      calculate_sum(numbers)
    else
      @string.to_i
    end
  end
  
  private
  
  def convert_string_to_integers
    strings = @string.split(',')
    strings.map{|x| x.to_i}
  end
  
  def calculate_sum(numbers)
    numbers.inject{|sum, n| sum + n}
  end
  
  def normalize_delimiter
    @string.gsub!(@delimiter, ',')
  end
end
```

### Version 9 ###

After Cleanup :

```ruby
class Calculator

  def calculate(input)
    initialize_delimiter_and_input(input)  
    normalize_delimiter
    if @string.include?(',')
      numbers = convert_string_to_integers
      calculate_sum(numbers)
    else
      @string.to_i
    end
  end
  
  private
  
  def initialize_delimiter_and_input(input)
    if input.start_with?('//')
      @delimiter = input[2]
      @string = input[4, input.length - 1]
    else
      @delimiter = "\n"
      @string = input
    end
  end

  def convert_string_to_integers
    strings = @string.split(',')
    strings.map{|x| x.to_i}
  end
  
  def calculate_sum(numbers)
    numbers.inject{|sum, n| sum + n}
  end
  
  def normalize_delimiter
    @string.gsub!(@delimiter, ',')
  end
end
```

We are not passing in the string to be processed into methods anymore. Since it is needed by most of the methods, it is now an instance variable. We removed the argument to the private methods to simplify the interface.

\newpage
