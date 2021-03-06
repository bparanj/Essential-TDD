# Command Query Separation Principle #

## Objectives ##

- How to fix violation of Command Query Separation principle  ?
- How to fix abuse of mocks ?
- How to write focused tests ? 
- How to deal with external dependencies in your domain code ?

## Before ##

Here is an example of a badly designed API that violates command query separation principle:

```ruby
user = User.new(params)

if user.save
  do something
else
  do something else
end
```

The save is inserting the record in the database. It is a command because it has a side effect. It is also returning true or false, so it is also a query.

## After ##

```ruby
user = User.new(params)
user.save

if user.persisted?
  do something
else
  do something else
end
```

## Calculator Example ##

### Before ###

Calculator example that violates command query separation principle.

calculator_spec.rb

```ruby
require_relative 'calculator'

describe Calculator, "Computes addition of given two numbers" do
  
  it "should add given two numbers that are not trivial" do
    calculator = Calculator.new
    result = calculator.add(1,2)
    
    result.should == 3
  end
end
```

calculator.rb

```ruby
class Calculator
  def add(x,y)
    x+y
  end
end
```

### After ###

Fixed the command query separation violation.

calculator_spec.rb

```ruby
require_relative 'calculator'

describe Calculator, "Computes addition of given two numbers" do
  it "should add given two numbers that are not trivial" do
    calculator = Calculator.new
    calculator.add(1,2) 
    result = calculator.result
    
    result.should == 3
  end
end
```

The add(x,y) method is a command. The calculator.result call is a query.

calculator.rb

```ruby
class Calculator
  attr_reader :result
  
  def add(x,y)
    @result = x + y
    nil
  end  
end
```

We have two choices : we can either return nil or the client can ignore the return value. If the API is for the public then returning nil explicitly will force the client to obey the CQS principle. If it is within a small team we can get away with ignoring the return value and making sure we obey the CQS principle.

## Tweet Analyser Example ##

Another Command Query Separation Principle violation example.

### Before ###

Version 1 - tweet_analyser_spec.rb

```ruby
class TweetAnalyzer
  def initialize(user)
    @user = user
  end
  def word_frequency
    {"one" => 1}
  end  
end

describe TweetAnalyzer do
  it "finds the frequency of words in a user's tweets" do
    user = double('user')
    analyzer = TweetAnalyzer.new(user)
    histogram = analyzer.word_frequency
    histogram["one"].should == 1
  end
end
```

It looks like client is tied to the implementation details (it is accessing a data structure) but it is actually any class that can respond to [] method. The command 'word_frequency' is not only calculating the frequency but also returns a result.

### After ###

Version 2 - tweet_analyser_spec.rb

```ruby
class TweetAnalyzer
  attr_reader :histogram
  
  def initialize(user)
    @user = user
  end  
  def word_frequency
    @histogram = {"one" => 1}
  end  
end

describe TweetAnalyzer do
  it "finds the frequency of words in a user's tweets" do
    user = double('user')
    analyzer = TweetAnalyzer.new(user)
    analyzer.word_frequency
    
    analyzer.histogram["one"].should == 1
  end
end
```

In this version, the command word_frequency() does not return a result. Is executes the logic to calculate word frequency. The histogram is now an exposed attribute that returns word frequency. So the command and query has been separated.

### Version 3 ###

Let's add a second spec that will force us to replace the fake implementation with a real one.

```ruby
it "should return 2 as the frequency for the word two" do
  expected_tweets = ["one two", "two"]
  user = double('user')
  user.should_receive(:recent_tweets).and_return expected_tweets
  analyzer = TweetAnalyzer.new(user)

  analyzer.word_frequency  

  analyzer.histogram["two"].should == 2
end
```

This fails with the error:

```ruby
  1) TweetAnalyzer asks the user for recent tweets
     Failure/Error: analyzer.histogram["two"].should == 2
       expected: 2
            got: nil (using ==)
     # ./tweet_analyzer_spec.rb:28:in `block (2 levels) in <top (required)>'

Finished in 0.00128 seconds
2 examples, 1 failure
```

Let's now implement the word_frequency for real. Change the word_frequency implementation like this:

```ruby
class TweetAnalyzer
  ...  
  def word_frequency
    @histogram = Hash.new{0}
    @user.recent_tweets.each do |tweet|
      tweet.split(/\s/).each do |word|
        @histogram[word] += 1
      end
    end
  end  
end
```

Run the spec:

```ruby
$ rspec tweet_analyzer_spec.rb --color --format documentation
```

We get the failure message:

```ruby
TweetAnalyzer
  finds the frequency of words in a user's tweets (FAILED - 1)
  should return 2 as the frequency for the word two

Failures:
  1) TweetAnalyzer finds the frequency of words in a user's tweets
     Failure/Error: @user.recent_tweets.each do |tweet|
       Double "user" received unexpected message :recent_tweets with (no args)
     # ./tweet_analyzer_spec.rb:10:in `word_frequency'
     # ./tweet_analyzer_spec.rb:22:in `block (2 levels) in <top (required)>'

Finished in 0.00132 seconds
2 examples, 1 failure

Failed examples:

rspec ./tweet_analyzer_spec.rb:19 # TweetAnalyzer finds the frequency of words in a user's tweets
```

We see that the second spec passed but now our first spec is broken. Let's fix this broken spec.

### Version 4 ###

Change the first spec like this:

tweet_analyzer_spec.rb

```ruby
describe TweetAnalyzer do
  it "finds the frequency of words in a user's tweets" do
    expected_tweets = ["one two", "two"]
    user = double('user')
    user.stub(:recent_tweets).and_return expected_tweets
    analyzer = TweetAnalyzer.new(user)
    analyzer.word_frequency
   
    analyzer.histogram["one"].should == 1
   end
   ...
end
```

Now both the specs pass. Note that we were able to make our tests pass without using a real user object. Our focus is only on testing the word frequency calculation not the user. User is a collaborator that the TweetAnalyzer interacts with to fulfill it's responsibility of frequency calculation. 

We still have mocking going on in the second spec. Why should we care that recent_tweets method gets called on the user? We don't care about this in the second spec because our focus is not asserting on the outgoing message to the user collaborator object. This is an example of how mocks are abused. In this case mock is used instead of stub. Let's fix this in the second spec like this:

```ruby
it "should return 2 as the frequency for the word two" do
  expected_tweets = ["one two", "two"]
  user = double('user')
  user.stub(:recent_tweets).and_return expected_tweets
  analyzer = TweetAnalyzer.new(user)

  analyzer.word_frequency  

  analyzer.histogram["two"].should == 2
end
```

This solution does not use mocking. It uses a user stub to enable the tests to run. This fixes abuse of mocks. 

### Version 5 ###

Extract common setup to before method.

tweet_analyzer_spec.rb

```ruby
class TweetAnalyzer
  attr_reader :histogram
  
  def initialize(user)
    @user = user
  end  
  def word_frequency
    @histogram = Hash.new{0}
    @user.recent_tweets.each do |tweet|
      tweet.split(/\s/).each do |word|
        @histogram[word] += 1
      end
    end
  end
end

describe TweetAnalyzer do
  before do
    expected_tweets = ["one two", "two"]
    @user = double('user')
    @user.stub(:recent_tweets).and_return expected_tweets    
  end  
  it "finds the frequency of words in a user's tweets" do
    analyzer = TweetAnalyzer.new(@user)

    analyzer.word_frequency
    
    analyzer.histogram["one"].should == 1
  end
  it "should return 2 as the frequency for the word two" do
    analyzer = TweetAnalyzer.new(@user)

    analyzer.word_frequency  

    analyzer.histogram["two"].should == 2
  end
    
end
```

Green before and after refactoring.

### Version 6 ###

Focused spec test only one thing. If it is important that the user's recent tweets are used to calculate the frequency, write a separate test for that.

tweet_analyzer_spec.rb

```ruby
describe TweetAnalyzer do
  ...  
  it "asks the user for recent tweets" do    
    expected_tweets = ["one two", "two"]
    user = double('user')
    user.should_receive(:recent_tweets).and_return expected_tweets
    
    analyzer = TweetAnalyzer.new(user)
    analyzer.word_frequency
  end  
end
```

In this case we are only interested in asserting on the message sent to the collaborating user object. We are not asserting on the state like the first two specs.

### Version 7 ###

Refactored version.

tweet_analyzer_spec.rb

```ruby
require_relative 'tweet_analyzer'

describe TweetAnalyzer do
  context 'Calculate word frequency' do
    before do
      expected_tweets = ["one two", "two"]
      @user = double('user')
      @user.stub(:recent_tweets).and_return expected_tweets    
    end

    it "finds the frequency of words in a user's tweets" do
      analyzer = TweetAnalyzer.new(@user)

      analyzer.word_frequency

      analyzer.histogram["one"].should == 1
    end

    it "should return 2 as the frequency for the word two" do
      analyzer = TweetAnalyzer.new(@user)

      analyzer.word_frequency  

      analyzer.histogram["two"].should == 2
    end    
  end
  
  context 'Collaboration with User' do
    it "asks the user for recent tweets" do    
      expected_tweets = ["one two", "two"]
      user = double('user')
      user.should_receive(:recent_tweets).and_return expected_tweets

      analyzer = TweetAnalyzer.new(user)
      analyzer.word_frequency
    end    
  end
end
```

tweet_analyzer.rb remains unchanged:

```ruby
class TweetAnalyzer
  attr_reader :histogram
  
  def initialize(user)
    @user = user
  end  
  def word_frequency
    @histogram = Hash.new{0}
    @user.recent_tweets.each do |tweet|
      tweet.split(/\s/).each do |word|
        @histogram[word] += 1
      end
    end
  end
end
```

Again we are green before and after refactoring. So when do we stub and when do we mock? We can use the Command Query Separation Principle in conjunction with a simple guideline : Stub queries and mock commands. Ideal design will not stub and mock at the same time, since it will violate Command Query Separation Principle. See appendix for notes from Martin Fowler's article and jMock Home Page.

\newpage
