# Learning Tests #

J. B. Rainsberger says in this blog post at http://blog.thecodewhisperer.com/2011/12/14/when-to-write-learning-tests/: 

When you try to learn a new library at the same time as you explore the behavior and design of your application, you slow down more than you think.

When you can’t figure out how to make the new library work for this thing you want to build, you might spend hours fighting, debugging, swearing.

Stop. Write a Learning Test.

1. Write a new test.
2. Write a test that checks the things you tried to check earlier with debug statements.
3. Write a test that has nothing to do with your application and its domain.
4. Remove unnecessary details from your test.

When this test passes, then you understand what that part of the library does. If it behaves strangely, then you have the perfect test to send to the maintainers of the library.

## Example 1 : Mongodb Koans ##

The Mongodb koans are focused on learning Mongodb. 

```ruby
$ git clone https://github.com/bparanj/mongodb-koans
```

Read the README file for more instructions.

### Version 1 ###

First version contains the exercises. Go to the directory where you have mongodb-koans checked out and switch to the initial version by:

```ruby
$ git co 578061ea13bfb2afd85ca7bcf2f3f92a908caa69
```

To run the tests:

```ruby
$ ruby path_to_enlightenment.rb
```

### Version 2 ###

Second version is the solution to all the exercises. You can compare your solution by browsing the source at https://github.com/bparanj/mongodb-koans

## Example 2 : Mongodb Learning Specs ##

1. Download learning Mongodb specs:

$ git clone https://github.com/bparanj/mongodb_specs

2. The specs needs Mongodb version v1.6.2. to be running. Follow the installation instructions for Mongodb on its home page. To run Mongo daemon:

```ruby
$mongod --dbpath /Users/bparanj/data/mongodb
```

3. To run the spec:

```ruby
$rspec mongodb_queries_spec.rb 
```

## Example 3 : RSpec Learning Specs ##

Read the specs to describe features of RSpec at https://www.relishapp.com/rspec
Here is an example:  https://www.relishapp.com/rspec/rspec-mocks/v/2-10/docs/method-stubs/as-null-object

## Exercise ##

Write learning specs for a gem that you would like to learn.

\newpage
