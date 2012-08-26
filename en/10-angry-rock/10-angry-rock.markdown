# Angry Rock #

## Objectives ##

- How to fix Command Query Separation violation?
- Refactoring : Retaining the old interface and the new one at the same time to avoid old tests from failing.
- Semantic quirkiness of Well Grounded Rubyist solution exposed by specs.
- Using domain specific terms to make the code expressive

### Version 1 - Violation of Command Query Separation Principle ###

angry_rock_spec.rb

```ruby
require 'spec_helper'

module Game
  describe AngryRock do
   it "should pick paper as the winner over rock" do
     choice_1 = Game::AngryRock.new(:paper)
     choice_2 = Game::AngryRock.new(:rock)
     winner = choice_1.play(choice_2)
     result = winner.move
     
     result.should == "paper"
   end    
   it "picks scissors as the winner over paper" do
     choice_1 = Game::AngryRock.new(:scissors)
     choice_2 = Game::AngryRock.new(:paper)
     winner = choice_1.play(choice_2)
     result = winner.move
     
     result.should == "scissors"   
   end
   it "picks rock as the winner over scissors " do
     choice_1 = Game::AngryRock.new(:rock)
     choice_2 = Game::AngryRock.new(:scissors)
     winner = choice_1.play(choice_2)
     result = winner.move
     
     result.should == "rock"      
   end
   it "results in a tie when the same choice is made by both players" do
     [:rock, :paper, :scissors].each do |choice|
       choice_1 = Game::AngryRock.new(choice)
       choice_2 = Game::AngryRock.new(choice)
       winner = choice_1.play(choice_2)
       
       winner.should be_false
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
    def <=>(other)
      if move == other.move
        0
      elsif WINS.include?([move, other.move])
        1
      elsif WINS.include?([other.move, move])
        -1
      else
        raise ArgumentError, "Something's wrong"
      end
    end
    # Lousy design : Returns boolean instead of AngryRock winner object
    def play(other)
      if self > other
        self
      elsif other > self
        other
      else
        false
      end
    end
  end
end  
```

Notice the play method implementation, the false case breaks the consistency of the returned value and violates the semantics of the API. Also the play is a “Command” not a “Query”. This method violates the “Command Query Separation Principle”.

### Fixing the Bad Design ###

angry_rock_spec.rb

```ruby
require 'spec_helper'

module Game
  describe AngryRock do
   it "should pick paper as the winner over rock" do
     choice_1 = Game::AngryRock.new(:paper)
     choice_2 = Game::AngryRock.new(:rock)
     winner = choice_1.play(choice_2)
     result = winner.move
     
     result.should == "paper"
   end 
   it "picks scissors as the winner over paper" do
     choice_1 = Game::AngryRock.new(:scissors)
     choice_2 = Game::AngryRock.new(:paper)
     winner = choice_1.play(choice_2)
     result = winner.move
     
     result.should == "scissors"   
   end
   it "picks rock as the winner over scissors " do
     choice_1 = Game::AngryRock.new(:rock)
     choice_2 = Game::AngryRock.new(:scissors)
     winner = choice_1.play(choice_2)
     result = winner.move
     
     result.should == "rock"      
   end
   it "results in a tie when the same choice is made by both players" do
     choice_1 = Game::AngryRock.new(:rock)
     choice_2 = Game::AngryRock.new(:rock)
     winner = choice_1.play(choice_2)
     result = winner.move
       
     result.should == "TIE!"     
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
    def <=>(other)
      if move == other.move
        0
      elsif WINS.include?([move, other.move])
        1
      elsif WINS.include?([other.move, move])
        -1
      else
        raise ArgumentError, "Something's wrong"
      end
    end
    # Fixed design : Returns AngryRock Tie object for the Tie case.
    def play(other)
      if self > other
        self
      elsif other > self
        other
      else
        AngryRock.new("TIE!")
      end
    end
  end
end  
```

The play method now returns a AngryRock tie object for the tie case.

### Tie Cases : Spec Duplication ###

angry_rock_spec.rb

```ruby
require 'spec_helper'

module Game
  describe AngryRock do
   it "should pick paper as the winner over rock" do
     choice_1 = Game::AngryRock.new(:paper)
     choice_2 = Game::AngryRock.new(:rock)
     winner = choice_1.play(choice_2)
     result = winner.move
     
     result.should == "paper"
   end 
   it "picks scissors as the winner over paper" do
     choice_1 = Game::AngryRock.new(:scissors)
     choice_2 = Game::AngryRock.new(:paper)
     winner = choice_1.play(choice_2)
     result = winner.move
     
     result.should == "scissors"   
   end
   it "picks rock as the winner over scissors " do
     choice_1 = Game::AngryRock.new(:rock)
     choice_2 = Game::AngryRock.new(:scissors)
     winner = choice_1.play(choice_2)
     result = winner.move
     
     result.should == "rock"      
   end
   it "results in a tie when the same choice is made by both players : rock" do
     choice_1 = Game::AngryRock.new(:rock)
     choice_2 = Game::AngryRock.new(:rock)
     winner = choice_1.play(choice_2)
     result = winner.move
       
     result.should == "TIE!"     
   end

   it "results in a tie when the same choice is made by both players : paper" do
     choice_1 = Game::AngryRock.new(:paper)
     choice_2 = Game::AngryRock.new(:paper)
     winner = choice_1.play(choice_2)
     result = winner.move
       
     result.should == "TIE!"     
   end
   it "results in a tie when the same choice is made by both players : scissors" do
     choice_1 = Game::AngryRock.new(:scissors)
     choice_2 = Game::AngryRock.new(:scissors)
     winner = choice_1.play(choice_2)
     result = winner.move
       
     result.should == "TIE!"     
   end
  end
end
```

The last three specs show three possible tie scenarios. 

### Removing the Duplication in Specs : The Before Picture ###

angry_rock_spec.rb

```ruby
require 'spec_helper'

module Game
  describe AngryRock do
   it "should pick paper as the winner over rock" do
     choice_1 = Game::AngryRock.new(:paper)
     choice_2 = Game::AngryRock.new(:rock)
     winner = choice_1.play(choice_2)
     result = winner.move
     
     result.should == "paper"
   end    
   it "picks scissors as the winner over paper" do
     choice_1 = Game::AngryRock.new(:scissors)
     choice_2 = Game::AngryRock.new(:paper)
     winner = choice_1.play(choice_2)
     result = winner.move
     
     result.should == "scissors"   
   end
   it "picks rock as the winner over scissors " do
     choice_1 = Game::AngryRock.new(:rock)
     choice_2 = Game::AngryRock.new(:scissors)
     winner = choice_1.play(choice_2)
     result = winner.move
     
     result.should == "rock"      
   end
   it "results in a tie when the same choice is made by both players" do
     [:rock, :paper, :scissors].each do |choice|
       choice_1 = Game::AngryRock.new(choice)
       choice_2 = Game::AngryRock.new(choice)
       winner = choice_1.play(choice_2)
       result = winner.move
       
       result.should == "TIE!"      
     end     
   end   
  end
end
```

The duplication in specs is removed by using a loop.

### Removing the Duplication in Specs : The After Picture ###

angry_rock_spec.rb

```ruby
require 'spec_helper'

module Game
  describe AngryRock do
   it "should pick paper as the winner over rock" do
     choice_1 = Game::AngryRock.new(:paper)
     choice_2 = Game::AngryRock.new(:rock)
     winner = choice_1.play(choice_2)
     result = winner.move
     
     result.should == "paper"
   end    
   it "picks scissors as the winner over paper" do
     choice_1 = Game::AngryRock.new(:scissors)
     choice_2 = Game::AngryRock.new(:paper)
     winner = choice_1.play(choice_2)
     result = winner.move
     
     result.should == "scissors"   
   end
   it "picks rock as the winner over scissors " do
     choice_1 = Game::AngryRock.new(:rock)
     choice_2 = Game::AngryRock.new(:scissors)
     winner = choice_1.play(choice_2)
     result = winner.move
     
     result.should == "rock"      
   end   
   it "results in a tie when the same choice is made by both players" do
     data_driven_spec([:rock, :paper, :scissors]) do |choice|
       choice_1 = Game::AngryRock.new(choice)
       choice_2 = Game::AngryRock.new(choice)
       winner = choice_1.play(choice_2)
       result = winner.move
       
       result.should == "TIE!"      
     end     
   end   
  end
end
```

spec_helper.rb

```ruby
require 'game/angry_rock'

def data_driven_spec(container)
  container.each do |element|
   yield element
  end
end
```

Original solution had the following logic :

```ruby
if winner
  result = winner.move 
else
  result = "TIE!" 
end
```

with play returning false for a tie scenario.

### Command Query Separation Principle ###

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
    def <=>(other)
      if move == other.move
        0
      elsif WINS.include?([move, other.move])
        1
      elsif WINS.include?([other.move, move])
        -1
      else
        raise ArgumentError, "Something's wrong"
      end
    end
    def play(other)
      if self > other
        self
      elsif other > self
        other
      else
        AngryRock.new("TIE!")
      end
    end
  end
end  
```

Is the play() method a command and a query? It is ambiguous because play seems to be a name of a command and it is returning the winning AngryRock object (result of a query operation). It combines command and query.

### Refactoring While Staying Green ###

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
    def <=>(other)
      if move == other.move
        0
      elsif WINS.include?([move, other.move])
        1
      elsif WINS.include?([other.move, move])
        -1
      else
        raise ArgumentError, "Something's wrong"
      end
    end
    # Problem : Is this method is a command and a query?
    # It is ambiguous because play seems to be a name of a command and 
    # it is returning the winning AngryRock object
    def play(other)
      if self > other
        self
      elsif other > self
        other
      end
    end
    def winner(other)
      if self > other
        self
      elsif other > self
        other
      end
    end
  end
  
  class Play
    def initialize(first_choice, second_choice)
      @winner = first_choice.winner(second_choice)
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

Retaining the old interface and the new one at the same time to avoid old tests from failing. Start refactoring in green state and end refactoring in green state (version 8).

### Dealing With Violation of Command Query Separation ###

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
    def <=>(other)
      if move == other.move
        0
      elsif WINS.include?([move, other.move])
        1
      elsif WINS.include?([other.move, move])
        -1
      else
        raise ArgumentError, "Something's wrong"
      end
    end
    # Problem : Is this method a command and a query?
    # It is ambiguous because play seems to be a name of a command and 
    # it is returning the winning AngryRock object
    # play method that violated Command Query Separation is now gone.
    # This is a query method 
    def winner(other)
      if self > other
        self
      elsif other > self
        other
      end
    end
  end
  
  class Play
    def initialize(first_choice, second_choice)
      @winner = first_choice.winner(second_choice)
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

The play() method that violated Command Query Separation is now gone. The new winner method is a query method.

### Using Domain Specific Term ###

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
      @winner = first_choice.winner(second_choice)
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

This version (10) the variable other is renamed to opponent. This reveals the intent of the variable.

### Refactoring the Specs ###

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

The specs are now simplified.

### Handling Illegal Inputs ###

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
   it "should raise exception when illegal input is provided" do
     expect do
       play = Play.new(:junk, :hunk)
     end.to raise_error
   end
  end
end
```

This version now has specs for illegal inputs.

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

This implementation has domain specific error message instead of vague error message that is not helpful during troubleshooting.

### Hiding the Implementation ###

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

### Concise Solution ###

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

This concise solution is based on Sinatra Up and Running book example. In this chapter, we saw Rock Paper Scissors Game Engine. It has two solutions:
 
1. Well Grounded Rubyist based solution refactored to a better design.
2. Sinatra Up and Running based concise solution.
