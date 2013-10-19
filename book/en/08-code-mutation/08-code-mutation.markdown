# Code Mutation #

## Objective ##

To illustrate the need to mutate the code when the test passes without failing the first time.

## Version 1 ##

Create a ruby_extensions_spec.rb with the following contents:

```ruby
require_relative 'ruby_extensions'

describe 'Ruby extensions' do
  it "return an array with elements common to both arrays with no duplicates" do
    a = [1,1,3,5]
    b = [1,2,3]
    result = a.intersection(b)

    result.should == [1,3]
  end    
end
```

To make the test pass, create ruby_extensions.rb with the following contents:

```ruby
class Array  
  # & operator is used for intersection operation in Array.
  def intersection(another)  
    self & another  
  end  
end
```

Add the second spec for the boundary condition like this:

```ruby
require_relative 'ruby_extensions'

describe 'Array extensions' do
  ...  
  it "should return an empty array if there is no common elements to both arrays" do
    a = [1,1,3,5]
    b = [7,9]
    result = a.intersection(b)
  
    result.should == []    
  end
end
```

This test passes without failing. The question is how do you know if this test is correct? We don't have a test to test this test. To validate the test, we have to mutate the production code to make it fail for the scenario under test.

Change the ruby_extensions.rb so that only the second spec fails like this:

```ruby
class Array  
  def intersection(another)  
    return [10] if another.size == 2
    self & another  
  end  
end
```

Now the second spec breaks with the error:

```ruby
1) Array Array extensions should return an empty array 
     if there is no common elements to both arrays
   Failure/Error: result.should == []
     expected: []
          got: [10] (using ==)
```

Delete the short circuiting condition from the ruby_extensions.rb: 

```ruby
return [10] if another.size == 2
```

Now both the specs should pass.

## Final Version ##

The ruby_extensions.rb has extensions to builtin Ruby classes that preserves the semantics. It provides:

- Array union and intersection methods. 
- Fixnum inclusive and exclusive methods

ruby_extensions_spec.rb

```ruby
require_relative 'ruby_extensions'

describe 'Array Extensions' do
  it "return an array with elements common to both arrays with no duplicates" do
    a = [1,1,3,5]
    b = [1,2,3]
    result = a.intersection(b)

    result.should == [1,3]
  end
  it "return an empty array if there is no common elements to both arrays" do
    a = [1,1,3,5]
    b = [7,9]
    result = a.intersection(b)
  
    result.should == []    
  end
  it "return a new array built by concatenating two arrays" do
    a = [1,2,3]
    b = [4,5]
    result = a.union(b)
    
    result.should == [1,2,3,4,5]
  end
  it "return a comma separated list of items when to_s is called" do
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
  # This eliminates the mental mapping from .. and ... to the behavior of the methods.
  def inclusive(element)
    self..element
  end
  def exclusive(element)
    self...element
  end
end
```

When the test passes without failing, you must modify the production code to make the test fail to make sure that the test is testing the right thing. In this example we saw:

- What to do when the test passes without failing the first time.
- How to open classes that preserves the semantics of the core classes.
- Intention revealing variable and method names.

## Exercise ##

1. Think of edge cases for the ruby_extensions.rb. Write specs for them. When the spec passes without failing, mutate the code to make only the boundary condition spec fail. Then make all the specs pass.

\newpage
