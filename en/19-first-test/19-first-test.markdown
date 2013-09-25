# Calculator #

## Objective ##

- Learn about assertion

## Discussion ##

Lets write a calculator program that can add two numbers. Here is the calculator class with a add method:

class Calculator
  def add(x, y)
    x + y  
  end
end

Here is the client code for the calculator program:

calculator = Calculator.new
result = calculator.add(1, 1)

puts result

In this case we print the result and check if the result is equal to the expected value, which is 2. If it is correct we know it works otherwise we either debug our code using a debugger or add print statements to troubleshoot and fix the problem. This manual verification of the result will become tedious when our programs grow and become big. So the question is how can we write a test that will automate the manual verification?

Let's modify the program :

test_calculator.rb

  calculator = Calculator.new
  result = calculator.add(1,2)

  if result == 3
	puts "Addition passed"
  else
	puts "Addition failed"
  end

In this version we have removed the manual verification step where we check the result is equal to the expected value by the conditional check in the if statement. Let's make the output easier to recognize.

calculator = Calculator.new
result = calculator.add(1,2)

if result == 3
	print "\033[32m Addition passed \033[0m"
else
	print "\e[31m Addition failed \e[0m"
end

Now the output message will be red when it fails and green when it passes.

Let's now implement the subtraction:

class Calculator
  def subtract(x, y)
 	x - y
  end
end

calculator = Calculator.new
result = calculator.subtract(2, 1)

if result == 1
	print "\033[32m Subtraction passed \033[0m"
else
	print "\e[31m Subtraction failed \e[0m"
end

This works. Now we see duplication in our code. Let's create a utility method that we can reuse.

def	assert(expected, actual, message)
	if actual == expected
		print "\033[32m #{message} passed \033[0m"
	else
		print "\e[31m #{message} failed \e[0m"
	end
end


We can now simplify our test program :

calculator = Calculator.new
result = calculator.add(1, 2)

assert(3, result, 'Addition')

calculator = Calculator.new
result = calculator.subtract(2, 1)

assert(1, result, 'Subtraction')


The assert method that we have developed is called assertion. It automates the manual verification of the test result.

Exercise : Implement multiplication and division similar to the addition and subtraction examples.



Convert the addition and subtraction to use MiniTest framework.
Exercises : Use MiniTest framework to implement multiplication and division.



Let's write a simple calculator program driven by test. What statements can you make about the calculator program that is true? How about :

*  It should add given two numbers.

Let's write a spec for this statement. Create a file called calculator_spec.rb with the following contents:

```ruby
describe Calculator do
  it "should add given two numbers" do
    calculator = Calculator.new
		
    result = calculator.add(1,2)
    
    result.should == 3
  end
end
```

Here we are describing the Calculator class. We are expressing the requirement in the method 'it' that takes a string as its argument.

In the block of the 'it' method, we first create an instance of Calculator class. The second step is invoking the method add() to calculate sum of two numbers. The third step is checking if the result is the same as we expect. In this step, we have converted the statement that is true to an assertion.

According to the dictionary assertion is a confident and forceful statement of fact or belief. If we did not write any test then we would manually check the result for correctness. We automate this manual check by using an assertion. 

Go to the directory where the spec file resides and run the test like this:

```ruby
$ rspec calculator_spec.rb --color --format documentation
     or
$ rspec calculator_spec.rb --color --format nested
```

This test fails. Define Calculator class at the top of the calculator_spec.rb file with the code shown below:

```ruby
class Calculator
end
```

The error message you get now is different. This is because you have not defined the add method. Add the method to the class :

```ruby
class Calculator
	def add(x,y)
	  x+y
	end
end
```

Run the test again. Now the test passes. You can now move the Calculator class to its own file called calculator.rb. Add

```ruby
require_relative 'calculator'
```

to the top of the calculator_spec.rb. Run the test again. It should pass. 

## Conclusion ##

In this first exercise we took little baby steps. We wrote code with the intent to change the error message. Initially your error messages are related to setting up the environment. Once you get past that, you can make the test fail for the right reason. Failing for the right reason means, the test will fail to satisfy the requirements instead of syntax mistakes, missing require statements etc.

## Exercises ##

1. Write specs for the following statements:

*  It should subtract given two numbers.
*  It should multiply given two numbers.
*  It should divide given two numbers.

2. Refactor the duplication you see by using let() or before() method.

Refer the [rspec documentation](https://www.relishapp.com/rspec/rspec-core/docs) for examples on how to use the rspec API. You can search for 'let' and look at the examples on how to use it. It is a good idea to run the examples to learn the API. Then you can incorporate the changes to your specs.

3. Write specs for edge cases such as invalid input, division by 0 etc.

4. Create a .rspec file with the following contents:

```ruby
--color
--format documentation
```

Now you can run the specs without giving it any options like this:

```ruby
rspec calculator_spec.rb 
```

What do you see as the output in the terminal?

5. Read the Code Simplicity book by Max Kanat-Alexander. It explains Incremental Development and Incremental Design with the calculator as an example in Chapter 5 : Change. It is less than 100 pages, very easy to read and filled with great insights on software development.

\newpage
