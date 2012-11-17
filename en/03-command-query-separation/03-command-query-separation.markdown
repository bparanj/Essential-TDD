# Command Query Separation Principle #

## Objectives ##

- How to fix violation of Command Query Separation principle  ?
- How to fix abuse of mocks ?
- How to write focused tests ? 
- How to deal with external dependencies in your domain code ?

## Before ##

Example of badly designed API that violates command query separation principle:

```ruby
user = User.new(params)

if user.save
  do something
else
  do something else
end
```

The save is inserting the record in the database. It is a command because it has a side effect. It is also returning true or false so it is also a query.

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

It looks like client is tied to the implementation details (it is accessing a data structure) but it is actually any class that can respond to [] method.

### After ###

Version 2 - tweet_analyser_spec.rb

```ruby
class TweetAnalyzer
  def initialize(user)
    @user = user
  end
  
  def word_frequency
    @histogram = {"one" => 1}
  end  
  
  def histogram(text)
    @histogram[text]
  end
end

describe TweetAnalyzer do
  it "finds the frequency of words in a user's tweets" do
    user = double('user')
    analyzer = TweetAnalyzer.new(user)
    analyzer.word_frequency

    analyzer.histogram("one").should == 1
  end
end
```

### Version 3 ###

Second spec breaks the existing spec. This is an example for how mocks are abused.

tweet_analyzer_spec.rb

```ruby
class TweetAnalyzer
  def initialize(user)
    @user = user
  end
  
  def word_frequency
    @frequency = Hash.new{0}
    @user.recent_tweets.each do |tweet|
      tweet.split(/\s/).each do |word|
        @frequency[word] += 1
      end
    end
  end  
  
  def histogram(text)
    @frequency[text]
  end
end

describe TweetAnalyzer do
  it "finds the frequency of words in a user's tweets" do
    user = double('user')
    analyzer = TweetAnalyzer.new(user)
    analyzer.word_frequency

    analyzer.histogram("one").should == 1
  end
  
  it "asks the user for recent tweets" do
    user = double('user')
    analyzer = TweetAnalyzer.new(user)
    expected_tweets = ["one two", "two"]
    user.should_receive(:recent_tweets).and_return expected_tweets
    
    histogram = analyzer.word_frequency
    analyzer.histogram("two").should == 2
  end
end
```

### Version 4 ###

Fixed abuse of mocks.

tweet_analyzer_spec.rb

```ruby
class TweetAnalyzer
  def initialize(user)
    @user = user
  end
  
  def word_frequency
    @frequency = Hash.new{0}
    @user.recent_tweets.each do |tweet|
      tweet.split(/\s/).each do |word|
        @frequency[word] += 1
      end
    end
  end  
  
  def histogram(text)
    @frequency[text]
  end
end

describe TweetAnalyzer do
  it "finds the frequency of words in a user's tweets" do
    user = double('user')
    expected_tweets = ["one two", "two"]
    user.stub(:recent_tweets).and_return expected_tweets
    
    analyzer = TweetAnalyzer.new(user)    
    analyzer.word_frequency

    analyzer.histogram("one").should == 1
  end
  
  it "asks the user for recent tweets" do
    user = double('user')
    expected_tweets = ["one two", "two"]
    user.stub(:recent_tweets).and_return expected_tweets
    
    analyzer = TweetAnalyzer.new(user)
    analyzer.word_frequency
    
    analyzer.histogram("two").should == 2
  end
end
```

### Version 5 ###

Extracted common setup to before(:each) method.

tweet_analyzer_spec.rb

```ruby
class TweetAnalyzer
  def initialize(user)
    @user = user
  end
  
  def word_frequency
    @frequency = Hash.new{0}
    @user.recent_tweets.each do |tweet|
      tweet.split(/\s/).each do |word|
        @frequency[word] += 1
      end
    end
  end  
  
  def histogram(text)
    @frequency[text]
  end
end

describe TweetAnalyzer do
  before(:each) do
    @user = double('user')
    expected_tweets = ["one two", "two"]
    @user.stub(:recent_tweets).and_return expected_tweets
  end
  
  it "finds the frequency of words in a user's tweets" do    
    analyzer = TweetAnalyzer.new(@user)    
    analyzer.word_frequency

    analyzer.histogram("one").should == 1
  end
  
  it "asks the user for recent tweets" do    
    analyzer = TweetAnalyzer.new(@user)
    analyzer.word_frequency
    
    analyzer.histogram("two").should == 2
  end
end
```

### Version 6 ###

Focused tests that test only one thing. If it is important that the user's recent tweets are used to calculate the frequency, write a separate test for that.

tweet_analyzer_spec.rb

```ruby
class TweetAnalyzer
  def initialize(user)
    @user = user
  end
  
  def word_frequency
    @frequency = Hash.new{0}
    @user.recent_tweets.each do |tweet|
      tweet.split(/\s/).each do |word|
        @frequency[word] += 1
      end
    end
  end  
  
  def histogram(text)
    @frequency[text]
  end
end

describe TweetAnalyzer do
  before(:each) do
    @user = double('user')
    expected_tweets = ["one two", "two"]
    @user.stub(:recent_tweets).and_return expected_tweets
  end
  
  it "finds the frequency of words in a user's tweets" do    
    analyzer = TweetAnalyzer.new(@user)    
    analyzer.word_frequency

    analyzer.histogram("one").should == 1
  end
  
  it "find the frequency of words in a user's tweets that appears multiple times" do    
    analyzer = TweetAnalyzer.new(@user)
    analyzer.word_frequency
    
    analyzer.histogram("two").should == 2
  end
  
  it "asks the user for recent tweets" do    
    user = double('user')
    expected_tweets = ["one two", "two"]
    user.should_receive(:recent_tweets).and_return expected_tweets
    
    analyzer = TweetAnalyzer.new(user)
    analyzer.word_frequency
  end
  
end
```

### Version 7 ###

Refactored version.

tweet_analyzer_spec.rb

```ruby
require_relative 'tweet_analyzer'

describe TweetAnalyzer do
  
  context 'The Usual Specs' do
    before(:each) do
      @user = double('user')
      expected_tweets = ["one two", "two"]
      @user.stub(:recent_tweets).and_return expected_tweets
    end

    it "finds the frequency of words in a user's tweets" do    
      analyzer = TweetAnalyzer.new(@user)    
      analyzer.word_frequency

      analyzer.histogram("one").should == 1
    end

    it "find the frequency of words in a user's tweets that appears multiple times" do    
      analyzer = TweetAnalyzer.new(@user)
      analyzer.word_frequency

      analyzer.histogram("two").should == 2
    end    
  end
  
  context 'Calling recent_tweets is important' do
    it "asks the user for recent tweets" do    
      user = double('user')
      expected_tweets = ["one two", "two"]
      user.should_receive(:recent_tweets).and_return expected_tweets

      analyzer = TweetAnalyzer.new(user)
      analyzer.word_frequency
    end    
  end
  
end
```

tweet_analyzer.rb

```ruby
class TweetAnalyzer
  def initialize(user)
    @user = user
  end
  
  def word_frequency
    @frequency = Hash.new{0}
    @user.recent_tweets.each do |tweet|
      tweet.split(/\s/).each do |word|
        @frequency[word] += 1
      end
    end
  end  
  
  def histogram(text)
    @frequency[text]
  end
end
```

See appendix : Notes from Martin Fowler's article and jMock Home Page.