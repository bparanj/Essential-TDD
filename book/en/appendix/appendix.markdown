# Appendix #

## 1. RSpec Test Structure ##

```ruby
describe Movie, "Define the class or module here" do

end
```

The first argument of the describe block in a spec is name of the class or module under test. It is the subject. It can also be a string. The second is an optional string. It is a good practice to include the second 
string argument that describes the class and make sure that it does not have 'And', 'Or' or 'But'.
If it obeys Single Responsibility Principle then it will not contain those words.

```ruby
describe Movie, 'Definition' do
  specify "[Method Under Test] [Scenario] [Expected Behavior]" do

  end
end
```
Same thing can be accomplished by using describe, context and specify methods together. Refer 'The RSpec Book' to learn more.

Given
When 
Then

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

\newpage

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

\newpage

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

\newpage

## FAQ ##

1. cover rspec matcher is not working in ruby 1.8.7. Create a custom matcher called 
   between(lower, upper) as an example.

2. Composing objects occurs in the Game.new(fake_console) step. The mock is basically an interface that plays
   the role of console. 

3. In the refactoring stage, you must look beyond just eliminating duplication. You must apply OO principles and make sure the classes are cohesive and loosely coupled.

4. Why you should not begin refactoring in red state?
If you start refactoring in the red state then you will not know which of the changes you made is causing the problem. It becomes difficult to fix the problem. 

5. Specs should read like a story with a beginning, middle and an end. 
   Once upon a time... lot of exciting things happen... then they lived happily ever after.

6. How do you know the code is working?
   A test should fail when the code is broken. It should pass when it is good.

7. Do not tie the test to the data structure. It will lead to brittle test.

## Difficulty in Writing a Test ##

1. How can you express the domain? What should happen when you start a game?
2. What statements can you make about the program that is true?

\newpage

## 3. Side Effect ##

A function or expression modifies some state or has an observable interaction with calling functions or the outside world in addition to returning a value. For example, a function might modify a global or static variable, modify one of its arguments, raise an exception, write data to a display or file, read data, or call other side-effecting functions. In the presence of side effects, a program's behavior depends on history; that is, the order of evaluation matters. Understanding a program with side effects requires knowledge about the context and its possible histories; and is therefore hard to read, understand and debug.

Side effects are the most common way to enable a program to interact with the outside world (people, filesystems, other computers on networks). But the degree to which side effects are used depends on the programming paradigm. Imperative programming is known for its frequent utilization of side effects. In functional programming, side effects are rarely used. 

Source: Wikipedia

## 4. dev/null in Unix ##

In Unix, /dev/null represents a null device that is a special file. It discards all data written to it and provides no data to anyone that read from it.

## Stub ##

1. In irb: 

```ruby
> require 'rspec/mocks/standalone'
> s = stub.as_null_object
```

acts as a UNIX's dev/null equivalent for tests. It ignores any messages. Useful for incidental interactions that is not relevant to what is being tested. It implements the Null Object pattern.

In E-R modeling you have relationships such as 1-n, n-n, 1-1 and so on. In domain modeling you have relationships such as aggregation, composition, inheritance, delegation etc. Most of these have constructs provided by the language or the framework such as Rails. Example: composed_of in Rails, delegate in Ruby, symbol < for inheritance. The interface relationship for roles has to be explicitly specified in the specs to make the relationship between objects explicit.

\newpage

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

## Notes on Mock Objects ##

A Mock Object is a substitute implementation to emulate or instrument other domain code.  It should be simpler than the real code, not duplicate its implementation, and allow you to set up private state to aid in testing. The emphasis in mock implementations is on absolute simplicity, rather than completeness. For example, a mock collection class might always return the same results from an index method, regardless of the actual parameters. 

A warning sign of a Mock Object becoming too complex is that it starts calling other Mock Objects – which might mean that the unit test is not sufficiently local. When using Mock Objects, only the unit test and the target domain code are real.

## Why use mock objects? ##

- Deferring Infrastructure Choices
- Lightweight emulation of required complex system state
- On demand simulation of conditions
- Interface Discovery
- Loosely coupled design achieved via dependency injection

## A Pattern for Unit Testing ##

Create instances of Mock Objects

- Set state in the Mock Objects
- Set expectations in the Mock Objects
- Invoke domain code with Mock Objects as parameters
- Verify consistency in the Mock Objects

With this style, the test makes clear what the domain code is expecting from its environment, in effect documenting its preconditions, postconditions, and intended use. All these aspects are defined in executable test code, next to the domain code to which they refer. Sometimes arguing about which objects to verify gives us better insight into a test and, hence, the domain. This style makes it easy for new readers to understand the unit tests as it reduces the amount of context they have to remember. It is also useful for demonstrating to new programmers how to write effective unit tests.

Testing with Mock Objects improves domain code by preserving encapsulation, reducing global dependencies, and clarifying the interactions between classes.

\newpage

# Tautology #

## Objective ##

To illustrate common beginner’s mistake of stubbing yourself out.

```ruby
describe "Don't mock yourself out" do
  it "should illustrate tautology" do
    paul = stub(:paul, :age => 20)
    
    expect(paul.age).to eq(20) 
  end
end
```

This test does not test anything. It will always pass.
	
## Reference ##

Working Effectively with Legacy Code

\newpage

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

```ruby
> irspec
> User.new(:name => 'matz').should_not be_valid
> irspec 'spec/requests/users_spec.rb'
```

\newpage

## The Rspec Book ##

The Good

1. Good discussion of Double, Mock and Stubs.

The Bad

1. Mocking the ActiveRecord library methods is a bad practice. It is shown with partial mocking example. 
   This leads to brittle tests. Because the test is tightly coupled to the implementation. For instance, when Rails is 
   upgraded the specs using old ActiveRecord calls will fail when the new syntax for the ORM is used.
Even though the behavior does not change it breaks the tests that is tightly coupled to ORM syntax.

## Direct Input ##

A test may interact with the SUT directly via its public API or indirectly via its back door. The stimuli injected by the test into the SUT via its public API are direct inputs of the SUT. Direct inputs may consist of method calls to another component or messages sent on a message channel and the arguments or contents.

## Indirect Input ##

When the behavior of the SUT is affected by the values returned by another component whose services it uses, we call those values indirect inputs of the SUT. Indirect inputs may consist of return values of functions and any errors or exceptions raised by the DoC. Testing of the SUT behavior with indirect inputs requires the appropriate control point on the back side of the SUT. We often use a test stub to inject the indirect inputs into the SUT.

## Direct Output ##

A test may interact with the SUT directly via its public API or indirectly via its back door. The responses received by the test from the SUT via its public API are direct outputs of the SUT. Direct outputs may consist of the return values of method calls, updated arguments passed by reference, exceptions raised by the SUT or messages received on a message channel from the SUT.

## Indirect Output ##

When the behavior of the SUT includes actions that cannot be observed through the public API of the SUT but that are seen or experienced by other systems or application components, we call those actions the indirect outputs of the SUT. Indirect outputs may consist of calls to another component, messages sent on a message channel and records inserted into a database or written to a file. Verification of the indirect output behaviors of the SUT requires the use of appropriate observation points on the back side of SUT. Mock objects are often used to implement the observation point by intercepting the indirect outputs of the SUT and comparing them to the expected values.

Source : xUnit Test Patterns: Refactoring Test Code by Gerard Meszaros

## Angry Rock : Possible Solution ##

angry_rock.rb

```ruby
module Game  
  class Play
    def initialize(first_choice, second_choice)
      choice_1 = Internal::AngryRock.new(first_choice)
      choice_2 = Internal::AngryRock.new(second_choice)
      
      @winner = choice_1.winner(choice_2)
    end
    def has_winner?
      !@winner.nil?
    end    
    def winning_move
      @winner.move
    end
  end
  
  module Internal # no-rdoc
    # This is implementation details. Not for client use.
    class AngryRock
      include Comparable

      WINS = [ %w{rock scissors}, %w{scissors paper}, %w{paper rock}]

      attr_accessor :move

      def initialize(move)
        @move = move.to_s
      end
      def <=>(opponent)
        if move == opponent.move
          0
        elsif WINS.include?([move, opponent.move])
          1
        elsif WINS.include?([opponent.move, move])
          -1
        else
          raise ArgumentError, "Only rock, paper, scissors are valid choices"
        end
      end
      def winner(opponent)
        if self > opponent
          self
        elsif opponent > self
          opponent
        end
      end
    end
  end
end  
```

angry_rock_spec.rb

```ruby
require 'spec_helper'

module Game
  describe Play do
   
   it "should pick paper as the winner over rock" do
     play = Play.new(:paper, :rock)
     
     play.should have_winner
     play.winning_move.should == "paper"     
   end 
   it "picks scissors as the winner over paper" do
     play = Play.new(:scissors, :paper)
     
     play.should have_winner
     play.winning_move.should == "scissors"     
   end
   it "picks rock as the winner over scissors " do
     play = Play.new(:rock, :scissors)
     
     play.should have_winner
     play.winning_move.should == "rock"          
   end
   it "results in a tie when the same choice is made by both players" do
     data_driven_spec([:rock, :paper, :scissors]) do |choice|
       play = Play.new(choice, choice)

       play.should_not have_winner
     end     
   end   
   it "should raise exception when illegal input is provided" do
     expect do
       play = Play.new(:junk, :hunk)
     end.to raise_error
   end
  end
end
```

## Angry Rock : Concise Solution ##

play_spec.rb

```ruby
require 'spec_helper'
require 'angryrock/play'

module AngryRock
  describe Play do
   it "should pick paper as the winner over rock" do
     play = Play.new(:paper, :rock)
     
     play.should have_winner
     play.winning_move.should == :paper
   end    
   it "picks scissors as the winner over paper" do
     play = Play.new(:scissors, :paper)
     
     play.should have_winner
     play.winning_move.should == :scissors     
   end
   it "picks rock as the winner over scissors " do
     play = Play.new(:rock, :scissors)
     
     play.should have_winner
     play.winning_move.should == :rock          
   end
   it "results in a tie when the same choice is made by both players" do
     data_driven_spec([:rock, :paper, :scissors]) do |choice|
       play = Play.new(choice, choice)

       play.should_not have_winner
     end     
   end   
   it "should raise exception when illegal input is provided" do
     expect do
       play = Play.new(:junk, :hunk)
     end.to raise_error
   end
  end
end
```

play.rb

```ruby
module AngryRock
  class Play
    def initialize(first_choice, second_choice)
      @choice_1 = Internal::AngryRock.new(first_choice)
      @choice_2 = Internal::AngryRock.new(second_choice)
      
      @winner = @choice_1.winner(@choice_2)
    end
    def has_winner?
      @choice_1.has_winner?(@choice_2)
    end
    def winning_move
      @winner.move
    end
  end
  
  module Internal # no-rdoc
    # This is implementation details. Not for client use. Don't touch me.
    class AngryRock
      WINS = {rock: :scissors, scissors: :paper, paper: :rock}

      attr_accessor :move

      def initialize(move)
        @move = move
      end
      def has_winner?(opponent)
        self.move != opponent.move
      end
      # fetch will raise exception when the key is not one of the allowed choice
      def winner(opponent)
        if WINS.fetch(self.move)
          self
        else
          opponent
        end
      end
    end
  end
end
```

## Double Dispatch : Angry Rock Game Solution ##

game.rb

```ruby
require_relative 'game_coordinator'

module AngryRock
  class Game
    def initialize(player_one, player_two)
      @player_one = player_one
      @player_two = player_two
    end
    def winner
      coordinator = GameCoordinator.new(@player_one, @player_two)
      coordinator.winner
    end
  end
end
```

game_coordinator.rb

```ruby
require_relative 'paper'
require_relative 'rock'
require_relative 'scissor'

module AngryRock  
  class GameCoordinator
    def initialize(player_one, player_two)
      @player_one = player_one
      @player_two = player_two
      @choice_one = player_one.choice
      @choice_two = player_two.choice
    end
    def winner      
      result = pick_winner
      
      winner_name(result)
    end
    
    private 
    
    def select_winner(receiver, target)
      receiver.beats(target)
    end
    def classify(string)
      Object.const_get(@choice_two.capitalize)
    end    
    def winner_name(result)
      if result
        @player_one.name
      else
        @player_two.name
      end
    end
    def pick_winner
      result = false
       if @choice_one == 'scissor'
         result = select_winner(Scissor.new, classify(@choice_two).new)
       else
         result = select_winner(classify(@choice_one).new, classify(@choice_two).new)
       end
       result
    end
  end
end
```

paper.rb

```ruby
class Paper
  def beats(item)
    !item.beatsPaper
  end
  def beatsRock
    true
  end
  def beatsPaper
    false
  end
  def beatsScissor
    false
  end
end
```

rock.rb

```ruby
class Rock
  def beats(item)
    !item.beatsRock
  end
  def beatsRock
    false
  end  
  def beatsPaper
    false
  end
  def beatsScissor
    true
  end
end
```

scissor.rb

```ruby
class Scissor
  def beats(item)
    !item.beatsScissor
  end
  def beatsRock
    false
  end  
  def beatsPaper
    true
  end
  def beatsScissor
    false
  end
end
```

player.rb

```ruby
Player = Struct.new(:name, :choice)    
```

game_spec.rb

```ruby
require 'spec_helper'

module AngryRock
  describe Game do
    before(:all) do
      @player_one = Player.new
      @player_one.name = "Green_Day"
      @player_two = Player.new  
      @player_two.name = "minder"
    end        
    it "picks paper as the winner over rock" do
      @player_one.choice = 'paper'
      @player_two.choice = 'rock'
      
      game = Game.new(@player_one, @player_two)
      game.winner.should == 'Green_Day'   
    end
    it "picks scissors as the winner over paper" do
      @player_one.choice = 'scissor'
      @player_two.choice = 'paper'
      
      game = Game.new(@player_one, @player_two)
      game.winner.should == 'Green_Day'
    end
    it "picks rock as the winner over scissors " do
      @player_one.choice = 'rock'
      @player_two.choice = 'scissor'
      
      game = Game.new(@player_one, @player_two)
      game.winner.should == 'Green_Day'
    end
    it "picks rock as the winner over scissors. Verify player name. " do
       @player_one.choice = 'scissor'
       @player_two.choice = 'rock'

       game = Game.new(@player_one, @player_two)
       game.winner.should == 'minder'
    end
  end
end
```

\newpage
