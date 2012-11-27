# Bowling Game #

## Objectives ##

- Using domain specific term and eliminating implementation details in the spec.
- Focus on the 'What' instead of 'How'. Declarative vs Imperative.
- Fake it till you make it.
- When to delete tests?
- State Verification
- Scoring description and examples were translated to specs.
- BDD style tests read like sentences in a specification. 

## Scoring the Bowling Game ##

The specs we write will use the scoring rules found here http://www.bowling2u.com/trivia/game/scoring.asp. You can also refer Scoring Bowling.html at https://github.com/bparanj/polgar/tree/master/13-bowling-game-gem

## Version 1 ##

Create a file bowling_game_spec.rb with the following contents:

describe BowlingGame do
end

Run the spec:

$ rspec bowling_game_spec.rb --color

You get the error:

bowling_game_spec.rb:1:in `<top (required)>': uninitialized constant Object::BowlingGame (NameError)

Add the following code to the top of the bowling_game_spec.rb:

class BowlingGame
end

Run the spec :

	$ rspec bowling_game_spec.rb --color
	No examples found.

	Finished in 0.00005 seconds
	0 examples, 0 failures
	
Let's write our first spec:

describe BowlingGame do
  it 'scores all gutters with 0'
end

When you run the spec, you now get the output:

BowlingGame
  scores all gutters with 0 (PENDING: Not yet implemented)

Pending:
  BowlingGame scores all gutters with 0
    # Not yet implemented
    # ./bowling_game_spec.rb:6

Finished in 0.00029 seconds
1 example, 0 failures, 1 pending

You can use the 'it' block as a to do list of things to implement out of your head. Add another spec:

describe BowlingGame do
  it 'scores all gutters with 0'
  it "scores all 1's with 20"
end

When you run the specs, you now get the output:

BowlingGame
  scores all gutters with 0 (PENDING: Not yet implemented)
  scores all 1's with 20 (PENDING: Not yet implemented)

Pending:
  BowlingGame scores all gutters with 0
    # Not yet implemented
    # ./bowling_game_spec.rb:6
  BowlingGame scores all 1's with 20
    # Not yet implemented
    # ./bowling_game_spec.rb:7

Finished in 0.0003 seconds
2 examples, 0 failures, 2 pending

Let's now express our first requirement as follows:

it 'scores all gutters with 0' do
  game = BowlingGame.new
  
  20.times { game.roll(0) }
  
  expect(game.score).to eq(0)
end


When you run the specs, you now get the output:

1) BowlingGame scores all gutters with 0
   Failure/Error: 20.times { game.roll(0) }
   NoMethodError:
     undefined method `roll' for #<BowlingGame:0x000001011674c8>

The test is not failing for the right reason because it is due to an error in not defining roll method. We are in yellow state. Let's do the minimal thing to get past this error message by defining the roll method in BowlingGame class :

class BowlingGame
  def roll
  end
end

When you run the specs, you now get the output:

1) BowlingGame scores all gutters with 0
   Failure/Error: def roll
   ArgumentError:
     wrong number of arguments (1 for 0)

The test is not failing for the right reason because it is due to an error in the definition of roll method. We are in yellow state. Let's do the minimal thing required to get past this error by changing the roll method to take an input argument:

class BowlingGame
  def roll(number)
    
  end
end

When you run the specs, you now get the output:

1) BowlingGame scores all gutters with 0
    Failure/Error: expect(game.score).to eq(0)
    NoMethodError:
      undefined method `score' for #<BowlingGame:0x00000101165f38>

The test is not failing for the right reason because it is due to an error in the syntax of score method. We are in yellow state. Let's define a score method for the BowlingGame class.

class BowlingGame
  def roll(number)
    
  end
  def score
    
  end
end

When you run the specs, you now get the output:

1) BowlingGame scores all gutters with 0
    Failure/Error: expect(game.score).to eq(0) 
      expected: 0
           got: nil

Our test is failing for the right reason. We are now in red state. Let's change the score method like this:

def score
  0
end

When you run the specs, you now get the output:

BowlingGame
  scores all gutters with 0
  scores all 1's with 20 (PENDING: Not yet implemented)

Pending:
  BowlingGame scores all 1's with 20
    # Not yet implemented
    # ./bowling_game_spec.rb:20

Finished in 0.00138 seconds
2 examples, 0 failures, 1 pending

The first spec now passes. We are now green. Let's now express our second requirement:

it "scores all 1's with 20" do
  game = BowlingGame.new
  
  20.times { game.roll(1) }
  
  expect(game.score).to eq(20)    
end

When you run the specs, you now get the output:

1) BowlingGame scores all 1's with 20
    Failure/Error: expect(game.score).to eq(20)
      
      expected: 20
           got: 0

The spec is failing for the right reason. Change the implementation as follows:

class BowlingGame
  def initialize
    @score = 0
  end
  def roll(number)
    @score += number
  end
  def score
    @score
  end
end

When you run the specs, you now get the output:

BowlingGame
  scores all gutters with 0
  scores all 1's with 20

Finished in 0.00145 seconds
2 examples, 0 failures

We are now green. We did not go to the yellow state before we went green. This is ok. Let's cleanup our code like this:

class BowlingGame
  attr_reader :score
  
  def initialize
    @score = 0
  end
  def roll(number)
    @score += number
  end
end

All the specs still pass. Now there is no duplication in the production code, but what can we do to make it more expressive of the domain? Let's rename the number argument to pin like this:

class BowlingGame
  attr_reader :score
  
  def initialize
    @score = 0
  end
  def roll(pins)
    @score += pins
  end
end

The specs still passes since it does not depend on this implementation detail. Let's move the BowlingGame class into its own file bowling_game.rb. Add the require_relative to the top of the bowling_game_spec.rb:

require_relative 'bowling_game'

Run the specs again. It should pass. We cleaned up one thing after another, we were green before refactoring and ended in green after refactoring. Why should we not refactor in red state? Refer the appendix for the answer.

Now let's look the spec and see if we can refactor. The refactored specs look like this:

require_relative 'bowling_game'

describe BowlingGame do
  before do
    @game = BowlingGame.new
  end
  
  it 'scores all gutters with 0' do
    20.times { @game.roll(0) }
    
    expect(@game.score).to eq(0)
  end
  
  it "scores all 1's with 20" do
    20.times { @game.roll(1) }
    
    expect(@game.score).to eq(20)    
  end
end

The specs still pass. Here is a little exercise: Replace the before method with let and make all the specs pass.

Do you always need to take small steps when writing tests ? If you notice, we change either production code or the spec but not both at the same time. Regardless of whether we are refactoring or driving the design of our code. If we change both the spec and the production code at the same time we will not know which file is causing the problem. If we take small steps, we will be able to immediately fix the problem. Because we know what we just changed. If you are confident you can take bigger steps as long as the duration of the red state is minimum and you get to green and stay in green longer.

Let's review the production code. What's the 20.times { something } code doing? Can we raise the level of abstraction? Missing all the pins is a gutter game and striking all the pins is strike. Can we change the first spec to call a gutter method and the second spec to call the strike method? If we do so, then we will be focusing on the 'What' instead of 'How'. Looping is a sign that the spec is focusing on the implementation rather than specifying the behavior.

## Version 2 ##

Let's start over and apply what we have learned about the domain. Create game_spec.rb with the following code:

```ruby
require_relative 'game'

module Bowling
  describe Game do
    it "should return 0 for a miss (no pins are knocked down)" do
      game = Game.new
      game.miss
      
      expect(game.score).to eq(0)
    end
  end  
end
```

game.rb

```ruby
module Bowling
  
  class Game
    attr_reader :score
    
    def miss
      @score = 0
    end
  end
  
end
```

Run the spec:

$ rspec game_spec.rb --color

The miss method implementation helped to setup the require statements and get the spec working. When you are in a green state, you can checkin the code on a regular basis as you make progress. If you want to experiment with an alternative solution you can revert to an older version. This gives us the courage to experiment since we don't have to worry about losing our previous work. Here, we intelligently update our specs to reflect our understanding as we learn more about our gaming domain. 

## Version 3 ##

Let's add the second spec:

it "should return 10 for a strike (knocking down all ten pins)" do
  game = Game.new
  game.strike
  
  expect(game.score).to eq(10)
end

We get undefined method strike when we run the spec. Add the strike method to game.rb:

def strike
  @score = 10
end

The spec now passes. Let's write the third spec:

it "should return the number of pins hit for a spare" do
  game = Game.new
  game.spare(8)
  
  expect(game.score).to eq(8)
end

We now get the error : undefined method `spare'. Let's define this method like this:

def spare(pins)
  @score = pins
end

The spec now passes. We took a bigger step by providing a non-trival implementation of the spare method. When the implementation is straight forward you can just type in the real implementation. There is no need to triangulate or fake it till you make it. Since this method is just a one-liner we went ahead and implemented it. Let's write the fourth spec.


it "when a strike is bowled, the total score is 10 + 
    the total of the next two roll to that frame" do
  game = Game.new
  game.strike
  
  game.roll(7)
  game.roll(5)
  
  expect(game.score).to eq(22)
end

To make this spec pass, add the roll method to game.rb as follows:

def roll(pins)
  @score += pins
end

All the specs now pass. Let's review the doc string.

$ rspec game_spec.rb --color --format doc

Bowling::Game
  should return 0 for a miss (not knocking down any pins)
  should return 10 for a strike (knocking down all ten pins)
  should return the number of pins hit for a spare
  when a strike is bowled, the total score is 10 + 
        the total of the next two roll to that frame

Finished in 0.0019 seconds
4 examples, 0 failures

As you can see the second and fourth spec are the same scenario. It is for a strike. We can now delete the second spec because it is now superseded by the fourth spec. So our specs now looks like this:

require_relative 'game'

module Bowling
  describe Game do
    it "should return 0 for a miss (not knocking down any pins)" do
      game = Game.new
      game.miss
      
      expect(game.score).to eq(0)
    end
        
    it "should return the number of pins hit for a spare" do
      game = Game.new
      game.spare(8)
      
      expect(game.score).to eq(8)
    end
    
    it "when a strike is bowled, the total score is 10 + 
        the total of the next two roll to that frame" do
      game = Game.new
      game.strike
      
      game.roll(7)
      game.roll(5)
      
      expect(game.score).to eq(22)
    end
    
  end  
end

In this version we have implemented miss, strike, spare and roll methods. We deleted the spec that gave momentum but is no longer needed.


## Version 4 ##

Let's read the definition of the spare:

When a bowler knocks all ten pins down on the second ball roll they are said to have rolled a spare. The score keeper will mark a / for that frame and the bowlers score is the ten pins that they just knocked down plus they get to add to that what they knock down on their next ball roll. Consequently, you will not know what the bowers score is until the next frame!

Let's update our second spec to reflect our understanding of the spare concept as follows:

game_spec.rb

```ruby
it "should return 10 + number of pins knocked down in next roll for a spare" do
  game = Game.new
  game.spare
  game.roll(2)
  
  expect(game.score).to eq(12)
end
```

We now have to change the spare method signature and implementation as follows:

game.rb

```ruby
def spare
  @score = 10
end
```

The specs now pass. Notice that we are not blindly appending to our specs, we are updating the specs as we drive the design of our bowling gaming class.

## Version 5 ##

Let's write a spec to find the score for a perfect game, like this:

game_spec.rb

```ruby
    it "should return 300 for a perfect game" do
      game = Game.new
      30.times { game.strike }
      
      game.score.should == 300
    end
```

This fails with the error:

1) Bowling::Game should return 300 for a perfect game
   Failure/Error: game.score.should == 300
     expected: 300
          got: 10 (using ==)

To make this spec pass, we add the constructor and change strike method in game.rb as follows:

```ruby
module Bowling  
  class Game
    attr_reader :score
    
    def initialize
      @score = 0  
    end
    def strike
      @score += 10
    end
        
	...
  end
end
```

All specs now pass. The looping in the spec is not good. Let's now tackle it.

## Version 7 ##

Add repeat method to the spec_helper.rb :


def repeat(n)
   n.times { yield }
end

Change the spec to use the repeat method like this:

game_spec.rb

```ruby    
    it "should return 300 for a perfect game" do
      game = Game.new
      repeat(30) { game.strike } 
      
      game.score.should == 300
    end
```

Add

require_relative 'spec_helper'

to the top of the game_spec.rb. Now all the specs will pass. There is no change to the game.rb during this refactoring. We have now removed looping for the perfect game spec.

## Version 8 ##

Let's now implement the feature to get scores for given frame. Add the fifth spec as follows:

game_spec.rb

```ruby
require_relative 'spec_helper'
require_relative 'game'

module Bowling
  describe Game do

    it "should return a score of 8 for first hit of 6 pins and the
 				second hit of 2 pins for the first frame" do
      game = Game.new
      game.frame = 1
      
      game.roll(6)
      game.roll(2)
      
      game.score.should == 8
    end
    
  end  
end
```

To make this spec pass, add 

attr_accessor :frame

to the game.rb. The game ignores the frame during score calculation. We will drive the implementation to use the frame now by adding the following spec:


it "should return the score for a given frame to allow display of score" do
  game = Game.new
  
  game.roll(6)
  game.roll(2)
  
  game.score_for(1).should == [6, 2]      
end

Change the game.rb as follows:

```ruby
module Bowling
  
  class Game
    attr_reader :score
    attr_accessor :frame
    
    def initialize
      @score = 0
      @score_card = []
    end    
    def miss
      @score = 0
    end
    def strike
      @score += 10
    end
    def spare
      @score = 10
    end
    def roll(pins, frame = 1)
      @score += pins   
      update_score_card(pins, frame)   
    end    
    def score_for(frame)
      @score_card[frame]
    end
    
    private
    
    def update_score_card(pins, frame)
      if @score_card[frame].nil?
        @score_card[frame] = []
        @score_card[frame][0] = pins
      else
        @score_card[frame][1] = pins
      end
    end
  end
end
```

This implementation was arrived after playing in the irb with some sample data. All specs will now pass.

## Version 9 ##

Let's now tackle the scoring of multiple frames. Add the spec shown below:

game_spec.rb

```ruby
require_relative 'spec_helper'
require_relative 'game'

module Bowling
  describe Game do
    ...    
    it "should return the total score for first two frames of a game" do
      g = Game.new
      # Frame #1
      g.roll(6)
      g.roll(2)
      # Frame #2
      g.roll(7, 2)
      g.roll(1,2)
      
      g.score.should == 16
    end
    
  end  
end
```

This new spec passes without failing. Feature already implemented. Comments in the spec is bugging me. How can we make the code expressive so that we don't need any comments to clarify it's intention? To make the intent clear, we can make the second argument in the roll method a hash like this: roll(pins, args)

it "should return the total score for first two frames of a game" do
  game = Game.new
  game.roll(6)
  game.roll(2)
  game.roll(7, frame: 2)
  game.roll(1, frame: 2)
  
  expect(game.score).to eq(16)
end

The error is now:

1) Bowling::Game should return the total score for first two frames of a game
    Failure/Error: g.roll(7, frame: 2)
    TypeError:
      can't convert Hash into Integer

Change the roll method implementation in game.rb like this:

def roll(pins, args={})
  if args.empty?
    frame = 1
  else
    frame = args[:frame]
  end
  @score += pins   
  update_score_card(pins, frame)   
end

All the specs will pass. Let's extract the initializing code from the roll method to a private method:

def initialize_frame(args)
  return 1 if args.empty?

  args.fetch(:frame)
end

Note that we are using the fetch method which throws an exception if the value for a given key is not found. If we use [] method, then we will get a nil value which will cause crash our program due to nil value. When we fail we should fail loudly with verbose failure messages. If we fail silently, then the cause of the failure will be hidden and will be difficult to track down.

## Version 10 ##

Let's consider the scenario of rolling a strike on the second frame. Add the spec:

it "Rolling a strike : All 10 pins are hit on the first ball roll. 
			Score is 10 pins + Score for the next two ball rolls" do
  game = Game.new
  game.roll(6)
  game.roll(2)
  game.roll(10, frame: 2)
  game.roll(9, frame: 3)
  game.roll(0, frame: 3)

  expect(game.score).to eq(8 + 10 + 9 + 0)        
end

The spec passes. It can handle this scenario without making any changes to the existing implementation. Let's add a new spec to calculate total score up to a given frame:

it "Rolling a strike : should return the score upto a given frame that is
		  running total + 10 + the score for next two balls" do
  game = Game.new
  game.roll(6)
  game.roll(2)
  game.roll(7, frame: 2)
  game.roll(1, frame: 2)
  game.roll(10, frame: 3)
  game.roll(9, frame: 4)
  game.roll(0, frame: 4)
  
  total_score_upto_frame_3 = game.score_total_upto_frame(3)
  
  expect(total_score_upto_frame_3).to eq(6 + 2 + 7 + 1 + 10 + 9 + 0)
end

We get undefined method score_total_upto_frame error. Let' implement this method as follows:

def score_total_upto_frame(n)
  @score_card.flatten.inject{|x, sum| x += sum}
end

After fixing off by one error due to array index in frame numbers and fixing scoring logic bug for a strike, the solution is :

game.rb

```ruby
module Bowling
  
  class Game
    attr_reader :score
    attr_accessor :frame
    
    def initialize
      @score = 0
      @score_card = []
    end
    
    def miss
      @score = 0
    end
    
    def strike
      @score += 10
    end
    
    def spare
      @score = 10
    end
    
    def roll(pins, args={})
      frame = initialize_frame(args)
      @score += pins   
      update_score_card(pins, frame)   
      handle_strike_scoring(pins, frame) 
    end
    
    def score_for(n)
      @score_card[n - 1]
    end
    
    def score_total_upto_frame(n)
      @score_card.flatten.inject{|x, sum| x += sum}
    end
    
    private
    
    def update_score_card(pins, frame)
      if @score_card[frame - 1].nil?
        @score_card[frame - 1] = []
        @score_card[frame - 1][0] = pins
      else
        @score_card[frame - 1][1] = pins        
      end
    end
    
    def initialize_frame(args)
      return 1 if args.empty?

      args.fetch(:frame)
    end
    
    def handle_strike_scoring(pins, frame)
      # Check previous frame for a strike and update the score card
      if frame > 1
        score_array = score_for(frame - 2)
        # Is the previous hit a strike?
        if score_array && score_array.include?(10) 
          score_array << pins
        end
      end
    end
    
  end
  
end
```

## Version 11 ##

Let's consider a scenario where we hit a strike and then a spare. Add the following spec:

it "should return the score_total_upto_frame for a game that includes a strike and a spare" do
  game = Game.new
  game.roll(6)
  game.roll(2)
    
  game.roll(7, frame: 2)
  game.roll(1, frame: 2)
    
  game.roll(10, frame: 3)
    
  game.roll(9, frame: 4)
  game.roll(0, frame: 4)
  # A spare happens on the fifth frame
  game.roll(8, frame: 5)
  game.roll(2, frame: 5)
    
  game.roll(1, frame: 6)      
  
  game.score_total_upto_frame(5).should == 
		(6 + 2) + (7 + 1) + (10 + 9 + 0) + (9 + 0) + (8 + 2 + 1)      
end

This fails with the error:

expected: 55
           got: 56 (using ==)

Let's change the implementation of game.rb as follows:


module Bowling
  
  class Game
    attr_reader :score
    attr_accessor :frame
    
    def initialize
      @score = 0
      @score_card = []
    end
    
    def miss
      @score = 0
    end
    
    def strike
      @score += 10
    end
    
    def spare
      @score += 10
    end
    
    def roll(pins, args={})
      frame = initialize_frame(args)
      @score += pins   
      update_score_card(pins, frame)   
      update_strike_score
      update_spare_score
    end
    
    def score_for(n)
      @score_card[n - 1]
    end
    
    def score_total_upto_frame(n)
      @score_card.take(n).flatten.inject{|x, sum| x += sum}
    end
    
    private
    
    def update_score_card(pins, frame)
      if @score_card[frame - 1].nil?
        @score_card[frame - 1] = []
        @score_card[frame - 1][0] = pins
      else
        @score_card[frame - 1][1] = pins        
      end
    end
    
    def initialize_frame(args)
      return 1 if args.empty?

      args.fetch(:frame)
    end
    
    def update_strike_score
      strike_index = 100

      @score_card.each_with_index do |e, i|
       # Update the strike score only once
       if e.include?(10) and (e.size == 1)
         strike_index = i
       end
      end

      last_element_index = (@score_card.size - 1)
      if strike_index < last_element_index
        @score_card[strike_index] +=  @score_card[strike_index + 1]
      end
    end

    def update_spare_score
      spare_index = 100

      @score_card.each_with_index do |e, i|
        # Skip strike score
        unless e.include?(10)
          if (e.size == 2) and (e.inject(:+) == 10)
            spare_index = i
          end
        end
      end

      last_element_index = (@score_card.size - 1)
      if spare_index < last_element_index
        @score_card[spare_index] +=  [@score_card[last_element_index][0]]
      end
    end
    
  end
  
end

The spec now passes. Let's calculate the score for the same scenario.

it "should return the score for a game that includes a strike and a spare" do
   game = Game.new
   game.roll(6)
   game.roll(2)
     
   game.roll(7, frame: 2)
   game.roll(1, frame: 2)
     
   game.roll(10, frame: 3)
     
   game.roll(9, frame: 4)
   game.roll(0, frame: 4)
   # A spare happens on the fifth frame
   game.roll(8, frame: 5)
   game.roll(2, frame: 5)
     
   game.roll(1, frame: 6)      
   
   game.score.should == 
			(6 + 2) + (7 + 1) + (10 + 9 + 0) + (8 + 2 + 1)      
 end

This spec passes without failing.

## Version 14 ##

Let's use context to group related specs together.

game_spec.rb

```ruby
require_relative 'spec_helper'
require_relative 'game'

module Bowling
  describe Game do
    it "should return 0 for a miss (not knocking down any pins)" do
      game = Game.new
      game.miss
      
      expect(game.score).to eq(0)
    end
            
    it "should return a score of 8 for first hit of 6 pins and the
 				second hit of 2 pins for the first frame" do
      game = Game.new
      game.frame = 1
      
      game.roll(6)
      game.roll(2)
      
      expect(game.score).to eq(8)
    end
    
    it "should return the score for a given frame to allow display of score" do
      game = Game.new

      game.roll(6)
      game.roll(2)

      game.score_for(1).should == [6, 2]      
    end
    
    it "should return the total score for first two frames of a game" do
      game = Game.new
      game.roll(6)
      game.roll(2)
      game.roll(7, frame: 2)
      game.roll(1, frame: 2)
      
      expect(game.score).to eq(16)
    end
    
    it "should return 10 + number of pins knocked down in next roll for a spare" do
      game = Game.new
      game.spare
      game.roll(2)
      
      expect(game.score).to eq(12)
    end
    
    context 'Strike' do
      it "should return 300 for a perfect game" do
        game = Game.new
        repeat(30) { game.strike }

        expect(game.score).to eq(300)
      end

      it "when a strike is bowled, the total score is 10 + 
          the total of the next two roll to that frame" do
        game = Game.new
        game.strike

        game.roll(7)
        game.roll(5)

        expect(game.score).to eq(22)
      end

      it "Rolling a strike : All 10 pins are hit on the first ball roll. 
  				Score is 10 pins + Score for the next two ball rolls" do
        game = Game.new
        game.roll(6)
        game.roll(2)
        game.roll(10, frame: 2)
        game.roll(9, frame: 3)
        game.roll(0, frame: 3)

        expect(game.score).to eq(8 + 10 + 9 + 0)        
      end

      it "Rolling a strike : should return the score upto a given frame that is
  			  running total + 10 + the score for next two balls" do
        game = Game.new
        game.roll(6)
        game.roll(2)
        game.roll(7, frame: 2)
        game.roll(1, frame: 2)
        game.roll(10, frame: 3)
        game.roll(9, frame: 4)
        game.roll(0, frame: 4)

        total_score_upto_frame_3 = game.score_total_upto_frame(3)

        expect(total_score_upto_frame_3).to eq(6 + 2 + 7 + 1 + 10 + 9 + 0)
      end      
    end
    
    context 'Strike and a Spare' do
      it "should return the score_total_upto_frame for a game that includes a strike and a spare" do
        game = Game.new
        game.roll(6)
        game.roll(2)

        game.roll(7, frame: 2)
        game.roll(1, frame: 2)

        game.roll(10, frame: 3)

        game.roll(9, frame: 4)
        game.roll(0, frame: 4)
        # A spare happens on the fifth frame
        game.roll(8, frame: 5)
        game.roll(2, frame: 5)

        game.roll(1, frame: 6)      

        game.score_total_upto_frame(5).should == 
  			(6 + 2) + (7 + 1) + (10 + 9 + 0) + (9 + 0) + (8 + 2 + 1)      
      end

      it "should return the score for a game that includes a strike and a spare" do
        game = Game.new
        game.roll(6)
        game.roll(2)

        game.roll(7, frame: 2)
        game.roll(1, frame: 2)

        game.roll(10, frame: 3)

        game.roll(9, frame: 4)
        game.roll(0, frame: 4)
        # A spare happens on the fifth frame
        game.roll(8, frame: 5)
        game.roll(2, frame: 5)

        game.roll(1, frame: 6)      

        game.score.should == 
  			(6 + 2) + (7 + 1) + (10 + 9 + 0) + (8 + 2 + 1)      
      end      
    end

  end  
end
``` 

## Exercise ##

1. Use bundler gem command to generate a skeleton for bowling gem and covert the final bowling game version to a gem.
2. Make sure all the specs pass after converting it to a gem.
3. Compare your solution with https://github.com/bparanj/Bowing-Game
	- git clone https://github.com/bparanj/Bowing-Game
	- git log
	- You will see the commit hash for each commit like : 
	 		commit 5102f45b2c584cf2f5efaa17e9640c0c288bcf8d
		 You can checkout a particular commit by :
		  git co 5102f45b2c584cf2f5efaa17e9640c0c288bcf8d
4. git co a781d7c3b6542e89ef73707e3bf21d40956704b0 to get the BDD_Basics_I.mov screencast. Watch the demo screencast. 

## Question ##

Private methods are not tested. Why?


\newpage

