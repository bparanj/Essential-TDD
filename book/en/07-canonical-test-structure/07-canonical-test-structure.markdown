# Canonical Test Structure #

## Objective##

- To practice Canonical Test Structure : Given, When, Then 

## Discussion ##

According to the Dictionary, the term canonical is defined as:

Mathematics : relating to a general rule or standard formula.

In our case, the following the three steps is a standard formula for writing any test.

* Step 1 - Given : Precondition (System is in a known state)
* Step 2 - When  : Exercise the System Under Test (SUT)
* Step 3 - Then  : Postcondition (Check the outcome is as expected)

## Steps ##
### Step 1 ##

Create a file stack_spec.rb with the following contents:

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

### Step 2 ###

Create stack.rb with a simple stack implementation that can push and pop as follows:

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

### Step 3 ###

Run the specs. You should see them all pass.

## Discussion ##

Instead of thinking about 'How do I write a test?'. Ask yourself the following questions: 

* What is the given condition?
* How do I exercise the system under test?
* How do I verify the outcome?

The answers to these questions will help you write the test. For example, if you have a class called Car, you need to have gas in order to drive the car. The given condition in this case is that it has gas. The 'drive' is the behavior you are testing so you invoke drive() on the instance of a car in order to exercise the system under test. When you drive you expect to travel. So, you can verify the outcome by checking the distance traveled for a given amount of time and average speed.

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
These are just methods. Do not create a class for given_when_then.rb. The following code identifies the three steps for the stack_spec.rb:

```ruby
require_relative 'stack'
require_relative 'given_when_then'

describe Stack do
  it "should push a given item" do
    Given { @stack = Stack.new }

    When  { @stack.push(1) }

    Then  { @stack.size.should == 1 }
  end
	
  it "should pop from the stack" 
end
```

Run the stack_spec.rb. It should pass. This is an example for State Verification. We check the state of the system after we exercise the SUT for correctness.

## Exercise ##

Identify the Given, When, Then steps for the second spec "Make sure Single Responsibility Principle is obeyed.".

## Q&A ##

1. What if the method does many things that needs to be tested?

Ideally a method should be small and do just one thing. If a method has three steps with different scenarios, then you will write three different specs for each scenario.

2. What if I want to test push and pop in one test?

The structure of the test is Arrange, Act, Assert. There should be only one Arrange, one Act and one Assert per test. In this case you would have multiple of each of these steps. So it does not follow the best practice. Why do we need just one AAA in our test?

Because if you had multiple of each of the steps, you would have the state at the end of the first assertion interact with the state at the end of the second assertion. Ideally we want each test to be isolated. Isolation means that the state is clean in the beginning of each test and it cleans up the state at the end of each test.

\newpage
