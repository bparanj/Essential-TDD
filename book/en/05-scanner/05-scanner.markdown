# Scanner #

## Objectives ##

- How to use Fakes and Mocks ?
- When to delete a test ?
- Learn about Open Closed Principle and how to apply it 

## Problem ##

Let's consider a scanner that is used in a checkout counter. When you can scan an item, the name and price of the item is sent to the output console.

## Steps ##
### Step 1 ##

Let's write the first test. Create a scanner_spec.rb file with the following contents:

```ruby
require_relative 'scanner'

describe Scanner do
  it 'should respond to scan with barcode as the input parameter' do
    scanner = Scanner.new
    
    scanner.should respond_to(:scan)
  end
end
```

### Step 2 ###

Create a scanner.rb file with the following contents:

```ruby
class Scanner
  def scan
    
  end
end
```

### Step 3 ###

You can run this spec by typing the following command from the root of the project:

```ruby
$ rspec scanner_spec.rb
```

The first spec does not do much. The main purpose of writing the first spec is to help setup the directory structure, require statements etc to get the specs running. 

### Step 4 ###

In your home directory create a .rspec directory with the following contents:

```ruby
--color
--format documentation
```

This will show the output in color and formatted to read as documentation. 

### Step 5 ###

The doc string says that the barcode is the input parameter. Let’s add this detail to our spec:

```ruby
require_relative 'scanner'

describe Scanner do
  it 'should respond to scan with barcode as the input argument' do
    scanner = Scanner.new
    
    scanner.should respond_to(:scan).with(1)
  end
end
```

### Step 6 ###

Run the spec again, watch it fail due to the input parameter.

### Step 7 ###

Change the scanner.rb as follows :

```ruby
class Scanner
  def scan(barcode)
    
  end
end
```

The test now passes.

### Step 8  ###

Let's add a second spec that captures the description in the first paragraph of this chapter:

scanner_spec.rb

```ruby
require_relative 'scanner'
require_relative 'real_display'

describe Scanner do
  ...
  it "scan & display the name & price of the scanned item 
       on a cash register display" do
    real_display = RealDisplay.new
    scanner = Scanner.new(real_display)
    scanner.scan("1")
    
    real_display.last_line_item.should == "Milk $3.99"
  end
end
```

### Step 9 ###

Create real_display.rb file with the following contents:

```ruby
class RealDisplay
  
end
```

### Step 10 ###

Run the specs. The test fails with the error:

```ruby
1) Scanner scan & display the name & price of the scanned item on a cash register display
   Failure/Error: scanner = Scanner.new(real_display)
   ArgumentError:
     wrong number of arguments(1 for 0)
```

We have two options, either we can delete the first spec or we can move it to a contract spec. Contract specs are discussed in a later chapter. Moving this to a contract spec will be the right choice if we expect our system to be able to deal with different types of scanners which must comply to the same interface.

### Step 11 ###

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

### Step 12 ###

Run the specs. The spec fails with:

```ruby
1) Scanner scan & display the name & price of the scanned item on a cash register display
     Failure/Error: real_display.last_line_item.should == "Milk $3.99"
     NoMethodError:
       undefined method `last_line_item' for #<RealDisplay:0xd0>
```

### Step 13 ###

Change the real_display.rb like this:

```ruby
class RealDisplay
  attr_reader :last_line_item
  
  def display(line_item)

  end
end
```

### Step 14 ###

Run the specs. The spec fails with:

```ruby
1) Scanner scan & display the name & price of the scanned item on a cash register display
   Failure/Error: real_display.last_line_item.should == "Milk $3.99"
     expected: "Milk $3.99"
          got: nil (using ==)
```

### Step 15 ###

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

### Step 16 ###

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

### Step 17 ###
 	
How can we test if the scanner can scan a given item and display the item name and price on a cash register display? Let’s speed up the test by using a fake display. The scanner_spec.rb now becomes:

```ruby
require_relative 'scanner'
require_relative 'fake_display'

describe Scanner do
  it "scan & display the name & price of the scanned item 
      on a cash register display" do
    fake_display = FakeDisplay.new
    scanner = Scanner.new(fake_display)
    scanner.scan("1")
    
    fake_display.last_line_item.should == "Milk $3.99"
  end
end
```

### Step 18 ###

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

## Open Closed Principle ##
## Steps ##
### Step 1 ###

Move fake_display.rb and scanner_spec.rb into spec directory. Move real_display.rb and scanner.rb into lib directory. Change the scanner_spec.rb require_relative statement like this:

```ruby
require_relative '../lib/scanner'
```

### Step 2 ###

Run the specs. The spec will pass. 

### Step 3 ###

We now have a new requirement where we need to use a touch screen display. Let's write the spec for this new requirement.

```ruby
it 'scans the name & price of an item to display on a touch display' do
  touch_display = TouchDisplay.new
  scanner = Scanner.new(touch_display)
  
  scanner.scan("1")
  
  expect(touch_display.last_line_item).to eq("Milk $3.99")
end
```

### Step 4 ###

Add the :

```ruby
require_relative '../lib/touch_display'
```

to the top of the scanner_spec.rb. 

### Step 5 ###

Create a touch_display.rb in lib directory with the following contents:

```ruby
class TouchDisplay
  attr_reader :last_line_item
  
  def display(line_item)
    p "Allows users to interact by touch"
     
    @last_line_item = "Milk $3.99"
  end
end
```

### Step 6 ###

Run all specs. All specs will pass. 

To satisfy our new requirement we added new code, we did not modify the existing production code. Open Closed Principle states that a module should be open for extension and closed for modification. Our scanner class satisfies this principle. We were able to achieve this by using dependency injection to decouple the display from the scanner. As long as any new concrete implementation of the display implements our interface, display() with an accessor for last_line_item, we can extend our program without violating Open Closed Principle.

## Summary ##

In this chapter you learned how to use Fakes and Mocks, when to delete a test and Open Closed Principle.

\newpage
