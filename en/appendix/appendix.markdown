# Appendix #

## 1. Fibonacci Exercise Answer ##

fibonacci_spec.rb

```ruby
class Fibonacci
  def output(n)
    return 0 if n == 0
    return 1 if n == 1
    return output(n-1) + output(n-2)
  end
end

describe Fibonacci do
  it "should return 0 for 0 input" do
    fib = Fibonacci.new
    result = fib.output(0)
    result.should == 0
  end
  
  it "should return 1 for 1 input" do
    fib = Fibonacci.new
    result = fib.output(1)
    result.should == 1
  end
  
  it "should return 1 for 2 input" do
    fib = Fibonacci.new
    result = fib.output(2)
    result.should == 1
  end
  
  it "should return 2 for 3 input" do
    fib = Fibonacci.new
    result = fib.output(3)
    result.should == 2
  end
end
```

## 2. Interactive Spec ##

How to use Interactive Spec gem to experiment with RSpec.

Standalone:

```ruby
1. gem install interactive_spec
2. irspec
3. > (1+1).should == 3
```

Rails:


```ruby
1. Include gem 'interactive_rspec' in Gemfile
2. bundle
3. rails c
3. > irspec
4. > User.new(:name => 'matz').should_not be_valid
5. > irspec 'spec/requests/users_spec.rb'
```

## 3. Side Effect ##

TODO: Definition goes here.

## 4. dev/null in Unix ##

In Unix, /dev/null represents a null device that is a special file. It 
discards all data written to it and provides no data to anyone that read
from it.

## 5. Gist by Pat Maddox at https://gist.github.com/730609 ##

module Codebreaker
  class Game
    def initialize(output)
      @output = output
    end
    def start
      @output.puts("Welcome to Codebreaker!")
      @output << "You smell bad"
    end
  end
end

module Codebreaker
  describe Game do
    describe "#start" do
      it "sends a welcome message" do
        output = double('output')
        game = Game.new(output)
        output.should_receive(:puts).with('Welcome to Codebreaker!')
        game.start
      end
    end
  end
end

This example is from the RSpec Book. The problem here is the Game object has no purpose. 
It is ignoring the system boundary and is tightly coupled to the implementation. It violates
Open Closed Principle.

## FAQ ##

1. cover rspec matcher is not working in ruby 1.8.7. Create a custom matcher called 
   between(lower, upper) as an example.

2. Composing objects occurs in the Game.new(fake_console) step. The mock is basically an interface that plays
   the role of console. 

3. In the refactoring stage, you must look beyond just eliminating duplication. You must apply OO principles 
   and make sure the classes are cohesive and loosely coupled.

4. Specs should read like a story with a beginning, middle and an end. 
   Once upon a time... lot of exciting things happen... then they lived happily ever after.

5. How do you know the code is working?
   A test should fail when the code is broken. It should pass when it is good.

6. Do not tie the test to the data structure. It will lead to brittle test.

## Difficulty in Writing a Test ##

1. How can you express the domain? What should happen when you start a game?
2. What statements can you make about the program that is true?


