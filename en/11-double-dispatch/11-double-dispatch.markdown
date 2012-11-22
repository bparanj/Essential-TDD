# Double Dispatch #

## Objective ##

Learn how to use double dispatch to make your code object oriented.

## Analysis ##

> Possible combinations = 9
>
> Rock  Rock
> Rock  Paper
> Rock  Scissor

> Paper Rock
> Paper Paper
> Paper Scissor

> Scissor Rock
> Scissor Paper
> Scissor Scissor

> Number of items
> Rock 
> Paper
> Scissor

Create angry_rock_spec.rb with the following contents:


module AngryRock
  describe Game do
    it "picks paper as the winner over rock" do
      player_one = Player.new("Green Day")
      player_one.choice = :paper
      player_two = Player.new("Blue Planet")  
      player_two.choice = :rock
      
      game = Game.new(player_one, player_two)
      game.winner.should == 'Green Day'   
    end
  end
end

Create angry_rock.rb with the following contents:

module AngryRock
  class Game

  end  
end

The spec fails with the error:

1) AngryRock::Game picks paper as the winner over rock
    Failure/Error: player_one = Player.new("Green Day")
    NameError:
      uninitialized constant AngryRock::Player

Change the angry_rock.rb to :

module AngryRock
  class Game
    
  end
  
  class Player
    
  end
end

The spec fails with the error:

1) AngryRock::Game picks paper as the winner over rock
    Failure/Error: player_one = Player.new("Green Day")
    ArgumentError:
      wrong number of arguments(1 for 0)

Change the player class like this:

class Player
  def initialize(name)
    @name = name
  end    
end

The spec fails with the error:

1) AngryRock::Game picks paper as the winner over rock
   Failure/Error: player_one.choice = :paper
   NoMethodError:
     undefined method `choice=' for #<AngryRock::Player:0x007fc92928e7f0 @name="Green Day">

Add the setter for choice by changing the player class as follows:

class Player
  attr_writer :choice
  ...  
end

The spec fails with the error:

1) AngryRock::Game picks paper as the winner over rock
   Failure/Error: game = Game.new(player_one, player_two)
   ArgumentError:
     wrong number of arguments(2 for 0)

Change the game class as follows:

class Game
  def initialize(player_1, player_2)
    
  end    
end

The spec fails with the error:

1) AngryRock::Game picks paper as the winner over rock
    Failure/Error: game.winner.should == 'Green Day'
    NoMethodError:
      undefined method `winner' for #<AngryRock::Game:0x007f8a84224280>

Define the winner method in the game class like this:

class Game
  ...  
  def winner
    
  end 
end

The spec fails with the error:

1) AngryRock::Game picks paper as the winner over rock
   Failure/Error: game.winner.should == 'Green Day'
     expected: "Green Day"
          got: nil (using ==)


Change the winner method of the Game like this:

def winner
  'Green Day'
end

The first spec now passes. Let's add the second spec:

it "picks scissors as the winner over paper" do
  player_one = Player.new("Green Day")
  player_one.choice = :paper
  player_two = Player.new("Blue Planet")  
  player_two.choice = :scissor 
  
  game = Game.new(player_one, player_two)
  game.winner.should == 'Blue Planet'   
end

The spec fails with the error:

1) AngryRock::Game picks scissors as the winner over paper
   Failure/Error: game.winner.should == 'Blue Planet'
     expected: "Blue Planet"
          got: "Green Day" (using ==)

Let's encapsulate the game rules in rock, paper and scissor classes like this:

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

Change the angry_rock.rb implementation like this:

require_relative 'paper'
require_relative 'rock'
require_relative 'scissor'

module AngryRock
  class Game
    def initialize(player_1, player_2)
      @player_1 = player_1
      @player_2 = player_2
    end   
    
    def winner
      receiver = Object.const_get(@player_1.choice.capitalize).new
      target = Object.const_get(@player_2.choice.capitalize).new
      yes = receiver.beats(target)      
      if yes
        @player_1.name
      else
        @player_2.name
      end
    end 
  end
  
  class Player
    attr_reader :name
    attr_accessor :choice
    
    def initialize(name)
      @name = name
    end    
  end
end

Now both specs should pass. Go the irb console and type:

Object.const_get("String")
 => String 

As you can see if you give a string as the parameter to the Object.const_get method you get back a constant. In Ruby the name of a class is a constant. So we instantiate the class by doing:

Object.const_get(@player_1.choice.capitalize).new

If the first choice is :paper the receiver becomes and instance of the Paper class. We can now call the beats method on the receiver to check whether the receiver can beat the target object. If so, we know player one won otherwise player two won.

When we first make the :

receiver.beats(target)

call, it calls back one of the following methods on the appropriate game item:

beatsPaper
beatsRock
beatsScissor

and inverts the boolean flag to return the result. This is double dispatch in action. Comparing this solution to the Angry Rock chapter, it might seem that this solution is complex. For this problem, it is true. If the problem involves objects with complicated logic, this solution will be better. By using double dispatch we minimized conditional statements like if.

## Exercise ##

1. Clean up the dirty implementation by making the methods small and expressive. 
2. Add more specs for scenarios that we found in analysis section of this chapter.
3. Compare your solution to the solution shown in the appendix. 
4. Are we ready to deploy this code to production?
5. All tests pass. Test code is bad. Production code is bad. Can you ship the product ?


\newpage

