require_relative 'calculator'

def	assert(expected, actual, message)
	if actual == expected
		print "\033[32m #{message} passed \033[0m \n"
	else
		print "\e[31m #{message} failed \e[0m"
	end
end

calculator = Calculator.new
result = calculator.add(1, 2)
assert(3, result, 'Addition')


result = calculator.subtract(2, 1)
assert(1, result, 'Subtraction')
