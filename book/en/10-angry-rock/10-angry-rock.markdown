# Angry Rock #

## Objectives ##

- How to fix Command Query Separation violation?
- Refactoring : Retaining the old interface and the new one at the same time to avoid old tests from failing.
- Semantic quirkiness of Well Grounded Rubyist solution exposed by specs.
- Using domain specific terms to make the code expressive

### Version 1 - Violation of Command Query Separation Principle ###

Create angry_rock_spec.rb with the following contents:

require_relative 'angry_rock'

```ruby
module Game
  describe AngryRock do
   it "should pick paper as the winner over rock" do
     choice_1 = Game::AngryRock.new(:paper)
     choice_2 = Game::AngryRock.new(:rock)
     winner = choice_1.play(choice_2)
     result = winner.move
     
     result.should == :paper
   end    
  end
end
```

Create angry_rock.rb with the following contents:

```ruby
module Game
  class AngryRock
    
  end
end
```

Run the spec and watch it fail:

```ruby
$ rspec angry_rock_spec.rb --color --format doc

Game::AngryRock
  should pick paper as the winner over rock (FAILED - 1)
Failures:
  1) Game::AngryRock should pick paper as the winner over rock
     Failure/Error: choice_1 = Game::AngryRock.new(:paper)
     ArgumentError:
       wrong number of arguments(1 for 0)
```

Let's get past this error by changing the angry_rock.rb as follows:

```ruby
module Game
  class AngryRock
    def initialize(move)
      @move = move
    end
  end
end
```

Now we get the error:

```ruby
1) Game::AngryRock should pick paper as the winner over rock
   Failure/Error: winner = choice_1.play(choice_2)
   NoMethodError:
     undefined method `play' for #<Game::AngryRock:0xb0 @move=:paper>
```

So, let's define a empty play method as follows:

```ruby
module Game
  class AngryRock
    ...    
    def play
      
    end
  end
end
```

Now we get:

```ruby
1) Game::AngryRock should pick paper as the winner over rock
   Failure/Error: winner = choice_1.play(choice_2)
   ArgumentError:
     wrong number of arguments (1 for 0)
```

Change the play method signature like this:

```ruby
def play(other)
  
end
```

Now we get:

```ruby
1) Game::AngryRock should pick paper as the winner over rock
    Failure/Error: result = winner.move
    NoMethodError:
      undefined method `move' for nil:NilClass
```

Change the play method like this:

```ruby
    def play(other)
      self
    end
```

```ruby
1) Game::AngryRock should pick paper as the winner over rock
    Failure/Error: result = winner.move
    NoMethodError:
      undefined method `move' for #<Game::AngryRock:0xd8 @move=:paper>
```

Change the angry_rock.rb as follows:

```ruby
module Game
  class AngryRock
    attr_accessor :move
    ...
  end
end
```

The first spec now passes. Add the second spec:

```ruby
it "picks scissors as the winner over paper" do
  choice_1 = Game::AngryRock.new(:scissors)
  choice_2 = Game::AngryRock.new(:paper)
  winner = choice_1.play(choice_2)
  result = winner.move
  
  result.should == :scissors   
end
```

It passes immediately. Make it fail by mutating the angry_rock.rb like this:

```ruby
module Game
  class AngryRock
	...
    def play(other)
      return other if other.move == :paper
      self
    end
  end
end
```

It now fails with :

```ruby
1) Game::AngryRock picks scissors as the winner over paper
   Failure/Error: result.should == :scissors
     expected: :scissors
          got: :paper (using ==)
```

Remove the short circuit statement:      

```ruby
return other if other.move == :paper 
```

from angry_rock.rb. The spec will now pass.

Let's add the third spec:

```ruby
it "picks rock as the winner over scissors " do
  choice_1 = Game::AngryRock.new(:rock)
  choice_2 = Game::AngryRock.new(:scissors)
  winner = choice_1.play(choice_2)
  result = winner.move
  
  result.should == :rock      
end
```

This spec also passes without failing. Add a short circuit statement for the third spec and make the test fail and then make it pass again.

Let's now add the spec for the tie case:

```ruby
it "results in a tie when both players pick rock" do
  choice_1 = Game::AngryRock.new(:rock)
  choice_2 = Game::AngryRock.new(:rock)
  winner = choice_1.play(choice_2)
  result = winner.move

  winner.should be_false
end
```

This fails with the error:

```ruby
1) Game::AngryRock results in a tie when both players pick rock
   Failure/Error: winner.should be_false
     expected: false value
          got: #<Game::AngryRock:0xc0 @move=:rock>
```

Change the implementation of play method like this:

```ruby
def play(other)
  return false if self.move == other.move
  self
end
```

Now all the specs will pass. This implementation of play method is a lousy design. The false case breaks the consistency of the returned value and violates the semantics of the API. Also the play method is a “Command” not a “Query”. This method violates the “Command Query Separation Principle”.

### Fixing the Bad Design ###

Change the spec for tie case to:

```ruby
it "results in a tie when both players pick rock" do
  choice_1 = Game::AngryRock.new(:rock)
  choice_2 = Game::AngryRock.new(:rock)
  winner = choice_1.play(choice_2)
  result = winner.move
    
  result.should == "TIE!"     
end
```

This fails with the error:

```ruby
1) Game::AngryRock results in a tie when both players pick rock
   Failure/Error: result = winner.move
   NoMethodError:
     undefined method `move' for false:FalseClass
```

Change the implementation of the play method as follows:

```ruby
def play(other)
  return AngryRock.new("TIE!") if self.move == other.move
  self
end
```

Now all specs pass. The play method now returns a AngryRock tie object for the tie case. Add two more specs for the remaining tie cases one by one. 

```ruby
it "results in a tie when both players pick paper" do
  choice_1 = Game::AngryRock.new(:paper)
  choice_2 = Game::AngryRock.new(:paper)
  winner = choice_1.play(choice_2)
  result = winner.move
    
  result.should == "TIE!"     
end
it "results in a tie when both players pick scissors" do
  choice_1 = Game::AngryRock.new(:scissors)
  choice_2 = Game::AngryRock.new(:scissors)
  winner = choice_1.play(choice_2)
  result = winner.move
    
  result.should == "TIE!"     
end
```

Make them fail and then make it pass one by one. The last three specs show three possible tie scenarios.

### Removing the Duplication in Specs : The Before Picture ###

```ruby
it "results in a tie when the same choice is made by both players" do
  [:rock, :paper, :scissors].each do |choice|
    choice_1 = Game::AngryRock.new(choice)
    choice_2 = Game::AngryRock.new(choice)
    winner = choice_1.play(choice_2)
    result = winner.move
    
    result.should == "TIE!"      
  end     
end   
```

The duplication in specs is removed by using a loop. We can do better than that, let's apply what we learned in Eliminating Loops chapter.

### Removing the Duplication in Specs : The After Picture ###

Replace the loop version of the tie case with the following spec:

```ruby
it "results in a tie when the same choice is made by both players" do
  data_driven_spec([:rock, :paper, :scissors]) do |choice|
    choice_1 = Game::AngryRock.new(choice)
    choice_2 = Game::AngryRock.new(choice)
    winner = choice_1.play(choice_2)
    result = winner.move
    
    result.should == "TIE!"      
  end     
end   
```

Add a helper method in spec_helper.rb

```ruby
def data_driven_spec(container)
  container.each do |element|
   yield element
  end
end
```

Add :

```ruby
require_relative 'spec_helper'
```

to the top of the angry_rock_spec.rb.

Now all the specs should still pass. Let's now improve the design. To make the specs more readable change specs and production code as follows:

```ruby
require_relative 'angry_rock'
require_relative 'spec_helper'

module AngryRock
  describe Choice do
   it "should pick paper as the winner over rock" do
     choice_1 = AngryRock::Choice.new(:paper)
     choice_2 = AngryRock::Choice.new(:rock)
     winner = choice_1.play(choice_2)
     result = winner.move
     
     result.should == :paper
   end    
   it "picks scissors as the winner over paper" do
     choice_1 = AngryRock::Choice.new(:scissors)
     choice_2 = AngryRock::Choice.new(:paper)
     winner = choice_1.play(choice_2)
     result = winner.move
     
     result.should == :scissors   
   end
   it "picks rock as the winner over scissors " do
     choice_1 = AngryRock::Choice.new(:rock)
     choice_2 = AngryRock::Choice.new(:scissors)
     winner = choice_1.play(choice_2)
     result = winner.move
     
     result.should == :rock      
   end
   it "results in a tie when the same choice is made by both players" do
     data_driven_spec([:rock, :paper, :scissors]) do |choice|
       choice_1 = AngryRock::Choice.new(choice)
       choice_2 = AngryRock::Choice.new(choice)
       winner = choice_1.play(choice_2)
       result = winner.move

       result.should == "TIE!"      
     end     
   end   
  end
end

module AngryRock 
  class Choice
    attr_accessor :move
    
    def initialize(move)
      @move = move
    end
    def play(other)
      return Choice.new("TIE!") if self.move == other.move
      self
    end    
  end
end
```

The specs should still pass. The specs now read well and make much more sense than the previous version.

### Command Query Separation Principle ###

Is the play() method a command or a query? It is ambiguous because play seems to be a name of a command and it is returning the winning AngryRock object (result of a query operation). It combines command and query. Let's refactor while we stay green. What if the specs that we wrote was intelligent enough to use CQS principle like this:

```ruby
require_relative 'angry_rock'
require_relative 'spec_helper'

module AngryRock
  describe Game do
   it "should pick paper as the winner over rock" do
     game = AngryRock::Game.new(:paper, :rock)
     game.play
     winning_move = game.winning_move
     
     winning_move.should == :paper
   end
end
```

We create a game object by providing two choices, we play the game by using the command method play and we query the winning_move. Then we make our assertion on the winning move. To make this spec pass, change the implementation of the game as follows:

```ruby
module AngryRock 
  class Game
    WINS = {rock: :scissors, scissors: :paper, paper: :rock}
    
    def initialize(choice_1, choice_2)
      @choice_1 = choice_1
      @choice_2 = choice_2
    end
    def play
      @winner = winner
    end
    def winning_move
      @winner
    end
    def winner
      if WINS[@choice_1]
        @choice_1
      else
        @choice_2
      end
    end
  end  
end
```

Let's add the second and third specs and make sure they pass:

```ruby
it "picks scissors as the winner over paper" do
  game = AngryRock::Game.new(:scissors, :paper)

  game.play

  winning_move = game.winning_move  
  winning_move.should == :scissors
end
it "picks rock as the winner over scissors " do
  game = AngryRock::Game.new(:rock, :scissors)

  game.play

  winning_move = game.winning_move  
  winning_move.should == :rock
end
```

Let's add the tie case spec:

```ruby
it "results in a tie when the same choice is made by both players" do
  data_driven_spec([:rock, :paper, :scissors]) do |choice|
    game = AngryRock::Game.new(choice, choice)

    game.play

    winning_move = game.winning_move       
    winning_move.should == :tie
  end     
end
```

To make it pass change the production code as follows:

```ruby
def winner
  return :tie if @choice_1 == @choice_2
  if WINS[@choice_1]
    @choice_1
  else
    @choice_2
  end
end
```

Now all specs should pass. Now the play is a command and winner is a query. The command and query are now separated and the code obeys the CQS principle.

### Handling Illegal Inputs ###

Let's make the code robust by checking for illegal inputs. Add the following spec:

```ruby
it "should raise exception when illegal input is provided" do
  expect do
    game = AngryRock::Game.new(:punk, :hunk)
    game.play
  end.to raise_error
end
```

It fails with the following error:

```ruby
1) AngryRock::Game should raise exception when illegal input is provided
    Failure/Error: expect do
      expected Exception but nothing was raised

To make this spec pass change the winner method like this:
```

```ruby
def winner
  return :tie if @choice_1 == @choice_2
  if WINS.fetch(@choice_1)
    @choice_1
  else
    @choice_2
  end
end
```

All specs will now pass. Let's hide the implementation details by making the winner method private. All specs should still pass.

Let's make the exception user friendly, change the illegal input spec as follows:

```ruby
it "should raise exception when illegal input is provided" do
  expect do
    game = AngryRock::Game.new(:punk, :hunk)
    game.play
  end.to raise_error(IllegalChoice)
end
```

This fails with the error:

```ruby
1) AngryRock::Game should raise exception when illegal input is provided
   Failure/Error: end.to raise_error(IllegalChoice)
   NameError:
     uninitialized constant AngryRock::IllegalChoice
```

Change the angry_rock.rb as follows:

```ruby
module AngryRock 
  class IllegalChoice < Exception ; end;
  
  class Game
   ...   
    def winner
      return :tie if @choice_1 == @choice_2
      begin
        if WINS.fetch(@choice_1)
          @choice_1
        else
          @choice_2
        end
      rescue
        raise IllegalChoice
      end
    end
  end  
end
```

All specs now pass. This concise solution is based on Sinatra Up and Running By Alan Harris, Konstantin Haase. 

## Exercise ##

1. Look at the following alternative specs and implementation. This solution is based on Well Grounded Rubyist by David Black. It has been refactored to a better design. Make it even better by making the code expressive with readable specs. Compare your solution with the solutions given in the appendix.

angry_rock_spec.rb

```ruby
require 'spec_helper'

module Game
  describe AngryRock do
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
  end
end
```

angry_rock.rb

```ruby
module Game
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
        raise ArgumentError, "Something's wrong"
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
  
  class Play
    def initialize(first_choice, second_choice)
      choice_1 = AngryRock.new(first_choice)
      choice_2 = AngryRock.new(second_choice)
      
      @winner = choice_1.winner(choice_2)
    end
    def has_winner?
      !@winner.nil?
    end
    def winning_move
      @winner.move
    end
  end
end  
```
 
\newpage

