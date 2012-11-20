# Guess Game #

## Objectives ##

- How to test random behavior ?
- Illustrate inverting dependencies.
- How to make your code depend on abstractions instead of concrete implementation ?
- Illustrate Single Responsibility Principle. No And, Or, or But.
- Illustrate programming to an interface not to an implementation.
- When to use partial stub on a real object ? Illustrated by spec 7 and 8.
- Random test failures due to partial stub. Fixed by isolating the random number generation.
- Make methods small, focused on doing one thing.
- How to defer decisions by using Mocks ?
- Using mock that complies with Gerard Meszaros standard.
- How to use as_null_object ?
- How to write contract specs to keep mocks in sync with production code ?

## Guessing Game Description ##

Write a program that generates a random number between 0 and 100 (inclusive). The user must guess this number. Each correct guess (if it was a number) will receive the response "Guess Higher!" or "Guess Lower!". Once the user has successfully guessed the number, you will print various statistics about their performance as detailed below:

* The prompt should display : "Welcome to the Guessing Game"
* When the program is run it should generate a random number between 0 and 100 inclusive
* You will display a command line prompt for the user to enter the number representing their guess. Quitting is not an option. The user can only end the game by guessing the target number. Be sure that your prompt explains to them what they are to do.
* Once you have received a value from the user, you should perform validation. If the user has given you an invalid value (anything other than a number between 1 and 100), display an appropriate error message. If the user has given you a valid value, display a message either telling them that there were correct or should guess higher or lower as described above. This process should continue until they guess the correct number.
	
## Version 1 ##

guess_game_spec.rb

```ruby
require_relative 'guess_game'

describe GuessGame do
  it "should generate random number between 1 and 100 inclusive" do
    game = GuessGame.new
    result = game.random

    result.should == 50
  end
end
```

guess_game.rb

```ruby
class GuessGame
  def random
    Random.new.rand(1..100)
  end
end
```

The random generator spec will only pass when the generated random number is 50. It will fail more often.

##	Version 2 ##

The spec below deals with the problem of randomness. You cannot use stub to deal with this spec because you will stub yourself out. So, what statement can you make about this code that is true? Can we loosen our assertion and still satisfy the requirement?

guess_game_spec.rb

```ruby
require_relative 'guess_game'

describe GuessGame do
  it "should generate random number between 1 and 100 inclusive" do
    game = GuessGame.new
    result = game.random

    expected_range = 1..100
    expected_range.should cover(result)
  end
end
```

This spec checks only the range of the generated random number is within the expected range. This now passes.

Note: Using expected.include?(result) is also ok (does not use cover rspec matcher). 

## Version 3 ##

Let's now write the second example.

guess_game_spec.rb

```ruby
require_relative 'guess_game'

describe GuessGame do
  ...  
  it "should display greeting when the game begins" do
    fake_console = mock('Console')
    fake_console.should_receive(:output).with("Welcome to the Guessing Game")
    game = GuessGame.new(fake_console)
    game.start
  end
end
```

Run the spec, you will see : undefined method `start' error message. Let's write minimal code required to get past the error message.

guess_game.rb

```ruby
class GuessGame  
  ...
  def start
  end
end
```

Define an empty start method. Run the spec again, you will see:

1) GuessGame should display greeting when the game begins
   Failure/Error: fake_console.should_receive(:output).with("Welcome to the Guessing Game")
     (Mock "Console").output("Welcome to the Guessing Game")
         expected: 1 time
         received: 0 times

We are failing now because the console object never received the output(string) method call. GuessGame class now looks like this:

guess_game.rb

```ruby
class GuessGame
  def initialize(console)
    @console = console
  end
  
  def random
    Random.new.rand(1..100)
  end
  
  def start
    @console.output("Welcome to the Guessing Game")
  end
end
```

GuessGame class now has a constructor that takes a console object. It then delegates welcoming the user to the console object in the start method. This is an example of dependency injection. Any collaborator that conforms to the interface we have discovered can be used to construct a GuessGame object.

Run the spec again, you will see the failure message:

1) GuessGame should generate random number between 1 and 100 inclusive
   Failure/Error: game = GuessGame.new
   ArgumentError:
     wrong number of arguments (0 for 1)

This implementation broke our previous test which is not passing in the console object to the constructor. We can fix it by initializing the default value to standard output.

guess_game.rb

```ruby
class GuessGame
  def initialize(console=STDOUT)
    @console = console
  end
  ...  
end
```

Both examples now pass. We are back to green. This spec shows how you can defer decisions about how to interact with the user. It could be standard out, GUI, client server app etc. Fake object is injected into the game object. 

Here is the complete listing for this version.

guess_game_spec.rb

```ruby
require_relative 'guess_game'

describe GuessGame do
  it "should generate random number between 1 and 100 inclusive" do
    game = GuessGame.new
    result = game.random
    
    expected = 1..100
    expected.should cover(result)
  end
  
  it "should display greeting when the game begins" do
    fake_console = double('Console')
    fake_console.should_receive(:output).with('Welcome to the Guessing Game')
    game = GuessGame.new(fake_console)
    game.start
  end
  
end
```

guess_game.rb

```ruby
class GuessGame
  def initialize(console=STDOUT)
    @console = console
  end
  
  def random
    Random.new.rand(1..100)
  end
  
  def start
    @console.output("Welcome to the Guessing Game")
  end
end
```

 The public interface output(string) of the Console object is discovered during the mocking step. It hides the details about the type of interface that must be implemented to communicate with an user. Game delegates any user interfacing code to a collaborating console object therefore it obeys Single Responsibility Principle. Console objects also obey the Single Responsibility Principle by focusing only on one concrete implementation of dealing with user interaction.
	
We could have implemented this similar to the code breaker game in the RSpec book by calling the puts method on output variable. By doing so we tie our game object to the implementation details. This results in tightly coupled objects which is not desirable. Whenever we change the way we interface with the external world, the code will break. We want loosely coupled objects with high cohesion.

Why did random number generation spec fail when user interfacing feature was modified? Random number generation and user interfacing logic are not related in any way. Ideally they should be split into separate classes that has only one purpose. We will revisit this topic later.

## Version 4 ##

Using mock that complies with Gerard Meszaros standard. Use double and if expectation is set, then it is a mock, otherwise it can be used as a stub.

guess_game_spec.rb

```ruby
  it "should display greeting when the game begins" do
    fake_console = double('Console')
    fake_console.should_receive(:output).with("Welcome to the Guessing Game")
    game = GuessGame.new(fake_console)
    game.start
  end
```

## Version 5 ##

Let's take our code for a test drive:

```ruby
game = GuessGame.new
game.start
```

gives us the error:

NoMethodError: undefined method ‘output’ for #<IO:<STDOUT>>
	
If you run:

STDOUT.puts 'hi' 

It will print 'hi' on the standard output. But it does not recognize output(string) method.	To fix this problem, let's wrap the output method in a StandardOutput class. Like this:

standard_output.rb

```ruby
class StandardOutput
  def output(message)
    puts message
  end
end
```

and change the constructor of the GuessGame like this:

```ruby
require_relative 'standard_output'

class GuessGame
  def initialize(console=StandardOutput.new)
    @console = console
  end
  ...
end
```

Even though StandardOutput seems like a built-in Ruby class it's not:

```ruby
irb > Kernel
 => Kernel 
irb > StandardOutput
NameError: uninitialized constant Object::StandardOutput
	from (irb):2
```
	
You can quickly double check this by referring the Ruby documentation at : http://ruby-doc.org/core-1.9.3/ by doing a class search. We do this check to avoid inadvertently reopening an existing class in Ruby.

guess_game_spec.rb

```ruby
require_relative 'guess_game'

describe GuessGame do
  it "should generate random number between 1 and 100 inclusive" do
    game = GuessGame.new
    result = game.random
    
    expected = 1..100
    expected.should cover(result)
  end
  it "should display greeting when the game begins" do
    fake_console = double('Console')
    fake_console.should_receive(:output).with('Welcome to the Guessing Game')
    game = GuessGame.new(fake_console)
    game.start
  end  
end
```

The tests still pass. This fix shows how to invert dependencies on concrete classes to abstract interface. In this case the abstract interface is 'output' and not specific method like 'puts' or GUI related method that ties the game logic to a concrete implementation of user interaction.

guess_game.rb

```ruby
require_relative 'standard_output'

class GuessGame
  def initialize(console=StandardOutput.new)
    @console = console
  end
  def random
    Random.new.rand(1..100)
  end
  def start
    @console.output("Welcome to the Guessing Game")
  end
end
```

In this version we fixed the bug due to wrong default value in the constructor.

## Version 6 ##

Added spec #3. This version illustrates the use of as_null_object.

```ruby
In irb type: 

$ irb
001 > require 'rspec/mocks/standalone'
 => true 
002 > s = stub
 => #<RSpec::Mocks::Mock:0x3fc8c58afdb8 @name=nil> 
003 > s.hi
RSpec::Mocks::MockExpectationError: Stub received unexpected message :hi with (no args)
004 > t = stub('stubber', :age => 16).as_null_object
 => #<RSpec::Mocks::Mock:0x3fc8c58a7104 @name="stubber"> 
005 > t.age
 => 16 
006 > t.hi
 => #<RSpec::Mocks::Mock:0x3fc8c58a7104 @name="stubber"> 
007 > t.bye
 => #<RSpec::Mocks::Mock:0x3fc8c58a7104 @name="stubber"> 
> t.foo.bar
 => #<RSpec::Mocks::Mock:0x3fc8c58a7104 @name="stubber">
```

If you send a message to a stub that is not programmed to respond to a method, you get an error "Stub received unexpected message". Calling as_null_object on stub 't'  makes it behave as a dev/null equivalent for tests. It ignores any messages that it is not explicitly programmed to respond. You can chain as deep as you want and it will keep returning a stub object. This is useful for incidental interactions that is not relevant to what is being tested. See the appendix to learn about dev/null in Unix.

Let's add the third spec :

guess_game_spec.rb

```ruby
require_relative 'guess_game'

describe GuessGame do
  ...  
  it "should display greeting when the game begins" do
    fake_console = double('Console')
    fake_console.should_receive(:output).with('Welcome to the Guessing Game')
    game = GuessGame.new(fake_console)
    game.start
  end
  it "should prompt the user to enter the number representing their guess." do
    fake_console = double('Console')
    fake_console.should_receive(:prompt).with('Enter a number between 1 and 100')
    game = GuessGame.new(fake_console)
    game.start    
  end
end
```

When you run the spec, you get the following error:

GuessGame should prompt the user to enter the number representing their guess.
    Failure/Error: game.start
      Double "Console" received unexpected message :output with ("Welcome to the Guessing Game")

The third spec failed because of the second spec. To fix this, call as_null_object on fake_console like this:

guess_game_spec.rb

```ruby
require_relative 'guess_game'

describe GuessGame do
  ...      
  it "should prompt the user to enter the number representing their guess." do
    fake_console = double('Console').as_null_object
	...
  end
end
```

When you run the spec, we are now failing for the right reason:

1) GuessGame should prompt the user to enter the number representing their guess.
    Failure/Error: fake_console.should_receive(:prompt).with('Enter a number between 1 and 100')
      (Double "Console").prompt("Enter a number between 1 and 100")
          expected: 1 time
          received: 0 times

Change the start method like this:

```ruby
require_relative 'standard_output'

class GuessGame
  ...  
  def start
    @console.output("Welcome to the Guessing Game")
    @console.prompt("Enter a number between 1 and 100")
  end
end
```

When you run the spec, now it fails with :

1) GuessGame should display greeting when the game begins
   Failure/Error: game.start
     Double "Console" received unexpected message :prompt with ("Enter a number between 1 and 100")

 Spec 3 passes but it breaks existing spec 2. To fix this, call as_null_object which ignores any messages not set as expectation in spec 2 as show below:

guess_game_spec.rb

```ruby
require_relative 'guess_game'

describe GuessGame do
  ...
  it "should display greeting when the game begins" do
    fake_console = double('Console').as_null_object
	...
  end
end
```

All specs now pass. Let's play the game in the irb.

```ruby
$ irb
001 > load './guess_game.rb'
 => true 
002 > g = GuessGame.new
 => #<GuessGame:0x007fc10a13aee8 @console=#<StandardOutput:0x007fc10a13aec0>> 
003 > g.start
Welcome to the Guessing Game
NoMethodError: undefined method `prompt' for #<StandardOutput:0x007fc10a13aec0>

Let's add the prompt method to the standard_output.rb :

standard_output.rb

```ruby
class StandardOutput
  ...  
  def prompt(message)
    output(message)
    puts ">"
  end
end
```

Note that this change is not driven by test. The reason is that the mock (fake_console) and the real object (StandardOutput) are not in sync. This is exposed by our exploration session in irb console. We will revisit this issue and learn how to write contract specs to keep them in sync in a later chapter.

Here is the code listing for this version:

guess_game.rb

```ruby
require_relative 'standard_output'

class GuessGame
  def initialize(console=StandardOutput.new)
    @console = console
  end
  def random
    Random.new.rand(1..100)
  end
  def start
    @console.output("Welcome to the Guessing Game")
    @console.prompt("Enter a number between 1 and 100")
  end
end
```

standard_output.rb

```ruby
class StandardOutput
  def output(message)
    puts message
  end
  def prompt(message)
    output(message)
    puts ">"
  end
end
```

## Version 7 ##

Let's delete the random method because it is required only once for each game session.

guess_game.rb

```ruby
require_relative 'standard_output'

class GuessGame
  attr_reader :random
  
  def initialize(console=StandardOutput.new)
    @console = console
    @random = Random.new.rand(1..100)
  end
  def start
    @console.output("Welcome to the Guessing Game")
    @console.prompt("Enter a number between 1 and 100")
  end
end
```

We were green before and we are still green after the refactoring when we run all the specs. Let's now add the fourth spec.

```ruby
require_relative 'guess_game'

describe GuessGame do
  ...  
  it "should perform validation of the guess entered by the user : lower than 1" do
    game = GuessGame.new
    game.start
    
    game.error.should == 'The number must be between 1 and 100'            
  end
end
```

When you run the specs, you get:

1) GuessGame should perform validation of the guess entered by the user : lower than 1
   Failure/Error: game.error.should == 'The number must be between 1 and 100'
   NoMethodError:
     undefined method `error' for #<GuessGame:0x007ff3b2a420d8>

Add the attr_accessor for error in guess_game.rb :

```ruby
require_relative 'standard_output'

class GuessGame
  attr_accessor :error
  ...
end
```

Now we fail for the right reason:

1) GuessGame should perform validation of the guess entered by the user : lower than 1
   Failure/Error: game.error.should == 'The number must be between 1 and 100'
     expected: "The number must be between 1 and 100"
          got: nil (using ==)


Change the guess_game.rb as shown below:

```ruby
class GuessGame
  attr_reader :random
  attr_accessor :error

  def initialize(console=StandardOutput.new)
    @console = console
    @random = Random.new.rand(1..100)
  end
    
  def start
    @console.output("Welcome to the Guessing Game")
    @console.prompt("Enter a number between 1 and 100")
    guess = get_user_guess
    validate(guess)
  end
  
  def validate(n)
    if (n < 1)
      @error = 'The number must be between 1 and 100'
    end
  end
  
  def get_user_guess
    0
  end
end
```

All the specs now pass.

Let's now add the spec to validate the guess that is higher than 100.

guess_game_spec.rb

```ruby
require_relative 'guess_game'

describe GuessGame do
  ...    
  it "should perform validation of the guess entered by the user : higher than 100" do
    game = GuessGame.new
    game.stub(:get_user_guess) { 101 }
    game.start
    
    game.error.should == 'The number must be between 1 and 100'            
  end
end
```

We don't want to worry about how we are going to get the user input because our focus now is on testing the validation logic. So we stub the get_user_guess method to return a value that will help us to test the validation logic. This spec fails for the right reason with the error:

1) GuessGame should perform validation of the guess entered by the user : higher than 100
   Failure/Error: game.error.should == 'The number must be between 1 and 100'
     expected: "The number must be between 1 and 100"
          got: nil (using ==)

Change the guess_game.rb validate method like this:

```ruby
require_relative 'standard_output'

class GuessGame
  ...  
  def validate(n)
    if (n < 1) or (n > 100)
      @error = 'The number must be between 1 and 100'
    end
  end
end
```

All specs now pass. 

The standard_output.rb remains unchanged.

```ruby
class StandardOutput
  def output(message)
    puts message
  end
  def prompt(message)
    output(message)
    puts ">"
  end
end
```

## Version 8 ##

Change the validation for the lower bound like this:

```ruby
require_relative 'guess_game'

describe GuessGame do
  it "should perform validation of the guess entered by the user : lower than 1" do
    game = GuessGame.new
	  game.stub(:get_user_guess) { 0 }
  	game.start
  
	  game.error.should == 'The number must be between 1 and 100'            
  end
end
```

We want to express the relationship between the doc string and the data set used to test clearly.

Let's now move on to the next spec.

guess_game_spec.rb

```ruby
require_relative 'guess_game'

describe GuessGame do
  it "should give clue when the input is valid" do
    
  end
end
```

guess_game_spec.rb

```ruby
require_relative 'guess_game'

describe GuessGame do
  ...
  it "should give clue when the input is valid and is less than the computer pick" do
    fake_console = double('Console').as_null_object
    fake_console.should_receive(:output).with('Your guess is lower')
    game = GuessGame.new(fake_console)
    game.random = 25
    game.stub(:get_user_guess) { 10 }

    game.start
  end
end
```

Run the spec, watch it fail:

1) GuessGame should give clue when the input is valid and is less than the computer pick
   Failure/Error: game.random = 25
   NoMethodError:
     undefined method `random=' for #<GuessGame:0x007fb701acb218>

Change the guess_game.rb to:

```ruby
require_relative 'standard_output'
require_relative 'randomizer'

class GuessGame
  attr_accessor :error
  ...  
end
```

Now the error message is: 

1) GuessGame should give clue when the input is valid and is less than the computer pick
   Failure/Error: fake_console.should_receive(:output).with('Your guess is lower')
     Double "Console" received :output with unexpected arguments
       expected: ("Your guess is lower")
            got: ("Welcome to the Guessing Game")

Change the guess_game.rb as shown below:

```ruby
require_relative 'standard_output'

class GuessGame
  attr_accessor :random
  attr_accessor :error

  def initialize(console=StandardOutput.new)
    @console = console
    @random = Random.new.rand(1..100)
  end
    
  def start
    @console.output("Welcome to the Guessing Game")
    @console.prompt("Enter a number between 1 and 100")
    guess = get_user_guess
    valid = validate(guess)
    give_clue if valid
  end
  
  def validate(n)
    if (n < 1) or (n > 100)
      @error = 'The number must be between 1 and 100'
      false
    else
      true
    end
  end
  
  def give_clue
    @console.output('Your guess is lower')
  end
  
  def get_user_guess
    0
  end
end
```

All specs pass now.

Let's make the spec use computer_pick instead of random. This makes the variable expressive of gaming domain instead of being implementation revealing.

```ruby
it "should give clue when the input is valid and is less than the computer pick" do
  ...
  game.computer_pick = 25
  ...
end
```

This gives the error:

1) GuessGame should give clue when the input is valid and is less than the computer pick
   Failure/Error: game.computer_pick = 25
   NoMethodError:
     undefined method `computer_pick=' for #<GuessGame:0x007fff3c990ca8>

Change the guess_game.rb implementation to:

```ruby
class GuessGame
  attr_accessor :computer_pick
  ...

  def initialize(console=StandardOutput.new)
    @console = console
    @computer_pick = Random.new.rand(1..100)
  end
  ...  
end
```

1) GuessGame should generate random number between 1 and 100 inclusive
   Failure/Error: result = game.random
   NoMethodError:
     undefined method `random' for #<GuessGame:0x007fe8419dbd28>

To make all the specs pass, make the following change to the spec:

```ruby
it "should generate random number between 1 and 100 inclusive" do
  ...
  result = game.computer_pick
  ...
end
```

Now all specs will pass.

## Version 9 ##

Let's write the spec for giving clue when the valid input is higher than computer pick.

```ruby
it "should give clue when the input is valid and is greater than the computer pick" do
  fake_console = double('Console').as_null_object
  fake_console.should_receive(:output).with('Your guess is higher')
  game = GuessGame.new(fake_console)
  game.computer_pick = 25
  game.stub(:get_user_guess) { 50 }
  
  game.start
end
```

The failure message now is :

1) GuessGame should give clue when the input is valid and is greater than the computer pick
   Failure/Error: fake_console.should_receive(:output).with('Your guess is higher')
     Double "Console" received :output with unexpected arguments
       expected: ("Your guess is higher")
            got: ("Welcome to the Guessing Game"), ("Your guess is lower")


Change the guess_game.rb as follows:

```ruby
require_relative 'standard_output'

class GuessGame
  ...  
  def give_clue
    if get_user_guess < @computer_pick
      @console.output('Your guess is lower')
    else
      @console.output('Your guess is higher')
    end
  end  
end
```

All specs now pass.

## Version 10 ##

Let's add the spec when the user guess is correct.

guess_game_spec.rb

```ruby
require_relative 'guess_game'

describe GuessGame do
  ...  
  it "should recognize the correct answer when the guess is correct." do
    fake_randomizer = stub(:get => 25)
    fake_console = double('Console').as_null_object
    fake_console.should_receive(:output).with('Your guess is correct')
    game = GuessGame.new(fake_console, fake_randomizer)
    game.guess = 25    
  end
end
```

This gives the failure message:

1) GuessGame should recognize the correct answer when the guess is correct
    Failure/Error: fake_console.should_receive(:output).with('Your guess is correct')
      Double "Console" received :output with unexpected arguments
        expected: ("Your guess is correct")
             got: ("Welcome to the Guessing Game"), ("Your guess is higher")


Change the guess_game.rb as follows:

```ruby
require_relative 'standard_output'

class GuessGame
  ...
  def give_clue
    if get_user_guess < @computer_pick
      @console.output('Your guess is lower')
    elsif get_user_guess > @computer_pick
      @console.output('Your guess is higher')
    else
      @console.output('Your guess is correct')  
    end
  end
end
```

Let's now hide the implementation details by making the validate and give_clue methods private.

```ruby
require_relative 'standard_output'

class GuessGame
  attr_accessor :computer_pick
  attr_accessor :error

  def initialize(console=StandardOutput.new)
    @console = console
    @computer_pick = Random.new.rand(1..100)
  end
  def start
    @console.output("Welcome to the Guessing Game")
    @console.prompt("Enter a number between 1 and 100")
    guess = get_user_guess
    valid = validate(guess)
    give_clue if valid
  end
  def get_user_guess
    0
  end
  
  private
  
  def validate(n)
    if (n < 1) or (n > 100)
      @error = 'The number must be between 1 and 100'
      false
    else
      true
    end
  end
  def give_clue
    if get_user_guess < @computer_pick
      @console.output('Your guess is lower')
    elsif get_user_guess > @computer_pick
      @console.output('Your guess is higher')
    else
      @console.output('Your guess is correct')  
    end
  end  
end
```

All specs still pass.

## Version 11 ##

In version 6, we ran into a problem when the mock went out of sync with the StandardOutput class. The StandardOutput class is one of several concrete implementation of an user interfacing object. We could have GuiOutput as another concrete implementation of the same interface. The fake_console mock is a generic role that represents an user interfacing object. In this section we will write contract specs to illustrate how to keep mocks in sync with code.

Create console_interface_spec.rb with the code shown below:

```ruby
shared_examples "Console Interface" do
  describe "Console Interface" do
    it "should implement the console interface: output(arg)" do
      @object.should respond_to(:output).with(1).argument
    end
    it "should implement the console interface: prompt(arg)" do
      @object.should respond_to(:prompt).with(1).argument
    end
  end
end
```

If you are run this spec, you get:

No examples found.

Finished in 0.00008 seconds
0 examples, 0 failures

The shared examples are meant to be shared. So create standard_output_spec.rb like this:

```ruby
require_relative 'console_interface_spec'
require_relative 'standard_output'

describe StandardOutput do
  before(:each) do
    @object = StandardOutput.new
  end
  
  it_behaves_like "Console Interface"
end
```

standard_output.rb

```ruby
class StandardOutput
  def output(message)
    puts message
  end
  def prompt(message)
    output(message)
    puts ">"
  end
end
```

Run this spec:

```ruby
$ rspec standard_output_spec.rb --color --format documentation

Now you get the output:

StandardOutput
  behaves like Console Interface
    Console Interface
      should implement the console interface: output(arg)
      should implement the console interface: prompt(arg)

Finished in 0.00258 seconds
2 examples, 0 failures

This Console Interface spec illustrates how to write contract specs. This avoids the problem of specs passing / failing due to mocks going out of synch with the code. When to use them? If you are using lot of mocks you man not be able to write contract tests for all of them. In this case, think about writing contract tests for the most dependent and important module of your application.

## Single Responsibility Principle ##

Let's take a look at the list of things that GuessGame object can do:

*	it "should generate random number between 1 and 100 inclusive"
*	it "should display greeting when the game begins" 
*	it "should prompt the user to enter the number representing their guess." 
*	it "should perform validation of the guess entered by the user : lower than 1" 
*	it "should perform validation of the guess entered by the user : higher than 100"
*	it "should give clue when the input is valid and is less than the computer pick" 
*	it "should give clue when the input is valid and is greater than the computer pick"
*	it "should recognize the correct answer when the guess is correct."

We can categorize the above responsibilities as:

1. Random number generation
2. Interacting with the user
3. Validation of input
4. Know when the guess is correct

Random number generation can be moved into Randomizer class. So we can delete the first spec, since it is now the responsibility of it's collaborator. The GuessGame object could become a gaming engine that delegates validation and user interaction to separate classes if they become complex. For now we will leave it alone. 

As we reflect on the responsibilities we can check whether the set of responsibilities serve one purpose or they are doing unrelated things. This will help us to design the class with high cohesion. This leads us to the following code.

guess_game_spec.rb

```ruby
require_relative 'guess_game'

describe GuessGame do  
 Delete the following spec :
 it "should generate random number between 1 and 100 inclusive" do
   game = GuessGame.new
   result = game.computer_pick
   
   expected = 1..100
   expected.should cover(result)
 end
 ...
end
```

guess_game.rb

```ruby
require_relative 'standard_output'
require_relative 'randomizer'

class GuessGame
  attr_accessor :computer_pick
  attr_accessor :error

  def initialize(console=StandardOutput.new, randomizer=Randomizer.new)
    @console = console
    @computer_pick = randomizer.get
  end
  ...    
end
```

randomizer.rb

```ruby
class Randomizer
  def get
    Random.new.rand(1..100)
  end
end
```

randomizer_spec.rb

```ruby
describe Randomizer do

  it "should generate random number between 1 and 100 inclusive" do
    result = Randomizer.new.get
  
    expected = 1..100
    # expected.include?(result) -- This is also ok (does not use rspec matcher)
    expected.should cover(result)
  end
end
```

## Version 12 ##

The guess_game.rb still has a fake implementation for get_user_guess method:

```ruby
def get_user_guess
  0
end
```

We now have to deal with getting input from a user. The question is : How can we abstract the standard input and standard output? Playing in the irb:

```ruby
irb > x = $stdin.gets
54
 => "54\n" 
irb > $stdout.puts 'hi'
hi
```

We can combine them into a console object. By definition: Console is a monitor and keyboard in a multiuser computer system. We can call this new class StandardConsole.

standard_console.rb

```ruby
class StandardConsole
  def output(message)
    puts message
  end
  def prompt(message)
    output(message)
    puts ">"
  end
  def input
    gets.chomp.to_i
  end
end
```

The input() method gets the user input, removes the new line and coverts the string to an integer. Change the get_user_guess method in guess_game.rb like this:

```ruby
def get_user_guess
  @console.input  
end
```

All the specs still pass. This change was not driven by a test. If we had written an end to end test, then it would have been driven by a failing acceptance test. The same issue can also be discovered simply by playing the game in the irb.

## Version 13 ##

Refactoring the spec leads us to the following version.

guess_game_spec.rb

```ruby
require_relative 'guess_game'

describe GuessGame do
  let(:fake_console) { double('Console').as_null_object }
        
  context 'Start the game' do
    it "should display greeting when the game begins" do
      fake_console.should_receive(:output).with("Welcome to the Guessing Game")
      game = GuessGame.new(fake_console)
      game.start
    end
    it "should prompt the user to enter the number representing their guess." do
      fake_console.should_receive(:prompt).with('Enter a number between 1 and 100')
      game = GuessGame.new(fake_console)
      game.start    
    end
  end      
  
  context 'Validation' do
    it "should perform validation of the guess entered by the user : lower than 1" do
      game = GuessGame.new
      game.stub(:get_user_guess) { 0 }
      game.start

      game.error.should == 'The number must be between 1 and 100'            
    end
    it "should perform validation of the guess entered by the user : higher than 100" do
      game = GuessGame.new
      game.stub(:get_user_guess) { 101 }
      game.start

      game.error.should == 'The number must be between 1 and 100'            
    end    
  end
  
  context 'Gaming Engine' do
    it "should give clue when the input is valid and is less than the computer pick" do
      fake_console.should_receive(:output).with('Your guess is lower')
      game = GuessGame.new(fake_console)
      game.computer_pick = 25
      game.stub(:get_user_guess) { 10 }

      game.start
    end
    it "should give clue when the input is valid and is greater than the computer pick" do
      fake_console.should_receive(:output).with('Your guess is higher')
      game = GuessGame.new(fake_console)
      game.computer_pick = 25
      game.stub(:get_user_guess) { 50 }

      game.start
    end
    it "should recognize the correct answer when the guess is correct" do
      fake_console.should_receive(:output).with('Your guess is correct')
      game = GuessGame.new(fake_console)
      game.computer_pick = 25
      game.stub(:get_user_guess) { 25 }

      game.start
    end    
  end
end
```

guess_game.rb

```ruby
require_relative 'standard_output'
require_relative 'randomizer'

class GuessGame
  attr_accessor :computer_pick
  attr_accessor :error

  def initialize(console=StandardOutput.new, randomizer=Randomizer.new)
    @console = console
    @computer_pick = randomizer.get
  end
  def start
    @console.output("Welcome to the Guessing Game")
    @console.prompt("Enter a number between 1 and 100")
    guess = get_user_guess
    valid = validate(guess)
    give_clue if valid
  end
  def get_user_guess
    @console.input  
  end
  
  private
  
  def validate(n)
    if (n < 1) or (n > 100)
      @error = 'The number must be between 1 and 100'
      false
    else
      true
    end
  end
  def give_clue
    if get_user_guess < @computer_pick
      @console.output('Your guess is lower')
    elsif get_user_guess > @computer_pick
      @console.output('Your guess is higher')
    else
      @console.output('Your guess is correct')  
    end
  end  
end
```

randomizer_spec.rb

```ruby
require_relative 'guess_game'

describe Randomizer do
  it "should generate random number between 1 and 100 inclusive" do
    result = Randomizer.new.get
  
    expected = 1..100
    # expected.include?(result) -- This is also ok (does not use rspec matcher)
    expected.should cover(result)
  end
end
```

randomizer.rb

```ruby
class Randomizer
  def get
    Random.new.rand(1..100)
  end
end
```

standard_console_spec.rb

```ruby
require_relative 'console_interface_spec'
require_relative 'standard_console'

describe StandardConsole do
  before(:each) do
    @object = StandardConsole.new
  end
  
  it_behaves_like "Console Interface"
end
```

standard_console.rb

```ruby
class StandardConsole
  def output(message)
    puts message
  end
  def prompt(message)
    output(message)
    puts ">"
  end
  def input
    gets.chomp.to_i
  end  
end
```

1. StandardOutput and StandardInput is combined into one StandardConsole object. This new object encapsulates
   the interaction with the standard input and output (monitor & keyboard).
2. We can have different implementations of the console object such NetworkConsole, GraphicalConsole etc.
3. Specs are more readable since they are grouped into their own context.

## Version 14 ##

The output of the specs have the puts statement because the default console used is StandardConsole. To cleanup the output let's create a NullDeviceConsole for testing purposes.

null_device_console.rb

```ruby
class NullDeviceConsole
  def output(message)
    message
  end

  def prompt(message)
    output(message + '\n' + ">")
  end  
end
```

Change the guess_game_spec.rb to use the NullDeviceConsole class to suppress the output to the standard out like this:

```ruby
context 'Validation' do
  let(:game) { game = GuessGame.new(NullDeviceConsole.new) }
  
  it "should perform validation of the guess entered by the user : lower than 1" do
    game.stub(:get_user_guess) { 0 }
    game.start

    game.error.should == 'The number must be between 1 and 100'            
  end
  it "should perform validation of the guess entered by the user : higher than 100" do
    game.stub(:get_user_guess) { 101 }
    game.start

    game.error.should == 'The number must be between 1 and 100'            
  end    
end
```

Run the specs, you will see clean output like this:

```ruby
GuessGame
  Start the game
    should display greeting when the game begins
    should prompt the user to enter the number representing their guess.
  Validation
    should perform validation of the guess entered by the user : lower than 1
    should perform validation of the guess entered by the user : higher than 100
  Gaming Engine
    should give clue when the input is valid and is less than the computer pick
    should give clue when the input is valid and is greater than the computer pick
    should recognize the correct answer when the guess is correct

Finished in 0.0058 seconds
7 examples, 0 failures
```

## Version 15 ##

### Actual Usage of the GuessGame ###

```ruby
$ irb
:001 > load './guess_game.rb'
 => true 
:002 > g = GuessGame.new
 => #<GuessGame:0x007fa414139ab0 @console=#<StandardConsole:0x007fa414139a88>, @random=42> 
:003 > g.start
Welcome to the Guessing Game
Enter a number between 1 and 100 to guess the number
>
 => nil 
:001 > g.get_user_guess
20
Your guess is lower
 => nil 
:002 > g.get_user_guess
30
Your guess is lower
 => nil 
:003 > g.get_user_guess
80
Your guess is higher
 => nil 
:004 > g.get_user_guess
70
Your guess is higher
 => nil 
:005 > g.get_user_guess
42
Your guess is correct
 => nil 
```

Our objective here is to expose bugs found during exploratory testing by writing test first. Then make it work. 
So we experimented in the irb to make sure the implementation of StandardConsole#input works. This
is a change in the production code that is not driven by test. 

We added to_s method to the StandardConsole and GuessGame classes so that the secret number is not revealed while playing the game. This change was driven by exploratory testing. 

guess_game.rb

```ruby
def to_s
  "You have chosen : #{@console} to play the guess game"
end
```

standard_console.rb

```ruby
def to_s
  "Standard Console"
end
```

## Exercises ##

1. Play the game with Guess game and make sure you can use it's interface and it works as expected. Use any feedback to write new specs. 

2. What if the client were to use the GuessGame like this :
```ruby
	game = GuessGame.new
	game.play
```
 This raises the level of abstraction and we use gaming domain specific method instead of reaching into implementation level 
 methods. What changes do you need to make for this to work? Can start and get_user_guess methods be made into private methods?

3. Version 2 of our game with satisfy the following new requirements:
 
  Once the user has guessed the target number correctly, you should display a "report" to them on their performance. This report should provide the following information:
	- The target number
	- The number of guesses it took the user to guess the target number
	- A list of all the valid values guessed by the user in the order in which they were guessed.
	- A calculated value called "Cumulative error". Cumulative error is defined as the sum of the absolute value of the difference between the target number and the values guessed. For example : if the target number was 30 and the user guessed 50, 25, 35, and 30, the cumulative error would be calculated as follows:

	|50-30| + |25-30| + |35-30| + |30-30| = 35

	Hint: See http://www.w3schools.com/jsref/jsref_abs.asp for assistance
	- A calculated value called "Average Error" which is calculated as follows: cumulative error / number of valid guesses. Using the above number set, the average error is 8.75.
	- A text feedback response based on the following rules:
	- If average error is 10.0 or lower, the message "Incredible guessing!"
	- If average error is higher than above but under 20.0, "Good job!"
	- If average error is higher than 20 but under 30.0, "Fair!"
	- Anything other score: "You are horrible at this game!"

4. 	It would be nice to be able to say: result.should be_between(expected_range). Implement a custom matcher be_between for a given range.

5. Write null_device_console_spec.rb that uses the shared examples to make sure it implements the abstract console interface. This will allow us to keep the NullDeviceConsole in sync with any changes to the interface of the abstract console.

\newpage
