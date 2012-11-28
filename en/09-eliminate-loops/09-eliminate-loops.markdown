# Eliminating Loops #

## Objective ##

To illustrate how to eliminate loops in specs. The tests must specify and focus on “What” instead of implementation, the “How”.

## Example ##

Read the following code for meszaros gem (https://github.com/bparanj/meszaros.git) to see how to eliminate loops in specs:

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

Let's take a look at an example to see how the code would look when it mixes the "What" with "How". From Alex Chaffe's presentation: https://github.com/alexch/test-driven

## Before ##

### Matrix Test ###

```ruby
class String
  def vowel?
    %w(a e i o u).include?(self)
  end
end

describe 'Vowel checker' do  
  %w(a e i o u).each do |letter|
    it "#{letter} is a vowel" do
      letter.should be_vowel
    end
  end
end
```

This mixes what and how. It is not clear. Since the implementation details buries the intent of the spec. It passes with the message:

```ruby
$ rspec ruby_extensions_spec.rb --color --format doc

Vowel Checker
  a is a vowel
  e is a vowel
  i is a vowel
  o is a vowel
  u is a vowel

Finished in 0.0048 seconds
5 examples, 0 failures
```

## After ##

### Data Driven Spec ###

```ruby
class String
  def vowel?
    %w(a e i o u).include?(self)
  end
end

def data_driven_spec(container)
  container.each do |element|
    yield element
  end
end

describe 'Vowel Checker' do  
  specify "a, e, i, o, u are the vowel set" do
    data_driven_spec(%w(a e i o u)) do |letter|
      letter.should be_vowel
    end
  end
end
```

```ruby
$rspec ruby_extensions_spec.rb --color --format doc

Vowel Checker
  a, e, i, o, u are the vowel set

Finished in 0.00358 seconds
1 example, 0 failures
```

This is a specification that focuses only on "What". It separates the "What" from the "How". The "How" is hidden behind a library call data_driven_spec. The doc string is easily understood without running the program inside your head.

Since the spec passed without failing, let's mutate the code like this:

```ruby
class String
  def vowel?
    !(%w(a e i o u).include?(self))
  end
end
```

It now fails with the error message:

```ruby
1) Vowel Checker a, e, i, o, u are the vowel set
    Failure/Error: letter.should be_vowel
      expected vowel? to return true, got false
```

Now revert back the change. The spec should pass.

\newpage
