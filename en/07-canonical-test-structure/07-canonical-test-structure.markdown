# Canonical Test Structure #

## Objective##

- Canonical test structure practice for Given, When, Then 

Step 1 - Given : Precondition
Step 2 - When  : Exercise the System Under Test
Step 3 - Then  : Postcondition

stack_spec.rb

```ruby
require_relative 'stack'

describe Stack do
  it "should push a given item" do
    stack = Stack.new
    stack.push(1)

    stack.size.should == 1
  end
  it "should pop from the stack" do
    stack = Stack.new
    stack.push(2)
    result = stack.pop
    
    result.should == 2
    stack.size.should == 0
  end
end
```

Simple stack implementation that can push and pop.

stack.rb

```ruby
class Stack
  def initialize
    @elements = []
  end
  def push(item)
    @elements << item
  end
  def pop
    @elements.pop  
  end
  def size
    @elements.size
  end
end
```

## Identifying Given, When, Then ##

Here is an example of how to identify Given, When, Then in a test.

Copy the following given_when_then.rb to canonical directory:

```ruby
def Given
  yield
end

def When
  yield
end

def Then
  yield
end
```

Now the stack_spec.rb looks like this:

```ruby
require_relative 'stack'
require_relative 'given_when_then'

describe Stack do
  it "should push a given item" do
    Given { @stack = Stack.new }

    When  { @stack.push(1) }

    Then  { @stack.size.should == 1 }
  end
  it "should pop from the stack" do
    stack = Stack.new
    stack.push(2)
    result = stack.pop
    result.should == 2
    stack.size.should == 0
  end
end
```

This is an example for State Verification. We check the state of the system after we exercise the SUT.

## Exercise ##

Identify the Given, When, Then steps for the second spec “should pop from the stack”.

\newpage
