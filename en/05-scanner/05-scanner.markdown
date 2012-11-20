# Scanner #

This example is about a scanner that is used in a checkout counter. When you can scan an item, the name and price of the item is sent to the output console.

## Objectives ##

- How to use Fakes and Mocks ?
- When to delete a test ?

## Writing the First Test ##

Create a scanner_spec.rb file with the following contents:

```ruby
require_relative 'scanner'

describe Scanner do
  it 'should respond to scan with barcode as the input parameter' do
    scanner = Scanner.new
    
    scanner.should respond_to(:scan)
  end
end
```

Create a scanner.rb file with the following contents:

```ruby
class Scanner
  def scan
    
  end
end
```

You can run this spec by typing the following command from the root of the project:

$ rspec scanner_spec.rb

The first spec does not do much. The main purpose of writing the first spec is to help setup the directory structure, require statements etc to get the specs running. 

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

Run the spec again, watch it fail due to the input parameter and change the scanner.rb as follows :

```ruby
class Scanner
  def scan(barcode)
    
  end
end
```

The test now passes.

## Deleting a Test ##

Let's add a second spec that captures the description in the first paragraph of this chapter:

scanner_spec.rb

```ruby
require_relative 'scanner'
require_relative 'real_display'

describe Scanner do
  ...
  it "scan & display the name & price of the scanned item on a cash register display" do
    real_display = RealDisplay.new
    scanner = Scanner.new(real_display)
    scanner.scan("1")
    
    real_display.last_line_item.should == "Milk $3.99"
  end
end
```

real_display.rb

```ruby
class RealDisplay
  
end
```

The test fails with the error:

1) Scanner scan & display the name & price of the scanned item on a cash register display
   Failure/Error: scanner = Scanner.new(real_display)
   ArgumentError:
     wrong number of arguments(1 for 0)

We have two options we can delete the first spec or we can move it to a contract spec. Contract specs are discussed in a later chapter. Moving this to a contract spec will be the right choice if we expect our system to be able to deal with different types of scanners which must comply to the same interface.

Let's make a simplifying assumption that we don't have to deal with different scanners. So, let's delete the first spec. The first test is no longer required. It is like a scaffold of a building, once we complete the construction of the building the scaffold will go away. 

Change the scanner.rb like this:

```ruby
class Scanner
  def initialize(display)
    @display = display
  end
  
  def scan(barcode)

  end
end
```

The spec fails with:

1) Scanner scan & display the name & price of the scanned item on a cash register display
     Failure/Error: real_display.last_line_item.should == "Milk $3.99"
     NoMethodError:
       undefined method `last_line_item' for #<RealDisplay:0x007f87bd0bf0d0>

Change the real_display.rb like this:

real_display.rb

```ruby
class RealDisplay
  attr_reader :last_line_item
  
  def display(line_item)

  end
end
```

The spec fails with:

1) Scanner scan & display the name & price of the scanned item on a cash register display
   Failure/Error: real_display.last_line_item.should == "Milk $3.99"
     expected: "Milk $3.99"
          got: nil (using ==)

Change the real_display.rb like this:

real_display.rb

```ruby
class RealDisplay
  attr_reader :last_line_item
  
  def display(line_item)
    p "Executing complicated logic"
    sleep 5
     
    @last_line_item = "Milk $3.99"
  end
end
```

Change the scan method in scanner like this:

```ruby
class Scanner
  ...
  def scan(barcode)
    @display.display("Milk $3.99")
  end
end
```

Now the spec passes. Real object RealDisplay used in the test is slow. 

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

Create fake_display.rb with the following contents:

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

We broke the dependency on external display object by using a fake object that mimicked the interface of the real object. Dependency injection is used to create scanner object with a fake display. Dependency injection allows us to design loosely coupled objects. We identified the need to decouple the scanner and display objects due to performance problem. This also increases the cohesion of these objects.
	
When we write tests, we have to divide and conquer. This test tells us how scanner objects affect displays. This test helps us to see whether a problem is due to scanner. Is scanner fulfilling its responsibility? This helps us localize errors and save time during troubleshooting.
	
When we write tests for individual units, we end up with small well-understood pieces. This makes it easy to reason about code.
	
## Mocks ##

Writing a lot of fakes can become tedious. It becomes a programmer's responsibility to maintain them. In such cases, mocks can be used. Mock objects are fakes that perform assertions internally. The solution that uses mocks is faster than using Fake display object.

```ruby
require_relative 'scanner'

describe Scanner do
  it "scans the name & price of the scanned item" do
    fake_display = double("Fake display")
    fake_display.should_receive(:display).with("Milk $3.99")
    
    scanner = Scanner.new(fake_display)
    scanner.scan("1")
  end
end
```

The display method is under our control so we can mock it. Mock is a design technique that is used to discover API. This is an example of right way to Mock. The 'and' part of the doc string has been deleted. It is now clear the purpose of Scanner object is to scan items and the Display objects is to display given line items. See the appendix for notes on mocks.