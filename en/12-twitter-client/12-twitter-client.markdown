## Twitter Client ##

## Objectives ##

- Dealing with third party API.
- Thin adapter layer to insulate your application from external API.
- What abusing mocks looks like.
- Brittle tests that break even when the behavior does not change, caused by mock abuse.
- Integration tests should test the layer that interacts with external API.
- Using too many mocks indicate badly designed API. So called fluent interface is actually a train wreck. Fluent interface is ok for languages like Java where it is the only option.

## Running the Specs ##

Run
$ autotest
from the root of the project to run the specs.

## Version 1 ##

Initial commit to twits.

## Version 2 ##

Test hits the live server.

twits_spec.rb

```ruby
require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require 'user'

describe "Twitter User" do
  context "with a username" do
    before(:each) do
      @user = User.new
      @user.twitter_username = 'logosity'
    end
    
    it "provides the last five tweets from twitter" do
      tweets = ["race day! http://t.co/nHVyd7s3 #fb",
                "toy to inspire: http://t.co/koMadie2 #fb",
                "just drove the route: http://t.co/nHVyd7s3 #fb",
                "Son is declaring that the Honey Badger is his second favorite animal.",
                "If you want to sail your ship in a different direction."]
      
      @user.last_five_tweets.should == tweets 
    end
    
  end
end
```

user.rb

```ruby
require 'twitter'

class User
  attr_accessor :twitter_username
  
  def last_five_tweets
    return Twitter::Search.new.per_page(5).from(@twitter_username).map do |tweet|
      tweet[:text]
    end.to_a
  end
end
```

## Version 3 ##

Abuse of mocks. Spec is coupled to the implementation of the method. Spec is brittle. It will break even when the behavior does not change but when the implementation changes. That is likely to happen when you upgrade Twitter gem.

twits_spec.rb

```ruby
require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require 'user'

describe "Twitter User" do
  context "with a username" do
    before(:each) do
      @user = User.new
      @user.twitter_username = 'logosity'
    end
    
    it "provides the last five tweets from twitter" do
      tweets = [
        {text: 'tweet1'},
        {text: 'tweet2'},
        {text: 'tweet3'},
        {text: 'tweet4'},
        {text: 'tweet5'},
        ]
      
      mock_client = mock('client')
      mock_client.should_receive(:per_page).with(5).and_return(mock_client)
      mock_client.should_receive(:from).with('logosity').and_return(tweets)
      Twitter::Search.should_receive(:new).and_return(mock_client)
      
      @user.last_five_tweets.should == %w{tweet1 tweet2 tweet3 tweet4 tweet5} 
    end
    
  end
end
```

user.rb

```ruby
require 'twitter'

class User
  attr_accessor :twitter_username
  
  def last_five_tweets
    return Twitter::Search.new.per_page(5).from(@twitter_username).map do |tweet|
      tweet[:text]
    end.to_a
  end
end
```

## Version 4 ##

Fixed the mock abuse. Stub used to disconnect from Twitter client API. Twits must hit the Twitter sandbox in an integration test.

twits_spec.rb

```ruby
require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require 'user'

describe "Twitter User" do
  context "with a username" do
    before(:each) do
      @user = User.new
      @user.twitter_username = 'logosity'
    end
    # The test now depends on our API fetch_tweets in our Twits Twitter client class
    # This is stable than directly depending on a third party API.
    it "provides the last five tweets from twitter" do
      tweets = %w{tweet1 tweet2 tweet3 tweet4 tweet5} 
      Twits.stub(:fetch_tweets).and_return(tweets)
      @user.last_five_tweets.should == %w{tweet1 tweet2 tweet3 tweet4 tweet5} 
    end
    
  end
end
```

twits.rb

```ruby
require 'twitter'

class Twits
  # The following method must hit the Twitter sandbox in the integration test.
  # It is now in Twits (TwitterClient). Ideally nested within a module. 
  # This API is a thin wrapper around the actual Twitter API. 
  # It insulates the changes in Twitter API from impacting the application.
  def self.fetch_tweets(username)
    Twitter::Search.new.per_page(5).from(username).map do |tweet|
      tweet[:text]
    end.to_a
  end
end
```

user.rb

```ruby
require 'twits'

class User
  attr_accessor :twitter_username
  
  def last_five_tweets
     Twits.fetch_tweets(@twitter_username)
  end
end
```

## Version 5 ##

Used dependency injection to inject a fake twitter client to break the dependency. Also refactored to move the method from domain model to the service layer object Twits.

twits_spec.rb

```ruby
require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require 'user'
require 'fake_twitter_client'

describe "Twitter User" do
  context "with a username" do
    before(:each) do
      @user = User.new
      @user.twitter_username = 'logosity'
    end 

    # The following is not a good idea due to the headache of keeping the fake 
    # object in synch with Twitter API changes. Shows dependency injection.
    it "should provide the last five tweets from twitter" do
      twits = Twits.new(FakeTwitterClient.new)
			
			expected_tweets = %w{tweet1 tweet2 tweet3 tweet4 tweet5} 
      twits.fetch_five(@user.twitter_username).should == expected_tweets
    end
  end
end
```

twits.rb

```ruby
class Twits
   
  def initialize(client)
    @client = client
  end
  # The following method must hit the Twitter sandbox in the integration test.
  # It is now in Twits (TwitterClient). Ideally nested within a module. 
  # This API is a thin wrapper around the actual Twitter API. It 
  # insulates the changes in Twitter API from impacting the application.
  def fetch_five(username)
    @client.per_page(5).from(username).map do |tweet|
      tweet[:text]
    end.to_a    
  end
end
```

user.rb

```ruby
require 'twits'

class User
  attr_accessor :twitter_username
  
end
```

fake_twitter_client.rb

```ruby
class FakeTwitterClient
  def per_page(n)
    self
  end
  
  def from(username)
    tweets = [{ :text => 'tweet1'},
              { :text => 'tweet2'},
              { :text => 'tweet3'},
              { :text => 'tweet4'},
              { :text => 'tweet5'}]
  end
end
```

## Version 6 ##

Deleted unnecessary code.

user.rb

```ruby
require 'twits'

class User
  attr_accessor :twitter_username
  
end
```

twits.rb

```ruby
class Twits
   
  def initialize(client)
    @client = client
  end
  # The following method must hit the Twitter sandbox in the integration test.
  # It is now in Twits (TwitterClient). Ideally nested within a module. 
  # This API is a thin wrapper around the actual Twitter API. 
  # It insulates the changes in Twitter API from impacting the application.
  def fetch_five(username)
    @client.per_page(5).from(username).map do |tweet|
      tweet[:text]
    end
  end
end
```

fake_twitter_client.rb

```ruby
class FakeTwitterClient
  def per_page(n)
    self
  end
  
  def from(username)
    tweets = [{ :text => 'tweet1'},
              { :text => 'tweet2'},
              { :text => 'tweet3'},
              { :text => 'tweet4'},
              { :text => 'tweet5'}]
  end
end
```

twits_spec.rb

```ruby
require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require 'user'
require 'fake_twitter_client'

describe "Twitter User" do
  context "with a username" do
    before(:each) do
      @user = User.new
      @user.twitter_username = 'logosity'
    end 

    # The following is not a good idea due to the headache of keeping the fake 
    # object in synch with Twitter API changes. Shows dependency injection
    it "should provide the last five tweets from twitter" do
      twits = Twits.new(FakeTwitterClient.new)
			expected_tweets = %w{tweet1 tweet2 tweet3 tweet4 tweet5} 
      twits.fetch_five(@user.twitter_username).should == expected_tweets
    end
  end
end
```

## Discussion ##

The book Continuous Testing with Ruby, Rails and Javascript by Ben Rady & Rod Coffin uses mocks in the tests to write the tests for Mongodb. Because we have never used this db before, it shows breaking dependencies by testing against a real service and then replacing those interactions with mocks. This results in lot of mocks in the tests. 

Using mocks in this case is improper usage of mocks. Because you cannot drive the design of a third-party API (Mongodb API in this case). There is a better way to breaking the external dependencies. 
	
1. First write learning tests. 
2. Then create a thin adapter layer that has well defined interface. This adapter layer will encapsulate the interaction with Mongodb. Now you can mock the thin adapter layer in your code and write integration tests for the adapter tests that will interact with Mongodb. 

This prevents the changes in Mongodb API from impacting the domain code. See https://github.com/bparanj/mongodb_specs for example of learning specs.





