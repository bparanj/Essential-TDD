# Strings and Symbols #

## What is a String ##

String consists of sequence of characters. Character can be anything from the alphabets a through z.

```ruby
 b = 'bunny'
 => "bunny" 
 b.class
 => String 
```

In this example you can see the variable b that is a string consisting of sequence of characters 
'bunny'.

## Different Identity ##

String objects with same contents point to different memory locations. This means they have the same value but their identity is different.

```ruby
 c = 'bunny'
 => "bunny" 
 b.object_id
 => 2178635480 
 c.object_id
 => 2178614120  
```

In this example you can see the variables b and c are pointing to different locations is memory.

```ruby
 > b == c
 => true 
 b.equal?(c)
 => false 
```

As you see when == is used to check if the contents of b and c are the same, we get true as the answer. When we check if the identity is the same by using equal?() method we get false as the answer because the identity is different.

```ruby
 b << ' rabbit'
 => "bunny rabbit" 
 b
 => "bunny rabbit" 
 c
 => "bunny" 
```

In this example we concatenate the string 'rabbit' to the contents of variable b, so we now have 'bunny rabbit' as the contents of b, but the variable c is still pointing to its own location in memory which is independent of b. It is important to note that in Ruby, strings are mutable. They can be changed.

## What is a Symbol ##

You can think of symbols as unique labels that we can use in our programs.

```ruby
 x = :bunny
 => :bunny 
 y = :bunny
 => :bunny 
 x.object_id
 => 2853288 
 y.object_id
 => 2853288 
```

As you see from this example, the symbol :bunny is assigned to two different variables x and y. They both point to the same location in memory.

## Same Identity ##

```ruby
 x << :hi
NoMethodError: undefined method `<<' for :bunny:Symbol
	from (irb):41
```

This example shows that symbols are immutable. You cannot modify the contents like we did for strings.

## Summary ##

In this lesson you learned about string and symbol in Ruby. You also learned about the differences between string and symbol.

\newpage
