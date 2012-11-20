# Code Mutation #

## Objective ##

To illustrate the need to mutate the code when the test passes without failing the first time.

The ruby_extensions.rb has extensions to builtin Ruby classes that preserves the semantics. It provides:

- Array union and intersection methods. 
- Fixnum inclusive and exclusive methods

ruby_extensions_spec.rb

```ruby
require_relative 'ruby_extensions'

describe Array do
  it "return an array with elements common to both arrays with no duplicates" do
    a = [1,1,3,5]
    b = [1,2,3]
    result = a.intersection(b)

    result.should == [1,3]
  end
  
  it "return a new array built by concatenating two arrays" do
    a = [1,2,3]
    b = [4,5]
    result = a.union(b)
    
    result.should == [1,2,3,4,5]
  end
  
  it "should include the end value for an inclusive range" do
    a = 0.inclusive(2)
    
    a.first.should == 0
    a.last.should == 2
    a.include?(1).should be_true
    a.include?(2).should be_true
  end
  
  it "should exclude the end value for an exclusive range" do
    a = 0...2
    
    a.first.should == 0
    a.last.should == 2
    a.include?(1).should be_true 
    a.include?(2).should be_false
  end
  
  it "should return a comma separated list of items when to_s is called" do
    a = [1,2,3,4]
    result = a.to_s
    
    result.should == "1,2,3,4"
  end
end
```

ruby_extensions.rb

```ruby
class Array  
  # | operator is used for union operation in Array.
  def union(another)  
    self | another  
  end  
  # & operator is used for intersection operation in Array.
  def intersection(another)  
    self & another  
  end  
  # Better implementation that the default one provided by array
  def to_s
    join(",")
  end
end

class Fixnum
  # This eliminates the mental mapping from .. and ... to the behaviour of the methods.
  def inclusive(element)
    self..element
  end

  def exclusive(element)
    self...element
  end
end
```

When the test passes without failing, you must modify the production code to make the test fail to make sure that you the test is testing the right thing. This example illustrates:

- How to open classes that preserves the semantics of the core classes.
- What to do when the test passes without failing the first time.
- Hiding implementation related classes.
- Intention revealing variable names.

\newpage
