# Eliminating Loops #

## Objective ##

To illustrate how to eliminate loops in specs. The tests must specify and focus on “What” instead of implementation, the “How”.

Here is the code from Meszaros gem https://github.com/bparanj/meszaros.git:

loop_spec.rb

```ruby
require 'spec_helper'
require 'meszaros/loop'

module Meszaros
  describe Loop do
    it "should allow data driven spec : 0" do
      result = []
      Loop.data_driven_spec([]) do |element|
        result << element
      end

      result.should be_empty
    end
    
    it "should allow data driven spec : 1" do
      result = []
      Loop.data_driven_spec([4]) do |element|
        result << element
      end

      result.should == [4]
    end
    
    it "should allow data driven spec : n" do
      result = []
      Loop.data_driven_spec([1,2,3,4]) do |element|
        result << element
      end

      result.should == [1,2,3,4]
    end

    it "should raise exception when nil is passed as the parameter" do
      expect do
        Loop.data_driven_spec(nil) do |element|
          true.should be_true
        end
      end.to raise_error

    end

    it "allow execution of a chunk of code for 0 number of times" do
      result = 0
      
      Loop.repeat(0) do
        result += 1        
      end
      
      result.should == 0
    end
    
    it "allow execution of a chunk of code for 1 number of times" do
      result = 0
      
      Loop.repeat(1) do
        result += 1        
      end
      
      result.should == 1
    end
    
    it "raise exception when nil is passed for the parameter to repeat" do      
      expect do
        Loop.repeat(nil) do
          true.should be_true      
        end
      end.to raise_error
      
    end

    it "raise exception when string is passed for the parameter to repeat" do      
      expect do
        Loop.repeat("dumb") do
          true.should be_true        
        end
      end.to raise_error
    end

    it "raise exception when float is passed for the parameter to repeat" do      
      expect do
        Loop.repeat(2.2) do
          true.should be_true        
        end
      end.to raise_error
    end
    
    it "allow execution of a chunk of code for n number of times" do
      result = 0
      
      Loop.repeat(3) do
        result += 1        
      end
      
      result.should == 3
    end
  end  
end
```

loop.rb

```ruby
module Meszaros
  class Loop
    def self.data_driven_spec(container)
      container.each do |element|
        yield element
      end
    end
    
    def self.repeat(n)
      n.times { yield }
    end
  end
end
```

From the specs, you can see the cases 0, 1 and n. We gradually increase the complexity of the tests and extend the solution to a generic case of n. It also documents the behavior for illegal inputs. The developer can see how the API works by reading the specs. Data driven spec and repeat methods are available in meszaros gem.

1. See meszaros gem for how to eliminate loops in specs.
2. Data driven spec and repeat methods are available in meszaros gem.

From Alex Chaffe's presentation: https://github.com/alexch/test-driven

## Before ##

### Matrix Test ###

```ruby
%w(a e i o u).each do |letter|
  it "#{letter} is a vowel" do
    assert { letter.vowel? }
  end
end
```

This mixes what and how.

## After ##

### Data Driven Spec ###

```ruby
specify "a, e, i, o, u are the vowel set" do
  data_driven_spec(%w(a e i o u)) do |letter|
    letter.should be_vowel
  end
end
```

This is a specification that focuses only on "What".

\newpage
