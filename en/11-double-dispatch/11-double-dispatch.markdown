# Double Dispatch #

## Objective ##

How to use double dispatch to make your code object oriented.

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

1. Run the specs by : $ rspec spec/angry_rock/game_spec.rb --color --format doc
2. Are we ready to deploy this code to production?
3. All tests pass. Test code is bad. Production code is bad. Can you ship the product ?
4. Refactored the test code. Started in Green state and ended in Green state.
5. We minimized if conditional statements. Moved it to the main partition and kept our application partition clean.
6. The game rules are encapsulated in the Rock, Paper and Scissors class.

\newpage

