# Chapter 2 : Test First Programming #

## Objective ##

- Learn Test First Programming

## Discussion ##

Let's write a simple calculator program driven by test. What statements can you make about the calculator program that is true? How about :

*  It should add given two numbers.

## Steps ##

### Step 1 ###

Let's write a specification for this statement. Create a file called calculator_spec.rb with the following contents:

```ruby
require_relative 'calculator'

describe Calculator do
  it "should add given two numbers" do
    calculator = Calculator.new
		
    result = calculator.add(1,2)
    
    result.should == 3
  end
end
```

In line 1, the require_relative makes the calculator.rb available to the calculator_spec.rb file. This allows us to describe Calculator class in line #3. The 'describe' is a RSpec method, in this case we are describing the Calculator class. We are expressing the requirement in the method 'it()' that takes a string as its argument. The do-end block has the test. 

In the block of the 'it' method, we first create an instance of Calculator class. The second step is invoking the method add() to calculate sum of two numbers. The third step is checking if the result is the same as we expect. In this step, we have converted the statement that is true to an assertion.

### Step 2 ###

Go to the directory where the spec file resides and run the test like this:

```ruby
$ gem install rspec
$ rspec calculator_spec.rb --color --format documentation
     or
$ rspec calculator_spec.rb --color --format nested
```

This test fails. 

### Step 3 ###

Define Calculator class at the top of the calculator_spec.rb file with the code shown below:

```ruby
class Calculator
end
```

The error message you get now is different. This is because you have not defined the add method. 

### Step 4 ###

Add the method to the class :

```ruby
class Calculator
	def add(x,y)
	  x+y
	end
end
```

### Step 5 ###

Run the test again. Now the test passes. 

### Step 6 ###

You can now move the Calculator class to its own file called calculator.rb. Add

```ruby
require_relative 'calculator'
```

to the top of the calculator_spec.rb. 

### Step 7 ###

Run the test again. It should now pass. You can also use expect() method instead of 'should' method like this :

```ruby
expect(result).to eq(3)
```

## Summary ##

In this chapter we took little baby steps. We first learned about assertion. We wrote the test first. Initially your error messages are related to setting up the environment. Once you get past that, you can make the test fail for the right reason. Failing for the right reason means, the test will fail to satisfy the requirements instead of syntax mistakes, missing require statements etc.

## Exercises ##

1. Write specs for the following statements:

*  It should subtract given two numbers.
*  It should multiply given two numbers.
*  It should divide given two numbers.

2. Write specs for edge cases such as invalid input, division by 0 etc.

3. Create a .rspec file with the following contents:

```ruby
--color
--format documentation
```

Now you can run the specs without giving it any options like this:

```ruby
rspec calculator_spec.rb 
```

What do you see as the output in the terminal?

4. Read the Code Simplicity book by Max Kanat-Alexander. It explains Incremental Development and Incremental Design with the calculator as an example in Chapter 5 : Change. It is less than 100 pages, very easy to read and filled with great insights on software development.

5. Refactor the duplication you see by using let() or before() method.

Refer the [rspec documentation](https://www.relishapp.com/rspec/rspec-core/docs) for examples on how to use the rspec API. You can search for 'let' and look at the examples on how to use it. It is a good idea to run the examples to learn the API. Then you can incorporate the changes to your specs.

\newpage
