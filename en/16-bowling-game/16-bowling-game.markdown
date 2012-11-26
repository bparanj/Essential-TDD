# Bowling Game #

## Objectives ##

- Using domain specific term and eliminating implementation details in the spec.
- Focus on the 'What' instead of 'How'. Declarative vs Imperative.
- Fake it till you make it.
- When to delete tests?
- State Verification
- Scoring description and examples were translated to specs.
- BDD style tests read like sentences in a specification. 

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

Added rspec files. First test and method miss implemented. Miss method implementation helped to setup the require statements and get the spec working.

game_spec.rb

```ruby
require 'spec_helper'
require 'bowling/game'

module Bowling
  describe Game do
    it "should return 0 for a miss" do
      game = Game.new
      game.miss
      
      game.score.should == 0
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

## Version 3 ##

Implemented miss, strike, spare and roll methods.

game_spec.rb

```ruby
require 'spec_helper'
require 'bowling/game'

module Bowling
  describe Game do
    it "should return 0 for a miss (for not knocking down any pins)" do
      game = Game.new
      game.miss
      
      game.score.should == 0
    end
    
    it "should return 10 for a strike (for knocking down all ten pins)" do
      game = Game.new
      game.strike
      
      game.score.should == 10
    end
    
    it "should return the number of pins hit for a spare" do
      game = Game.new
      game.spare(8)
      
      game.score.should == 8
    end
    
    it "when a strike is bowled, the bowler is awarded the score of 10, 
				plus the total of the next two roll to that frame" do
      game = Game.new
      game.strike
      
      game.roll(7)
      game.roll(5)
      
      game.score.should == 22
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
    
    def strike
      @score = 10
    end
    
    def spare(pins)
      @score = pins
    end
    
    def roll(pins)
      @score += pins
    end
  end
  
end
```

## Version 4 ##

Corrected the representation of spare concept.

game_spec.rb

```ruby
require 'spec_helper'
require 'bowling/game'

module Bowling
  describe Game do
    it "should return 0 for a miss (for not knocking down any pins)" do
      game = Game.new
      game.miss
      
      game.score.should == 0
    end
    
    it "should return 10 for a strike (for knocking down all ten pins)" do
      game = Game.new
      game.strike
      
      game.score.should == 10
    end
    
    it "should return 10 for a spare (Remaining pins left standing 
				after the first roll are knocked down on the second roll)" do
      game = Game.new
      game.roll(7)
      game.roll(3)
      
      game.score.should == 10
    end
    
    it "when a strike is bowled, the bowler is awarded the score of 10, 
				plus the total of the next two roll to that frame" do
      game = Game.new
      game.strike
      
      game.roll(7)
      game.roll(5)
      
      game.score.should == 22
    end
  end  
end
```

game.rb

```ruby
module Bowling
  
  class Game
    attr_reader :score
    
    def initialize
      @score = 0  
    end
    
    def miss
      @score = 0
    end
    
    def strike
      @score = 10
    end
        
    def roll(pins)
      @score += pins
    end
  end
  
end
```

## Version 5 ##

Made the doc strings for the specs clear.

game_spec.rb

```ruby
require 'spec_helper'
require 'bowling/game'

module Bowling
  describe Game do
    it "should return 0 for a miss (for not knocking down any pins)" do
      game = Game.new
      game.miss
      
      game.score.should == 0
    end
    
    it "should return 10 for a strike (for knocking down all ten pins)" do
      game = Game.new
      game.strike
      
      game.score.should == 10
    end
    
    it "should return 10 for a spare (Remaining pins left standing 
				after the first roll are knocked down on the second roll)" do
      game = Game.new
      game.roll(7)
      game.roll(3)
      
      game.roll(2)
      
      game.score.should == 12
    end

    it "for a spare the bowler gets the 10 + the total number of 
				pins knocked down on the next roll only" do
      game = Game.new
      game.spare
      
      game.roll(2)
      
      game.score.should == 12
    end
    
    it "for a strike, the bowler gets the 10 + the total of 
				the next two roll to that frame" do
      game = Game.new
      game.strike
      
      game.roll(7)
      game.roll(5)
      
      game.score.should == 22
    end
  end  
end
```

game.rb

```ruby
module Bowling
  
  class Game
    attr_reader :score
    
    def initialize
      @score = 0  
    end
    
    def miss
      @score = 0
    end
    
    def spare
      @score += 10  
    end
    
    def strike
      @score = 10
    end
        
    def roll(pins)
      @score += pins
    end
  end
  
end
```

## Version 6 ##

Bug in strike game fixed by finding the score for a perfect game

game_spec.rb

```ruby
require 'spec_helper'
require 'bowling/game'

module Bowling
  describe Game do
    it "should return 0 for a miss (for not knocking down any pins)" do
      game = Game.new
      game.miss
      
      game.score.should == 0
    end
    
    it "should return 10 for a strike (for knocking down all ten pins)" do
      game = Game.new
      game.strike
      
      game.score.should == 10
    end
    
    it "should return 10 for a spare (Remaining pins left standing
	 			after the first roll are knocked down on the second roll)" do
      game = Game.new
      game.roll(7)
      game.roll(3)
      
      game.roll(2)
      
      game.score.should == 12
    end

    it "for a spare the bowler gets the 10 + the total number of pins 
				knocked down on the next roll only" do
      game = Game.new
      game.spare
      
      game.roll(2)
      
      game.score.should == 12
    end
    
    it "for a strike, the bowler gets the 10 + the total of the 
				next two roll to that frame" do
      game = Game.new
      game.strike
      
      game.roll(7)
      game.roll(5)
      
      game.score.should == 22
    end
    
    it "should return 300 for a perfect game" do
      game = Game.new
      30.times { game.strike }
      
      game.score.should == 300
    end
  end  
end
```

game.rb

```ruby
module Bowling
  
  class Game
    attr_reader :score
    
    def initialize
      @score = 0  
    end
    
    def miss
      @score = 0
    end
    
    def spare
      @score += 10  
    end
    
    def strike
      @score += 10
    end
        
    def roll(pins)
      @score += pins
    end
  end
  
end
```

## Version 7 ##

Removed looping for the perfect game spec.

game_spec.rb

```ruby
require 'spec_helper'
require 'bowling/game'

module Bowling
  describe Game do
    it "should return 0 for a miss (for not knocking down any pins)" do
      game = Game.new
      game.miss
      
      game.score.should == 0
    end
    
    it "should return 10 for a strike (for knocking down all ten pins)" do
      game = Game.new
      game.strike
      
      game.score.should == 10
    end
    
    it "should return 10 for a spare (Remaining pins left standing
	 			after the first roll are knocked down on the second roll)" do
      game = Game.new
      game.roll(7)
      game.roll(3)
      
      game.roll(2)
      
      game.score.should == 12
    end

    it "for a spare the bowler gets the 10 + the total number of 
				pins knocked down on the next roll only" do
      game = Game.new
      game.spare
      
      game.roll(2)
      
      game.score.should == 12
    end
    
    it "for a strike, the bowler gets the 10 + the total of the
 				next two roll to that frame" do
      game = Game.new
      game.strike
      
      game.roll(7)
      game.roll(5)
      
      game.score.should == 22
    end
    
    it "should return 300 for a perfect game" do
      game = Game.new
      repeat(30) { game.strike } 
      
      game.score.should == 300
    end
  end  
end
```

game.rb

```ruby
module Bowling
  
  class Game
    attr_reader :score
    
    def initialize
      @score = 0  
    end
    
    def miss
      @score = 0
    end
    
    def spare
      @score += 10  
    end
    
    def strike
      @score += 10
    end
        
    def roll(pins)
      @score += pins
    end
  end
  
end
```

## Version 8 ##

Implemented feature to get scores for given frame.

game_spec.rb

```ruby
require 'spec_helper'
require 'bowling/game'

module Bowling
  describe Game do
    it "should return 0 for a miss (for not knocking down any pins)" do
      game = Game.new
      game.miss
      
      game.score.should == 0
    end
    
    it "should return 10 for a strike (for knocking down all ten pins)" do
      game = Game.new
      game.strike
      
      game.score.should == 10
    end
    
    it "should return 10 for a spare (Remaining pins left standing 
				after the first roll are knocked down on the second roll)" do
      game = Game.new
      game.roll(7)
      game.roll(3)
      
      game.roll(2)
      
      game.score.should == 12
    end

    it "for a spare the bowler gets the 10 + the total number of 
				pins knocked down on the next roll only" do
      game = Game.new
      game.spare
      
      game.roll(2)
      
      game.score.should == 12
    end
    
    it "for a strike, the bowler gets the 10 + the total of the 
				next two roll to that frame" do
      game = Game.new
      game.strike
      
      game.roll(7)
      game.roll(5)
      
      game.score.should == 22
    end
    
    it "should return 300 for a perfect game" do
      game = Game.new
      repeat(30) { game.strike } 
      
      game.score.should == 300
    end
    
    it "should return a score of 8 for first hit of 6 pins and the
 				second hit of 2 pins for the first frame" do
      game = Game.new
      game.frame = 1
      
      game.roll(6)
      game.roll(2)
      
      game.score.should == 8
    end
    
    it "should return the score for a given frame to allow display of score" do
      game = Game.new
      
      game.roll(6)
      game.roll(2)
      
      game.score_for(1).should == [6, 2]      
    end
  end  
end
```

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
    
    def spare
      @score += 10  
    end
    
    def strike
      @score += 10
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

## Version 9 ##

Scoring multiple frames. This new test passes without failing. Feature already implemented.

game_spec.rb

```ruby
require 'spec_helper'
require 'bowling/game'

module Bowling
  describe Game do
    it "should return 0 for a miss (for not knocking down any pins)" do
      game = Game.new
      game.miss
      
      game.score.should == 0
    end
    
    it "should return 10 for a strike (for knocking down all ten pins)" do
      game = Game.new
      game.strike
      
      game.score.should == 10
    end
    
    it "should return 10 for a spare (Remaining pins left standing 
				after the first roll are knocked down on the second roll)" do
      game = Game.new
      game.roll(7)
      game.roll(3)
      
      game.roll(2)
      
      game.score.should == 12
    end

    it "for a spare the bowler gets the 10 + the total number of 
				pins knocked down on the next roll only" do
      game = Game.new
      game.spare
      
      game.roll(2)
      
      game.score.should == 12
    end
    
    it "for a strike, the bowler gets the 10 + the total of the 
				next two roll to that frame" do
      game = Game.new
      game.strike
      
      game.roll(7)
      game.roll(5)
      
      game.score.should == 22
    end
    
    it "should return 300 for a perfect game" do
      game = Game.new
      repeat(30) { game.strike } 
      
      game.score.should == 300
    end
    
    it "should return a score of 8 for first hit of 6 pins and 
				the second hit of 2 pins for the first frame" do
      game = Game.new
      game.frame = 1
      
      game.roll(6)
      game.roll(2)
      
      game.score.should == 8
    end
    
    it "should return the score for a given frame to allow display of score" do
      game = Game.new
      
      game.roll(6)
      game.roll(2)
      
      game.score_for(1).should == [6, 2]      
    end
    # This test passed without failing. Gave me confidence 
		# it can handle scoring multiple frames
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
    
    def spare
      @score += 10  
    end
    
    def strike
      @score += 10
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

## Version 10 ##

Fixed off by one error due to array index and frame numbers. Fixed scoring logic bug for a strike.

game_spec.rb

```ruby
require 'spec_helper'
require 'bowling/game'

module Bowling
  describe Game do

    it "should return 0 for a miss (for not knocking down any pins)" do
      game = Game.new
      game.miss

      game.score.should == 0
    end

    it "should return 10 for a strike (for knocking down all ten pins)" do
      game = Game.new
      game.strike

      game.score.should == 10
    end

    it "should return 10 for a spare (Remaining pins left standing after 
				the first roll are knocked down on the second roll)" do
      game = Game.new
      game.roll(7)
      game.roll(3)

      game.roll(2)

      game.score.should == 12
    end

    it "for a spare the bowler gets the 10 + the total number of pins 
			  knocked down on the next roll only" do
      game = Game.new
      game.spare

      game.roll(2)

      game.score.should == 12
    end

    it "for a strike, the bowler gets the 10 + the total of the 
			  next two roll to that frame" do
      game = Game.new
      game.strike

      game.roll(7)
      game.roll(5)

      game.score.should == 22
    end

    it "should return 300 for a perfect game" do
      game = Game.new
      repeat(30) { game.strike } 

      game.score.should == 300
    end

    it "should return a score of 8 for first hit of 6 pins and the 
				second hit of 2 pins for the first frame" do
      game = Game.new
      game.frame = 1

      game.roll(6)
      game.roll(2)

      game.score.should == 8
    end

    it "should return the score for a given frame to allow display of score" do
      game = Game.new

      game.roll(6)
      game.roll(2)

      game.score_for_frame(1).should == [6, 2]      
    end
    # This test passed without failing. Gave me confidence it 
		# can handle scoring multiple frames
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

    context "Bonus Scoring : All 10 pins are hit." do
      it "Rolling a strike : All 10 pins are hit on the first ball roll. 
					Score is 10 pins + Score for the next two ball rolls" do
        g = Game.new
        # Frame 1
        g.roll(6)
        g.roll(2)
        # Frame 2
        g.roll(10,2)
        # Frame 3
        g.roll(9, 3)
        g.roll(0, 3)

        g.score.should == (8 + 10 + 9 + 0)        
      end

      it "should return the score of a given frame by adding to the
 				  running total + 10 + the score for next two balls for a strike" do
        g = Game.new
        # Frame 1
        g.roll(6)
        g.roll(2)
        # Frame 2
        g.roll(7, 2)
        g.roll(1, 2)
        # Frame 3        
        g.roll(10,3)
        # Frame 4
        g.roll(9, 4)
        g.roll(0, 4)

        g.score_total_upto_frame(3).should == (6 + 2 + 7 + 1 + 10 + 9 + 0)
      end
    end
  end  
end
```

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
    
    def spare
      @score += 10  
    end
    
    def strike
      @score += 10
    end
        
    def roll(pins, frame = 1)
      @score += pins   
      update_score_card(pins, frame)  
      handle_strike_scoring(pins, frame) 
    end
    
    def score_for_frame(n)
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
    
    def handle_strike_scoring(pins, frame)
      # Check previous frame for a strike and update the score card
      if frame > 1
        score_array = score_for_frame(frame - 2)
        # Is the previous hit a strike?
        if score_array.include?(10) 
          score_array << pins
        end
      end
    end
  end
  
end
```

## Version 11 ##

Removed code that was not working to update the score card for a strike.

game_spec.rb

```ruby
require 'spec_helper'
require 'bowling/game'

module Bowling
  describe Game do

    it "should return 0 for a miss (for not knocking down any pins)" do
      game = Game.new
      game.miss

      game.score.should == 0
    end

    it "should return 10 for a strike (for knocking down all ten pins)" do
      game = Game.new
      game.strike

      game.score.should == 10
    end

    it "should return 10 for a spare (Remaining pins left standing after 
				the first roll are knocked down on the second roll)" do
      game = Game.new
      game.roll(7)
      game.roll(3)

      game.roll(2)

      game.score.should == 12
    end

    it "for a spare the bowler gets the 10 + the total number of 
				pins knocked down on the next roll only" do
      game = Game.new
      game.spare

      game.roll(2)

      game.score.should == 12
    end

    it "for a strike, the bowler gets the 10 + the total of 
				the next two roll to that frame" do
      game = Game.new
      game.strike

      game.roll(7)
      game.roll(5)

      game.score.should == 22
    end

    it "should return 300 for a perfect game" do
      game = Game.new
      repeat(30) { game.strike } 

      game.score.should == 300
    end

    it "should return a score of 8 for first hit of 6 pins and the 
				second hit of 2 pins for the first frame" do
      game = Game.new
      game.frame = 1

      game.roll(6)
      game.roll(2)

      game.score.should == 8
    end

    it "should return the score for a given frame to allow display of score" do
      game = Game.new

      game.roll(6)
      game.roll(2)

      game.score_for_frame(1).should == [6, 2]      
    end
    # This test passed without failing. Gave me confidence it can 
		# handle scoring multiple frames
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

    context "Bonus Scoring : All 10 pins are hit." do
      it "Rolling a strike : All 10 pins are hit on the first ball roll. " do
				# Score is 10 pins + Score for the next two ball rolls
        g = Game.new
        # Frame 1
        g.roll(6)
        g.roll(2)
        # Frame 2
        g.roll(10,2)
        # Frame 3
        g.roll(9, 3)
        g.roll(0, 3)

        g.score.should == (8 + 10 + 9 + 0)        
      end

      it "should return the score of a given frame by adding to the " do
				# running total + 10 + the score for next two balls for a strike
        g = Game.new
        # Frame 1
        g.roll(6)
        g.roll(2)
        # Frame 2
        g.roll(7, 2)
        g.roll(1, 2)
        # Frame 3        
        g.roll(10,3)
        # Frame 4
        g.roll(9, 4)
        g.roll(0, 4)

        g.score_total_upto_frame(3).should == (6 + 2 + 7 + 1 + 10 + 9 + 0)
      end
    end
  end  
end
```

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
    
    def spare
      @score += 10  
    end
    
    def strike
      @score += 10
    end
        
    def roll(pins, frame = 1)
      @score += pins   
      update_score_card(pins, frame)  
    end
    
    def score_for_frame(n)
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
    
  end
  
end
```

## Version 12 ##

Implemented score calculation for a game that includes a strike.

game_spec.rb

```ruby
require 'spec_helper'
require 'bowling/game'

module Bowling
  describe Game do

    it "should return 0 for a miss (for not knocking down any pins)" do
      game = Game.new
      game.miss

      game.score.should == 0
    end

    it "should return 10 for a strike (for knocking down all ten pins)" do
      game = Game.new
      game.strike

      game.score.should == 10
    end

    it "should return 10 for a spare (Remaining pins left standing " do
			# after the first roll are knocked down on the second roll)
      game = Game.new
      game.roll(7)
      game.roll(3)

      game.roll(2)

      game.score.should == 12
    end

    it "for a spare the bowler gets the 10 + the total number of pins " do
			# knocked down on the next roll only
      game = Game.new
      game.spare

      game.roll(2)

      game.score.should == 12
    end

    it "for a strike, the bowler gets the 10 + the total of the next " do
			# two roll to that frame
      game = Game.new
      game.strike

      game.roll(7)
      game.roll(5)

      game.score.should == 22
    end

    it "should return 300 for a perfect game" do
      game = Game.new
      repeat(30) { game.strike } 

      game.score.should == 300
    end

    it "should return a score of 8 for first hit of 6 pins and the " do
			# second hit of 2 pins for the first frame
      game = Game.new
      game.frame = 1

      game.roll(6)
      game.roll(2)

      game.score.should == 8
    end

    it "should return the score for a given frame to allow display of score" do
      game = Game.new

      game.roll(6)
      game.roll(2)

      game.score_for_frame(1).should == [6, 2]      
    end
    # This test passed without failing. Gave me confidence it can 
		# handle scoring multiple frames
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

    context "Bonus Scoring : All 10 pins are hit." do
      it "Rolling a strike : All 10 pins are hit on the first ball roll. " do
				# Score is 10 pins + Score for the next two ball rolls
        g = Game.new
        # Frame 1
        g.roll(6)
        g.roll(2)
        # Frame 2
        g.roll(10,2)
        # Frame 3
        g.roll(9, 3)
        g.roll(0, 3)

        g.score.should == (8 + 10 + 9 + 0)        
      end

      it "should return the score of a given frame by adding to the" do
				#  running total + 10 + the score for next two balls for a strike
        g = Game.new
        # Frame 1
        g.roll(6)
        g.roll(2)
        # Frame 2
        g.roll(7, 2)
        g.roll(1, 2)
        # Frame 3        
        g.roll(10,3)
        # Frame 4
        g.roll(9, 4)
        g.roll(1, 4)
        # score_total_upto_frame(3) should be 36
        g.score_total_upto_frame(3).should == (6 + 2 + 7 + 1 + 10 + 9 + 1)
      end
      
      it "should return the total score of the game that includes a strike" do
        g = Game.new
        
        g.frame_set do
          g.roll(6)
          g.roll(2)

          g.roll(7,2)
          g.roll(1,2)          
        
          g.roll(10,3)

          g.roll(9,4)
          g.roll(1,4)          
        end

        g.score_total_upto_frame(4).should == (6 + 2 + 7 + 1 + 10 + 9 + 1 + 9 + 1)
      end
      
    end
  end  
end
```

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
    
    def spare
      @score += 10  
    end
    
    def strike
      @score += 10
    end
        
    def roll(pins, frame = 1)
      @score += pins   
      update_score_card(pins, frame)  
    end
    
    def score_for_frame(n)
      @score_card[n - 1]
    end
    
    def score_total_upto_frame(n)
      @score_card.flatten.inject{|x, sum| x += sum}
    end
    
    def frame_set
      yield 
      update_strike_score
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
        @score_card[strike_index] +=  @score_card[last_element_index]
      end
    end
  end
  
end
```

## Version 13 ##

Completed scoring of spare. Fixed bug in update_strike_score method.

game_spec.rb

```ruby
require 'spec_helper'
require 'bowling/game'

module Bowling
  describe Game do

    it "should return 0 for a miss (for not knocking down any pins)" do
      game = Game.new
      game.miss

      game.score.should == 0
    end

    it "should return 10 for a strike (for knocking down all ten pins)" do
      game = Game.new
      game.strike

      game.score.should == 10
    end

    it "should return 10 for a spare (Remaining pins left standing " do
			# after the first roll are knocked down on the second roll)
      game = Game.new
      game.roll(7)
      game.roll(3)

      game.roll(2)

      game.score.should == 12
    end

    it "for a spare the bowler gets the 10 + the total number of pins " do
			# knocked down on the next roll only
      game = Game.new
      game.spare

      game.roll(2)

      game.score.should == 12
    end

    it "for a strike, the bowler gets the 10 + the total of the next two" do
			# roll to that frame
      game = Game.new
      game.strike

      game.roll(7)
      game.roll(5)

      game.score.should == 22
    end

    it "should return 300 for a perfect game" do
      game = Game.new
      repeat(30) { game.strike } 

      game.score.should == 300
    end

    it "should return a score of 8 for first hit of 6 pins and the second " do
			# hit of 2 pins for the first frame
      game = Game.new
      game.frame = 1

      game.roll(6)
      game.roll(2)

      game.score.should == 8
    end

    it "should return the score for a given frame to allow display of score" do
      game = Game.new

      game.roll(6)
      game.roll(2)

      game.score_for_frame(1).should == [6, 2]      
    end
    # This test passed without failing. Gave me confidence it can 
		# handle scoring multiple frames
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

    context "Bonus Scoring : All 10 pins are hit on the first ball roll." do
			#  The Strike
      it "Rolling a strike : All 10 pins are hit on the first ball roll. " do
				# Score is 10 pins + Score for the next two ball rolls
        g = Game.new
        # Frame 1
        g.roll(6)
        g.roll(2)
        # Frame 2
        g.roll(10,2)
        # Frame 3
        g.roll(9, 3)
        g.roll(0, 3)

        g.score.should == (8 + 10 + 9 + 0)        
      end

      it "should return the score of a given frame by adding to "  do
				# the running total + 10 + the score for next two balls for a strike
        g = Game.new
        g.frame_set do
          # Frame 1
          g.roll(6)
          g.roll(2)
          # Frame 2
          g.roll(7, 2)
          g.roll(1, 2)
          # Frame 3        
          g.roll(10,3)
          # Frame 4
          g.roll(9, 4)
          g.roll(1, 4)
        end
        # score_total_upto_frame(3) should be 36
        g.score_total_upto_frame(3).should == (6 + 2 + 7 + 1 + 10 + 9 + 1)
      end
      
      it "should return the total score of the game that includes a strike" do
        g = Game.new
        
        g.frame_set do
          g.roll(6)
          g.roll(2)

          g.roll(7,2)
          g.roll(1,2)          
        
          g.roll(10,3)

          g.roll(9,4)
          g.roll(1,4)          
        end
        # g.score_total_upto_frame(4) is 46
        g.score_total_upto_frame(4).should == (6 + 2 + 7 + 1 + 10 + 9 + 1 + 9 + 1)
      end
      
      context "Bonus Scoring : All 10 pins are hit on the second ball roll." do
				# The Spare
        it "should return the score that is ten pins + " do
					# number of pins hit on the next ball roll
          g = Game.new
          
          g.frame_set do
            g.roll(6)
            g.roll(2)
            
            g.roll(7,2)
            g.roll(1,2)
            
            g.roll(10, 3)
            
            g.roll(9,4)
            g.roll(0,4)
            # A spare happens on the fifth frame
            g.roll(8,5)
            g.roll(2,5)
            
            g.roll(1, 6)
            
          end 
          # 55
          p g.score_total_upto_frame(5)
          g.score_total_upto_frame(5).should == 
					(6 + 2) + (7 + 1) + (10 + 9 + 0) + (9 + 0) + (8 + 2 + 1)
          
        end
      end
      
    end
  end  
end
```

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
    
    def spare
      @score += 10  
    end
    
    def strike
      @score += 10
    end
        
    def roll(pins, frame = 1)
      @score += pins   
      update_score_card(pins, frame)  
    end
    
    def score_for_frame(n)
      @score_card[n - 1]
    end
    
    def score_total_upto_frame(n)
      @score_card.take(n).flatten.inject{|x, sum| x += sum}
    end
    
    def frame_set
      yield 
      update_strike_score
      update_spare_score
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
```

## Version 14 ##

Fixed the wrong nested context spec.

game_spec.rb

```ruby
require 'spec_helper'
require 'bowling/game'

module Bowling
  describe Game do

    it "should return 0 for a miss (for not knocking down any pins)" do
      game = Game.new
      game.miss

      game.score.should == 0
    end

    it "should return 10 for a strike (for knocking down all ten pins)" do
      game = Game.new
      game.strike

      game.score.should == 10
    end

    it "should return 10 for a spare (Remaining pins left standing after" do
			# the first roll are knocked down on the second roll)
      game = Game.new
      game.roll(7)
      game.roll(3)

      game.roll(2)

      game.score.should == 12
    end

    it "for a spare the bowler gets the 10 + the total number of pins" do
			# knocked down on the next roll only
      game = Game.new
      game.spare

      game.roll(2)

      game.score.should == 12
    end

    it "for a strike, the bowler gets the 10 + the total of the next" do
			# two roll to that frame
      game = Game.new
      game.strike

      game.roll(7)
      game.roll(5)

      game.score.should == 22
    end

    it "should return 300 for a perfect game" do
      game = Game.new
      repeat(30) { game.strike } 

      game.score.should == 300
    end

    it "should return a score of 8 for first hit of 6 pins and the second" do
			# hit of 2 pins for the first frame
      game = Game.new
      game.frame = 1

      game.roll(6)
      game.roll(2)

      game.score.should == 8
    end

    it "should return the score for a given frame to allow display of score" do
      game = Game.new

      game.roll(6)
      game.roll(2)

      game.score_for_frame(1).should == [6, 2]      
    end
    # This test passed without failing. Gave me confidence it can 
    # handle scoring multiple frames
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

    context "Bonus Scoring : All 10 pins are hit on the first ball roll." do
		  # The Strike
      it "Rolling a strike : All 10 pins are hit on the first ball roll." do
			# Score is 10 pins + Score for the next two ball rolls
        g = Game.new
        # Frame 1
        g.roll(6)
        g.roll(2)
        # Frame 2
        g.roll(10,2)
        # Frame 3
        g.roll(9, 3)
        g.roll(0, 3)

        g.score.should == (8 + 10 + 9 + 0)        
      end

      it "should return the score of a given frame by adding to the"  do
				# running total + 10 + the score for next two balls for a strike
        g = Game.new
        g.frame_set do
          # Frame 1
          g.roll(6)
          g.roll(2)
          # Frame 2
          g.roll(7, 2)
          g.roll(1, 2)
          # Frame 3        
          g.roll(10,3)
          # Frame 4
          g.roll(9, 4)
          g.roll(1, 4)
        end
        # score_total_upto_frame(3) should be 36
        g.score_total_upto_frame(3).should == 
					(6 + 2 + 7 + 1 + 10 + 9 + 1)
      end
      
      it "should return the total score of the game that includes a strike" do
        g = Game.new
        
        g.frame_set do
          g.roll(6)
          g.roll(2)

          g.roll(7,2)
          g.roll(1,2)          
        
          g.roll(10,3)

          g.roll(9,4)
          g.roll(1,4)          
        end
        # g.score_total_upto_frame(4) is 46
        g.score_total_upto_frame(4).should == 
					(6 + 2 + 7 + 1 + 10 + 9 + 1 + 9 + 1)
      end
      
    end
    
    context "Bonus Scoring : All 10 pins are hit on the second ball roll." do
			# The Spare
      it "should return the score that is ten pins +" do
				# number of pins hit on the next ball roll
        g = Game.new
        
        g.frame_set do
          g.roll(6)
          g.roll(2)
          
          g.roll(7,2)
          g.roll(1,2)
          
          g.roll(10, 3)
          
          g.roll(9,4)
          g.roll(0,4)
          # A spare happens on the fifth frame
          g.roll(8,5)
          g.roll(2,5)
          
          g.roll(1, 6)
          
        end 
        # 55
        # p g.score_total_upto_frame(5)
        g.score_total_upto_frame(5).should == 
						(6 + 2) + (7 + 1) + (10 + 9 + 0) + (9 + 0) + (8 + 2 + 1)          
      end        
    end
    
  end  
end
```

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
    
    def spare
      @score += 10  
    end
    
    def strike
      @score += 10
    end
        
    def roll(pins, frame = 1)
      @score += pins   
      update_score_card(pins, frame)  
    end
    
    def score_for_frame(n)
      @score_card[n - 1]
    end
    
    def score_total_upto_frame(n)
      @score_card.take(n).flatten.inject{|x, sum| x += sum}
    end
    
    def frame_set
      yield 
      update_strike_score
      update_spare_score
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
```

## Version 15 ##

Deleted the first few specs that gave momentum but is no longer needed. Deleted code that is not needed.

game_spec.rb

```ruby
require 'spec_helper'
require 'bowling/game'

module Bowling
  describe Game do

    it "for a strike, the bowler gets the 10 + the total of the" do
		  # next two roll to that frame
      game = Game.new
      game.strike

      game.roll(7)
      game.roll(5)

      game.score.should == 22
    end

    it "should return 300 for a perfect game" do
      game = Game.new
      repeat(30) { game.strike } 

      game.score.should == 300
    end

    it "should return a score of 8 for first hit of 6 pins and the second" do
		  # hit of 2 pins for the first frame
      game = Game.new
      game.frame = 1

      game.roll(6)
      game.roll(2)

      game.score.should == 8
    end

    it "should return the score for a given frame to allow display of score" do
      game = Game.new

      game.roll(6)
      game.roll(2)

      game.score_for_frame(1).should == [6, 2]      
    end
    # This test passed without failing. Gave me confidence it can handle 
    # scoring multiple frames
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

    context "Bonus Scoring : All 10 pins are hit on the first ball roll." do
		  # The Strike
      it "Rolling a strike : All 10 pins are hit on the first ball roll." do
			  # Score is 10 pins + Score for the next two ball rolls
        g = Game.new
        # Frame 1
        g.roll(6)
        g.roll(2)
        # Frame 2
        g.roll(10,2)
        # Frame 3
        g.roll(9, 3)
        g.roll(0, 3)

        g.score.should == (8 + 10 + 9 + 0)        
      end

      it "return the score of a given frame by adding to the running"  do
 				# total + 10 + the score for next two balls for a strike
        g = Game.new
        g.frame_set do
          # Frame 1
          g.roll(6)
          g.roll(2)
          # Frame 2
          g.roll(7, 2)
          g.roll(1, 2)
          # Frame 3        
          g.roll(10,3)
          # Frame 4
          g.roll(9, 4)
          g.roll(1, 4)
        end
        # score_total_upto_frame(3) should be 36
        g.score_total_upto_frame(3).should == (6 + 2 + 7 + 1 + 10 + 9 + 1)
      end
      
      it "should return the total score of the game that includes a strike" do
        g = Game.new
        
        g.frame_set do
          g.roll(6)
          g.roll(2)

          g.roll(7,2)
          g.roll(1,2)          
        
          g.roll(10,3)

          g.roll(9,4)
          g.roll(1,4)          
        end
        # g.score_total_upto_frame(4) is 46
        g.score_total_upto_frame(4).should == 
										(6 + 2 + 7 + 1 + 10 + 9 + 1 + 9 + 1)
      end
      
    end
    
    context "Bonus Scoring : All 10 pins are hit on the second ball roll." do
			# The Spare
      it "should return the score that is ten pins + number of" do
			  # pins hit on the next ball roll
        g = Game.new
        
        g.frame_set do
          g.roll(6)
          g.roll(2)
          
          g.roll(7,2)
          g.roll(1,2)
          
          g.roll(10, 3)
          
          g.roll(9,4)
          g.roll(0,4)
          # A spare happens on the fifth frame
          g.roll(8,5)
          g.roll(2,5)
          
          g.roll(1, 6)
          
        end 
        # 55
        # p g.score_total_upto_frame(5)
        g.score_total_upto_frame(5).should == (6 + 2) + (7 + 1) + 
																							(10 + 9 + 0) + (9 + 0) + 
																							(8 + 2 + 1)          
      end        
    end
    
  end  
end
```

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
    
    def strike
      @score += 10
    end
        
    def roll(pins, frame = 1)
      @score += pins   
      update_score_card(pins, frame)  
    end
    
    def score_for_frame(n)
      @score_card[n - 1]
    end
    
    def score_total_upto_frame(n)
      @score_card.take(n).flatten.inject{|x, sum| x += sum}
    end
    
    def frame_set
      yield 
      update_strike_score
      update_spare_score
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
```

## Version 16 ##

game_spec.rb

```ruby
require 'spec_helper'
require 'bowling/game'

module Bowling
  describe Game do

    it "for a strike, the bowler gets the 10 + the total " do
		# of the next two roll to that frame
      game = Game.new
      game.strike

      game.roll(7)
      game.roll(5)

      game.score.should == 22
    end

    it "should return 300 for a perfect game" do
      game = Game.new
      repeat(30) { game.strike } 

      game.score.should == 300
    end

    it "should return a score of 8 for first hit of 6 pins and the " do
		  # second hit of 2 pins for the first frame
      game = Game.new
      game.frame = 1

      game.roll(6)
      game.roll(2)

      game.score.should == 8
    end

    it "should return the score for a given frame to allow display of score" do
      game = Game.new

      game.roll(6)
      game.roll(2)

      game.score_for_frame(1).should == [6, 2]      
    end
    # This test passed without failing. Gave me confidence it can handle 
    # scoring multiple frames
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

    context "Bonus Scoring : All 10 pins are hit on the first ball roll. 
						 The Strike" do
      it "Score is 10 pins + Score for the next two ball rolls" do
        g = Game.new
        # Frame 1
        g.roll(6)
        g.roll(2)
        # Frame 2
        g.roll(10,2)
        # Frame 3
        g.roll(9, 3)
        g.roll(0, 3)

        g.score.should == (8 + 10 + 9 + 0)        
      end

      it "return the score of a given frame by adding to the running 
				  total + 10 + the score for next two balls for a strike"  do
        g = Game.new
        g.frame_set do
          # Frame 1
          g.roll(6)
          g.roll(2)
          # Frame 2
          g.roll(7, 2)
          g.roll(1, 2)
          # Frame 3        
          g.roll(10,3)
          # Frame 4
          g.roll(9, 4)
          g.roll(1, 4)
        end
        # score_total_upto_frame(3) should be 36
        g.score_total_upto_frame(3).should == (6 + 2 + 7 + 1 + 10 + 9 + 1)
      end
      
      it "should return the total score of the game that includes a strike" do
        g = Game.new
        
        g.frame_set do
          g.roll(6)
          g.roll(2)

          g.roll(7,2)
          g.roll(1,2)          
        
          g.roll(10,3)

          g.roll(9,4)
          g.roll(1,4)          
        end
        # g.score_total_upto_frame(4) is 46
        g.score_total_upto_frame(4).should == (6 + 2 + 7 + 1 + 10 + 9 + 1 + 9 + 1)
      end
      
    end
    
    context "Bonus Scoring : All 10 pins are hit on the second ball roll. 
						The Spare" do
      it "should return the score that is ten pins + number of 
			    pins hit on the next ball roll" do
        g = Game.new
        
        g.frame_set do
          g.roll(6)
          g.roll(2)
          
          g.roll(7,2)
          g.roll(1,2)
          
          g.roll(10, 3)
          
          g.roll(9,4)
          g.roll(0,4)
          # A spare happens on the fifth frame
          g.roll(8,5)
          g.roll(2,5)
          
          g.roll(1, 6)
          
        end 
        # p g.score_total_upto_frame(5) -- 55
        g.score_total_upto_frame(5).should == 
					(6 + 2) + (7 + 1) + (10 + 9 + 0) + (9 + 0) + (8 + 2 + 1)          
      end        
    end
    
  end  
end
```

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
    
    def strike
      @score += 10
    end
        
    def roll(pins, frame = 1)
      @score += pins   
      update_score_card(pins, frame)  
    end
    
    def score_for_frame(n)
      @score_card[n - 1]
    end
    
    def score_total_upto_frame(n)
      @score_card.take(n).flatten.inject{|x, sum| x += sum}
    end
    
    def frame_set
      yield 
      update_strike_score
      update_spare_score
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
          if (e.size == 2) and (sum(e) == 10)
            spare_index = i
          end
        end
      end
      
      last_element_index = (@score_card.size - 1)
      if spare_index < last_element_index
        @score_card[spare_index] +=  [@score_card[last_element_index][0]]
      end
    end
    # This can be extracted into a summable module and mixed-in to Array class
    def sum(e)
      e.inject(:+)
    end
  end
  
end
```

## Question ##

Private methods are not tested. Why?

## Screencast ##

git co a781d7c3b6542e89ef73707e3bf21d40956704b0 to get the screencast. Watch the demo screencast : BDD_Basics_I.mov

\newpage

