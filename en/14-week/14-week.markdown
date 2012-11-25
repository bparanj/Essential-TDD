# Week #

## Objectives ##

- Introduction to Contract tests. 
- How to write Contract tests? 
- Using Contract tests to explicitly document the behavior of an API for invalid inputs.
- Learn about reliable test. A test that fails when it should.

## Version 1 ##

Here is a contract test that passes when the data that falls out of the expected range is handled in the production code.

week_spec.rb

```ruby
class Week
  DAYS = { "1" =>  :monday, 
           "2" =>  :tuesday, 
           "3" =>  :wednesday, 
           "4" =>  :thursday, 
           "5" =>  :friday,
           "6" =>  :saturday,
           "7" =>  :sunday}
  def self.day(n)
    if n.to_i < 8
      DAYS[n] 
    else
      nil
    end
  end
end

describe Week do
  it "returns monday as the first day of the week" do
    day = Week.day("1")
    
    day.should == :monday
  end
  it "returns false for numbers that does not correspond to a week day" do
    day = Week.day("8")

    day.should be_false
  end
end
```

Run the specs:

```ruby
$rspec week_spec.rb --color

Week
  returns monday as the first day of the week
  returns false for numbers that does not correspond to a week day

Finished in 0.06081 seconds
2 examples, 0 failures
```

If you change the implementation of the day method like this:

```ruby
def self.day(n)
  DAYS[n] 
end
```

The specs will still pass, because in ruby, accessing a hash that does not have the given key will return nil, which evaluates to false. Here the implementation is explicit in order to illustrate a problem.

## Version 2 ##

Change the day method implementation in week_spec.rb like this:

```ruby
  def self.day(n)
    if n.to_i < 8
      DAYS[n] 
    else
      ""
    end
  end
```

Run the specs again:

```ruby
$rspec week_spec.rb --color

Week
  returns monday as the first day of the week
  returns false for numbers that does not correspond to a week day (FAILED - 1)

Failures:

  1) Week returns false for numbers that does not correspond to a week day
     Failure/Error: day.should be_false
       expected: false value
            got: ""
     # ./week_spec.rb:27:in `block (2 levels) in <top (required)>'

Finished in 0.00488 seconds
2 examples, 1 failure

Failed examples:

rspec ./week_spec.rb:24 # Week returns false for numbers that does not correspond to a week day
```

Test breaks when the production code changes the return value from nil to blank string. Test fails when it should. This is good. If the clients use a conditional statement to check the true/false value, they will be protected by this failing test, since the defect is localized. Violating the contract between the client and library results in a failing test. We have to fix this problem so that the existing clients using our library don’t break.


## Version 3 ##

Let's revert back the implementation to working version. Since clients are dependent on the returned false value of nil.

week_spec.rb

```ruby
class Week
  DAYS = { "1" =>  :monday, 
           "2" =>  :tuesday, 
           "3" =>  :wednesday, 
           "4" =>  :thursday, 
           "5" =>  :friday,
           "6" =>  :saturday,
           "7" =>  :sunday}
  def self.day(n)
    if n.to_i < 8
      DAYS[n] 
    else
      nil
    end
  end
end

describe Week do
  it "returns monday as the first day of the week" do
    day = Week.day("1")
    
    day.should == :monday
  end
  it "returns false for numbers that does not correspond to a week day" do
    day = Week.day("8")

    day.should be_false
  end
end
```

If you are versioning your API, then you could make changes that can break your clients. In this case, you would deprecate your old API and give sufficient time for the client to migrate to your newer version.

## Version 4 ##

Added two new contract specs that explicitly documents the behavior of the API for invalid inputs. Hash#fetch throws exception for cases that was implicit in the code.

week_spec.rb

```ruby
class Week
  DAYS = { "1" =>  :monday, 
           "2" =>  :tuesday, 
           "3" =>  :wednesday, 
           "4" =>  :thursday, 
           "5" =>  :friday,
           "6" =>  :saturday,
           "7" =>  :sunday}
  def self.day(n)
    if n.to_i < 6
      DAYS[n] 
    else
      nil
    end
  end
  def self.end(n)
    if n.to_i < 5
      raise "The given number is not a weekend"
    else
      fetch(n)
    end
  end
end

describe Week do
  ...
  # existing contract test
  it "return false for numbers that does not correspond to week day" do
    day = Week.day("7")
    
    day.should be_false
  end
  # new contract test
  it "should throw exception for numbers that does not correspond to week end" do
    expect do
      week_end = Week.end("4")
    end.to raise_error
  end
  # new contract test
  it "should throw exception for numbers that is out of range" do
    expect do
      week_end = Week.end("40")
    end.to raise_error    
  end
end
```

Run all specs.

```ruby
$ rspec week_spec.rb --color

Week
  returns monday as the first day of the week
  returns false for numbers that does not correspond to a week day
  should throw exception for numbers that does not correspond to week end
  should throw exception for numbers that is out of range

Finished in 0.00743 seconds
4 examples, 0 failures
```

Apply Bertrand Meyer's guideline when deciding about exceptions : When a contract is broken by either client or supplier, throw an exception. In our case, the contract is that as long as the client provides the proper input, the supplier will return the corresponding symbol for the week. 

"A program must be able to deal with exceptions. A good design rule is to list explicitly the situations that may cause a program to break down" -- Jorgen Knudsen from Object Design : Roles, Responsibilities and Collaborations

Explicitly document the behavior of your API by writing contract specs. This will help other developers to understand and use your library as intended.

\newpage
