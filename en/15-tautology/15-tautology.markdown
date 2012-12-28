# Tautology #

## Objective ##

To illustrate common beginner’s mistake of stubbing yourself out.

```ruby
describe "Don't mock yourself out" do
  it "should illustrate tautology" do
    paul = stub(:paul, :age => 20)
    
    paul.age.should == 20
  end
end
```

This test does not test anything. It will always pass.

\newpage
