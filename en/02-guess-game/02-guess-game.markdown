# Guess Game #

## Objectives ##

- How to test random behavior.
- Illustrate inverting dependencies.
- How to make your code depend on abstractions instead of concrete implementation.
- Illustrate Single Responsibility Principle. No And, Or, or But.
- Illustrate programming to an interface not to an implementation.
- When to use partial stub on a real object is illustrated by spec 7 and 8
- Random test failures due to partial stub fixed by isolating the random number generation
- Small methods focused on doing one thing
- How to defer decisions by using Mocks
- Using mock that complies with Gerard Meszaros standard
- How to use as_null_object
- How to write contract specs to keep mocks in sync with code

## Guessing Game Description ##

Write a program that generates a random number between 0 and 100 (inclusive). The user must guess this number. Each correct guess (if it was a number) will receive the response "Guess Higher!" or "Guess Lower!". Once the user has successfully guessed the number, you will print various statistics about their performance as detailed below:

* The prompt should display : "Welcome to the Guessing Game"
* When the program is run it should generate a random number between 0 and 100 inclusive
* You will display a command line prompt for the user to enter the number representing their guess. Quitting is not an option. The user can only end the game by guessing the target number. Be sure that your prompt explains to them what they are to do.
* Once you have received a value from the user, you should perform validation. If the user has given you an invalid value (anything other than a number between 1 and 100), display an appropriate error message. If the user has given you a valid value, display a message either telling them that there were correct or should guess higher or lower as described above. This process should continue until they guess the correct number.
* Once the user has guessed the target number correctly, you should display a "report" to them on their performance. This report should provide the following information:
	- The target number
	- The number of guesses it took the user to guess the target number
	- A list of all the valid values guessed by the user in the order in which they were guessed.
	- A calculated value called "Cumulative error". Cumulative error is defined as the sum of the absolute value of the difference between the target number and the values guessed. For example : if the target number was 30 and the user guessed 50, 25, 35, and 30, the cumulative error would be calculated as follows:
	
	|50-30| + |25-30| + |35-30| + |30-30| = 35
	
	Hint: See http://www.w3schools.com/jsref/jsref_abs.asp for assistance
	- A calculated value called "Average Error" which is calculated as follows: cumulative error / number of valid guesses. Using the above number set, the average error is 8.75.
	- A text feedback response based on the following rules:
	- If average error is 10.0 or lower, the message "Incredible guessing!"
	- If average error is higher than above but under 20.0, "Good job!"
	- If average error is higher than 20 but under 30.0, "Fair!"
	- Anything other score: "You are horrible at this game!"
	
##	Version 1 ##

The random generator spec will never pass.

guess_game_spec.rb

```ruby
require_relative 'guess_game'

describe GuessGame do
  it "should generate random number between 1 and 100 inclusive" do
    game = GuessGame.new
    result = game.random

    result.should == 50
  end
end

guess_game.rb

class GuessGame

  def random
    Random.new.rand(1..100)
  end
end
```

##	Version 2 ##

guess_game_spec.rb

```ruby
require_relative 'guess_game'

describe GuessGame do
  it "should generate random number between 1 and 100 inclusive" do
    game = GuessGame.new
    result = game.random

    expected = 1..100
    expected.should cover(result)
  end
end

guess_game.rb

class GuessGame

  def random
    Random.new.rand(1..100)
  end
end
```

Note: Using expected.include?(result) is also ok (does not use rspec matcher)
