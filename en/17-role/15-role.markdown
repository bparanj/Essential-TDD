# Role #

## Objective ##

- Being minimal when implementing the production code.

## Discussion ##

We should be able to assign a role to a given user. Create a user_spec.rb file with the following contents:

```ruby
describe User do
  
end
```

We get the error:

```ruby
uninitialized constant User 
```

Add the User class definition to the top of the user_spec.rb as follows:

```ruby
class User
  
end
```

Run the test again. We are green but there are no examples. Add the first spec:

```ruby
  it 'should be in any role assigned to it'
```

Run the spec again. You see a pending spec in the output:

```ruby
Pending:
  User should be in any role assigned to it
```

Change the spec to the following:

```ruby
it 'should be in any role assigned to it' do
  user = User.new
  user.assign_role("some role")
  user.should be_in_role('some role')
end
```

We get the error:

```ruby
undefined method `assign_role' for User
```

Define the assign_role method in User class like this:

```ruby
def assign_role
  
end
```

We get the error:

```ruby
wrong number of arguments (1 for 0)
```

Add the argument like this:

```ruby
def assign_role(role)
  
end
```

We get the error:

```ruby
undefined method `in_role?' for User
```

Add in_role? method to user.rb as follows:

```ruby
def in_role?
  
end
```

We get the error:

```ruby
wrong number of arguments (1 for 0)
```

Add an argument to in_role? method:

```ruby
def in_role?(role)
  
end
```

We get the error:

```ruby
expected in_role?("some role") to return true, got nil
```

We are now failing for the right reason. Notice that each small step we took was guided by the failure messages given by running the test. We only did just enough to get past the current error message. We were lazy in writing the production code. Change the in_role? implementation like this:

```ruby
def in_role?(role)
  true
end
```

The example will now pass. We know that this implementation is bogus. We want the specs to force us to write the logic that can handle assigning roles.

```ruby
it 'should not be in any role that is not assigned to it' do
  user = User.new
  user.should_not be_in_role('admin')
end
```

We get the error:

```ruby
expected in_role?("admin") to return false, got true
```

Change the user.rb as follows:

```ruby
class User
  def assign_role(role)
    @role = role
  end
  
  def in_role?(role)
    @role == 'role'
  end
end
```

The specs will pass. Why do we need to be minimal when writing the production code? Because, the goal of TDD is to end up with a minimal system. Simplicity is the goal. Why do we aim for a minimal system? Because it will be easy to maintain.

## Exercises ##

1. Move user.rb to its own class. Make sure all the specs pass.
2. Implement the feature where a user can be in many roles. Write the test first.
3. Watch BDD_Basics_II.mov

\newpage
