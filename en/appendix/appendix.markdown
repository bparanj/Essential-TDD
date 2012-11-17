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

```ruby
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
```

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

## Notes from Martin Fowler's article and jMock Home Page ##

### Testing and Command Query Separation Principle ###

The term 'command query separation' was coined by Bertrand Meyer in his book 'Object Oriented Software Construction'.

The fundamental idea is that we should divide an object's methods into two categories:

    Queries: Return a result and do not change the observable state 
						 of the system (are free of side effects).
    Commands: Change the state of a system but do not return a value.

It's useful if you can clearly separate methods that change state from those that don't. This is because you can use queries in many situations with much more confidence, changing their order. You have to be careful with commands.

The return type is the give-away for the difference. It's a good convention because most of the time it works well. Consider iterating through a collection in Java: the next method both gives the next item in the collection and advances the iterator. It's preferable to separate advance and current methods.

 There are exceptions. Popping a stack is a good example of a modifier that modifies state. Meyer correctly says that you can avoid having this method, but it is a useful idiom. Follow this principle when you can.

From jMock home page: Tests are kept flexible when we follow this rule of thumb: Stub queries and expect commands, where a query is a method with no side effects that does nothing but query the state of an object and a command is a method with side effects that may, or may not, return a result. Of course, this rule does not hold all the time, but it's a useful starting point.

## RSpec Test Structure ##

1. 

describe Movie, "Definition. Make sure single responsibility principle is obeyed." do


end

The first argument of the describe block in a spec is name of the class or module under test. It is the subject. It can also be a string. The second is an optional string. It is a good practice to include the second 
string argument that describes the class and make sure that it does not have 'And', 'Or' or 'But'.
If it obeys Single Responsibility Principle that it will not contain those words.

2.

specify "[Method Under Test] [Scenario] [Expected Behavior]" do

end

Same thing can be accomplished by using describe, context and specify methods together. Refer the RSpec book to learn more.

3. 

Given
When 
Then

## Interactive Spec ##

Standalone:
------------

1. gem install interactive_spec
2. irspec
3. > (1+1).should == 3

Rails:
-------------

1. gem 'interactive_rspec' in Gemfile
2. bundle
3. rails c
> irspec
> User.new(:name => 'matz').should_not be_valid
> irspec 'spec/requests/users_spec.rb'

## Stub ##

1. In irb: 
> require 'rspec/mocks/standalone'

s = stub.as_null_object

acts as a UNIX's dev/null equivalent for tests. It ignores any messages. Useful for incidental interactions that is not relevant to what is being tested. It implements the Null Object pattern.

In E-R modeling you have relationships such as 1-n, n-n, 1-1 and so on. In domain modeling you have relationships such as aggregation, composition, inheritance, delegation etc. Most of these have constructs provided by the language or the framework such as Rails. Example: composed_of in Rails, delegate in Ruby, symbol < for inheritance. The interface relationship for roles has to be explicitly specified in the specs to make the relationship between objects explicit.

## The Rspec Book ##

The Good

1. Good discussion of Double, Mock and Stubs.

The Bad

1. Mocking the ActiveRecord library methods is a bad practice. It is shown with partial mocking example. 
   This leads to brittle tests. Because the test is tightly coupled to the implementation. For instance, when Rails is 
   upgraded the specs using old ActiveRecord calls will fail when the new syntax for the ORM is used.
Even though the behavior does not change it breaks the tests that is tightly coupled to ORM syntax.

## Direct Input ##

## Direct Output ##

## Side Effects ##

 
