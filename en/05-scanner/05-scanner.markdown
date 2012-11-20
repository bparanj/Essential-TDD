# Scanner #

This example is about a scanner that is used in a checkout counter. You can scan item, the name and price of the item is sent to the output console.

## Objectives ##

- How to use Fakes and Mocks ?
- When to delete a test ?

## Writing the First Test ##

scanner_spec.rb

```ruby
require_relative 'scanner'

describe Scanner do
  it 'should respond to scan with barcode as the input parameter' do
    scanner = Scanner.new
    
    scanner.should respond_to(:scan)
  end
end
```

scanner.rb

```ruby
class Scanner
  def scan
    
  end
end
```

The first spec does not do much. The main purpose of writing the first spec is to help setup the directory structure, require statements etc to get the specs running. You can run this spec by typing the following command from the root of the project:

$ rspec scanner/scanner_spec.rb

In your home directory create a .rspec directory with the following contents:

--color
--format documentation

This will show the output in color and formatted to read as documentation. The doc string says that the barcode is the input parameter. Let’s add this detail to our spec:

```ruby
require_relative 'scanner'

describe Scanner do
  it 'should respond to scan with barcode as the input argument' do
    scanner = Scanner.new
    
    scanner.should respond_to(:scan).with(1)
  end
end
```

\newpage


Run the test, watch it fail due to the input parameter and change the scanner.rb as follows :

```ruby
class Scanner
  def scan(barcode)
    
  end
end
```

The test now passes.

## Deleting a Test ##

The first test is no longer required. It is like a scaffold of a building once we complete the construction of the building the scaffold will go away. Here is the new test that captures the description in the first paragraph of this chapter:

scanner_spec.rb

```ruby
require_relative 'scanner'
require_relative 'r2d2_display'

describe Scanner do
  it "scan & display the name & price of the scanned item on a cash register display" do
    real_display = R2d2Display.new
    scanner = Scanner.new(real_display)
    scanner.scan("1")
    
    real_display.last_line_item.should == "Milk $3.99"
  end
end
```

r2d2_display.rb

```ruby
class R2d2Display
  attr_reader :last_line_item
  
  def display(line_item)
    p "Executing complicated logic"
    sleep 5
     
    @last_line_item = "Milk $3.99"
  end
end
```

Real object used in the test is slow. Here is the scanner.rb to make the new test pass:

```ruby
class Scanner
  def initialize(display)
    @display = display
  end
  
  def scan(barcode)
    @display.display("Milk $3.99")
  end
end
```

## Speeding Up The Test ##
 	
How can we test if the scanner can scan a given item and display the item name and price on a cash register display? Let’s speed up the test by using a fake display. The scanner_spec.rb now becomes:

```ruby
require_relative 'scanner'
require_relative 'fake_display'

describe Scanner do
  it "scan & display the name & price of the scanned item on a cash register display" do
    fake_display = FakeDisplay.new
    scanner = Scanner.new(fake_display)
    scanner.scan("1")
    
    fake_display.last_line_item.should == "Milk $3.99"
  end
end
```

fake_display.rb

```ruby
class FakeDisplay
  attr_reader :last_line_item
  
  def display(line_item)     
    @last_line_item = "Milk $3.99"
  end
end
```

The spec now runs fast. This solution assumes that we can access the last line item to display by doing:

```ruby
attr_reader :last_line_item
```

We broke the dependency on external display object by using a fake object that mimicked the interface of the real object. Dependency injection is used to create scanner object with a fake display.
	
When we write tests, we have to divide and conquer. This test tells us how scanner objects affect displays. This test helps us to see whether a problem is due to scanner. Is scanner fulfilling its responsibility?. This helps us localize errors and save time.
	
When we write tests for individual units, we end up with small well-understood pieces. This makes it easy to reason about code.
	
## Using Mocks ##

Writing a lot of fakes can become tedious. In such cases, mocks can be used. Mock objects are fakes that perform assertions internally. The solution that uses mocks is faster than using Fake display object.

```ruby
require_relative 'scanner'

describe Scanner do 
  it "scan & display the name & price of the scanned item on a cash register display" do
    fake_display = mock
    fake_display.should_receive(:display).with("Milk $3.99")
    scanner = Scanner.new(fake_display)
    scanner.scan("1")
  end
end
```

The display method is under our control so we can use Mock. Mock is a design technique that is used to discover API. This is an example of right way to use Mock.

## Notes on Mock Objects ##

A Mock Object is a substitute implementation to emulate or instrument other domain code.  It should be simpler than the real code, not duplicate its implementation, and allow you to set up private state to aid in testing. The emphasis in mock implementations is on absolute simplicity, rather than completeness. For example, a mock collection class might always return the same results from an index method, regardless of the actual parameters. 

A warning sign of a Mock Object becoming too complex is that it starts calling other Mock Objects – which might mean that the unit test is not sufficiently local. When using Mock Objects, only the unit test and the target domain code are real.

## Why use mock objects? ##

- Deferring Infrastructure Choices
- Lightweight emulation of required complex system state
- On demand simulation of conditions
- Interface Discovery
- Loosely coupled design achieved via dependency injection

## A Pattern for Unit Testing ##

Create instances of Mock Objects

- Set state in the Mock Objects
- Set expectations in the Mock Objects
- Invoke domain code with Mock Objects as parameters
- Verify consistency in the Mock Objects

With this style, the test makes clear what the domain code is expecting from its environment, in effect documenting its preconditions, postconditions, and intended use. All these aspects are defined in executable test code, next to the domain code to which they refer. Sometimes arguing about which objects to verify gives us better insight into a test and, hence, the domain. This style makes it easy for new readers to understand the unit tests as it reduces the amount of context they have to remember. It is also useful for demonstrating to new programmers how to write effective unit tests.

Testing with Mock Objects improves domain code by preserving encapsulation, reducing global dependencies, and clarifying the interactions between classes.
	
## Reference ##

Working Effectively with Legacy Code


