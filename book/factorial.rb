1. Create a file called factorial_spec.rb
2. Numbers cannot be negative. 
   If the contract is broken you raise an exception.
3. Common mistake : Forgetting terminating condition for recursive solution
 
describe ClassName do
  it 'should do something for given number'
  
end

3. rspec factorial_spec.rb

it '' do
  f = Factorial.new

  expect(f.number).should raise_error
  
    
  
end

raise ArgumentError, 'Negative number is not allowed' if number < 0





