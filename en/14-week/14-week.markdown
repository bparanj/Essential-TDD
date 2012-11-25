# Week #

## Objectives ##

- Introduction to Contract tests. 
- How to write contract tests? 
- Contract tests explicitly documents the behavior of the API for invalid inputs.
- Reliable test : Test fails when it should. This is good.

## Version 1 ##

Contract test, first version that passes when return value is checked for false.

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
end

describe Week do
  it "return monday as the first day of the week" do
    day = Week.day("1")
    
    day.should == :monday
  end
  it "return false for numbers that does not correspond to week day" do
    day = Week.day("7")
    
    day.should be_false
  end
end
```

## Version 2 ##

Test breaks when the code changes the return value to blank string from nil. Test fails when it should. This is good. If the clients use a conditional to check the true / false, they will be protected by this failing test, since the defect is localized. Violating the contract between the client and library results in failing test. We have to fix it so that the existing clients using our library don’t break.

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
      ""
    end
  end
end

describe Week do
  it "return monday as the first day of the week" do
    day = Week.day("1")
    
    day.should == :monday
  end
  it "return false for numbers that does not correspond to week day" do
    day = Week.day("7")
    
    day.should be_false
  end
end
```

## Version 3 ##

Reverted implementation to working version. Since clients are dependent on the returned false value of nil.

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
end

describe Week do  
  it "should return monday as the first day of the week" do
    day = Week.day("1")
    
    day.should == :monday
  end
  it "should return false for numbers that does not correspond to week day" do
    day = Week.day("7")
    
    day.should be_false
  end
end
```

## Version 4 ##

Added three contract tests that explicitly documents the behavior of the API for invalid inputs. Hash#fetch throws exception that is implicit in the code.

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
  it "return monday as the first day of the week" do
    day = Week.day("1")
    
    day.should == :monday
  end
  # contract test
  it "return false for numbers that does not correspond to week day" do
    day = Week.day("7")
    
    day.should be_false
  end
  # contract test
  it "should throw exception for numbers that does not correspond to week end" do
    expect do
      week_end = Week.end("4")
    end.to raise_error
  end
  # contract test
  it "should throw exception for numbers that is out of range" do
    expect do
      week_end = Week.end("40")
    end.to raise_error    
  end
end
```

"A program must be able to deal with exceptions. A good design rule is to list explicitly the situations that may cause a program to break down" -- Jorgen Knudsen from Object Design : Roles, Responsibilities and Collaborations

\newpage
