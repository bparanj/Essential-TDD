# Learning Tests #

When you try to learn a new library at the same time as you explore the behavior and design of your application, you slow down more than you think.

When you can’t figure out how to make the new library work for this thing you want to build, you might spend hours fighting, debugging, swearing.

Stop. Write a Learning Test.

1. Write a new test.
2. Write a test that checks the things you tried to check earlier with debug statements.
3. Write a test that has nothing to do with your application and its domain.
4. Remove unnecessary details from your test.

When this test passes, then you understand what that part of the library does. If it behaves strangely, then you have the perfect test to send to the maintainers of the library.

Source : J. B. Rainsberger Blog post : http://blog.thecodewhisperer.com/2011/12/14/when-to-write-learning-tests/

## Example 1 : Mongodb Koans ##

The koans are focused on learning Mongodb. Check out the code at https://github.com/bparanj/mongodb-koans
	 
### Version 1 ###

First version contains the exercises. To run the tests :

$ ruby path_to_enlightenment.rb

### Version 2 ###

Second version is the solution to all the exercises.

## Example 2 : Mongodb Learning Specs ##

Learning Mongodb Specs : https://github.com/bparanj/mongodb_specs

1. Run Mongo daemon:
 			$mongod --dbpath /Users/bparanj/data/mongodb
2. To run spec:
			$rspec mongodb_queries_spec.rb 
3. The specs needs Mongodb version v1.6.2. to be running.

## Example 3 : RSpec Learning Specs ##

Specs to describe features of RSpec at https://www.relishapp.com/rspec
Example:  https://www.relishapp.com/rspec/rspec-mocks/v/2-10/docs/method-stubs/as-null-object

\newpage
