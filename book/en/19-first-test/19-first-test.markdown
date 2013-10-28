# Chapter 1 : Calculator #

## Objective ##

- Learn about assertion

## Discussion ##

In Test First Programming, you write the test before you write the code. This chapter does not use Test First Programming. Test First Programming is introduced in the next chapter. 

Lets write a calculator program that can add two numbers. Create a calculator.rb file with Calculator class that has an add method as shown:

```ruby
class Calculator
  def add(x, y)
    x + y  
  end
end
```
Code and test is in the same file because it is easier to see all the code at once. Add the following code to calculator.rb below the Calculator class to manually test the calculator add feature:

```ruby
calculator = Calculator.new
result = calculator.add(1, 1)

puts result
```

Run this program.

```ruby
$ ruby calculator.rb
```

In this case we print the result. We know 1 + 1 = 2. So, we check if the result is equal to the expected value, which is 2. If it is correct we know it works otherwise we either debug our code using a debugger or add print statements to troubleshoot and fix the problem. This manual verification of the result will become tedious when our programs grow and become big. 

So the question is : How can we automate the manual verification? Let's modify the program :

```ruby
  calculator = Calculator.new
  result = calculator.add(1,2)

  if result == 3
	  puts "Addition passed"
  else
	  puts "Addition failed"
  end
```

In this version we have removed the manual verification step where we check the result is equal to the expected value by the conditional check in the 'if' statement. Let's make the output easier to recognize.

```ruby
calculator = Calculator.new
result = calculator.add(1,2)

if result == 3
	print "\033[32m Addition passed \033[0m"
else
	print "\e[31m Addition failed \e[0m"
end
```

Now the output message will be red when it fails and green when it passes.

Let's now implement the subtraction:

```ruby
class Calculator
  def subtract(x, y)
 	x - y
  end
end

calculator = Calculator.new
result2 = calculator.subtract(2, 1)

if result2 == 1
	print "\033[32m Subtraction passed \033[0m"
else
	print "\e[31m Subtraction failed \e[0m"
end
```

This works. Now we see duplication in our code. Let's create a utility method that we can reuse.

```ruby
def	verify(expected, actual, message)
	if actual == expected
		print "\033[32m #{message} passed \033[0m"
	else
		print "\e[31m #{message} failed \e[0m"
	end
end
```

We can now simplify our test program :

```ruby
calculator = Calculator.new
result = calculator.add(1, 2)
verify(3, result, 'Addition')

result2 = calculator.subtract(2, 1)
verify(1, result2, 'Subtraction')
```

The verify method that we have developed is called assertion. It automates the manual verification of the test result. 

According to the dictionary assertion is a confident and forceful statement of fact or belief. 

Our assert method verify can only be used for integer values. If we need to compare boolean, strings, decimals etc we need to revise our simple assert method to handle those types. Wouldn't it be nice if there was a library that provided this feature? Well, that's where the test frameworks such as Minitest and Rspec come into picture. In MiniTest the verify method is named 'assert' and in rspec it is named 'should'.

## Exercise ##

Add code to test_calculator.rb to implement multiplication and division similar to the addition and subtraction examples.

## Diagnostics ##

Let's improve the diagnostics message when something goes wrong.

```ruby
def	verify(expected, actual, message)
	if actual == expected
		print "\033[32m #{message} passed \033[0m"
	else
	  puts "Expected : #{expected} but got : #{actual} #{message}"
		print "\e[31m #{message} failed \e[0m"
	end
end
```

## Conclusion ##

In this chapter you learned about assertion and why you need them. In the next chapter we will discuss Test First Programming.


\newpage

