# Objects #

Ruby is an object-oriented programming language. Everything in Ruby is an object. What is an object? The concept of object is similar to an object in a real world. It could represent something that is physical like car, chair, credit card or something that is conceptual like sale, time, sound etc.

In programming languages object is an instance of a class. 

# Variables #

What is a variable?
Why do you need a variable?
Give variables a descriptive name.
Variables are references that can be assigned
Legal variable names.

x = 1
y = x

The value y will also be 1, since it points to the same object.

Scope determines the visibility of variables. 

Local variable
Global variable $
Instance variable @
Class variable @@


# Integers #

Integers can be positive, zero or negative numbers without decimal places. They can be used to count numbers. We can add, subtract, multiply, increment and exponential. We can assign integers to variables.

1.class

20000000000000.class gives Fixnum, Bignum

Show the diagram that illustrates the class diagram.


Ruby uses more memory to store the bigger numbers by reserving a bigger amount of space but uses less memory to store smaller numbers.

Ruby will switch back and forth as needed without you having to do anything. 

Multiply two Fixnums, you can see how it switchs to Bignum. Integers can be negative. -200.abs is the absolute value.
 200.next (returns next integer)

# Float #

Floating point number or floats. These are decimal numbers that has precision. 

10.99
10.99.class


 
15/3

Integer divided by integer is a integer result.

15.0/3 or 15/3.0

Not the precision is important and the result has precision.

10.99.round

Convert this number to an integer

10.99.to_i will turn floating point into an integer

It removes the precision, it does not do rounding.

floor = round down

ceil = round up

 
 








# Strings #

Strings are sequences of characters. By definition string is a set of things tied or threaded together on a thin cord. In this case it is the sequence of characters that forms a string.


They can be a letter, a word, a sentence, a paragraph, or even
several paragraphs.


It's between double quotes to let Ruby know that this is where the string starts and ends.
We can also use single quotes the same way.
'Hello', and that works just as well.
We could have greeting = "Hello" and target = "world", single quotes or double quotes.
It works exact same way.

Notice that Ruby does a conversion for us here and returns its results always in double quotes.
It's because it's the same thing; this is just the way the Ruby represents that
value when it's output to us. It doesn't matter.
It's stored as a string in both cases.

We can also take strings and add them together, for example, greeting + " " + target.
"Hello world."
And we can simply add the strings together as if they were numbers.
Now this is a common theme in Ruby where the syntax for something like addition
is used.

For example, we can also multiply strings, "Gabba" *5 is going to be
"GabbaGabbaGabbaGabbaGabba".

Now notice that there is a difference if we do 1 * 5, which is 5, and if we do
the string '1'* 5, which is going to return "11111" to us.

So it's not going to convert strings into integers for us.
We're going to need to tell it explicitly if we want to swap.
Otherwise, it's gladly going to just multiply out that string for us.
Now if we have a single quoted string like 'I'm escaped.' How is Ruby supposed
to know where the string starts and ends?
It's going to see the first single quote and then when it sees the second one,
it's going to think that's the end of the string.
So what we are going to need to do, we call escaping it, and that's putting a
backslash in front of it, to let Ruby know this is a literal apostrophe
inside of these quotes.
It's not the end of the string, and notice it takes that away when
it does its conversion to this double quoted version.
The same thing is true for double quotes though.
Let's say we had double quotes.
"I said," we don't need to escape that anymore, "I'm escaped."
We are going to need to put those backslashes in front of these two to let it
know that those are literally meant to be quote marks inside of our string.
Now it's going to keep those in there, when it returns that value to us.
But it's a way of letting you know these are actual quotes inside there.
Of course, if we also needed to have an actual backslash in there, we would
put in two backslashes.

Let's say we just put at the beginning here the number 3 slash slash and you'll
see that it kept that in there, but this is a literal single slash.
If we actually output that value, let's do it up here
with a puts, you'll see that we get a single slash back,
and we get our single double quotes here, when it actually outputs it. Okay.

Now there is another very important difference between single quotes and double quotes,
and that's the double quotes strings do some extra evaluation that
allows us to use escape characters inside them.
So for example, if I've puts " ", and inside I can put the escape character that is for a tab.
So that's a tab and then I'll do an a and then another tab followed by b, and
then I'll do a line return, which is nc, and then another line return nd.
Notice what that puts, and there we go.

You see the tabs are in there and the line returns are in there.
If we were to trade that for instead having single quotes, notice now what we
get back is as if that was just literal text.
So that the double quoted version is going to do that extra evaluation.
Even better than that though is that double quoted strings allow you to drop
in variables to be evaluated. puts, and then inside double quoted strings,
 we'll put the pound symbol or the hash symbol followed by open
curly braces, greeting, which is the variable we defined earlier, we'll close our curly braces.
I'll put a space, and we'll do the same thing again for target, and now it will
drop in those values.
Let me put a period at the end.
I want to say Hello world.


It evaluated that inside those double quotes.
So now if we were to make those instead single quotes, you'll see that it took it literally.
It did not do that extra evaluation.
Now we can put any Ruby expression inside those braces.
So, for example, puts, 1 plus 1 is equal to, and then inside here, let's ask it
to tell us what is 1 plus 1? Here we go.
1 plus 1 equals 2.
So it does the Ruby evaluation inside those braces and then puts the value inside
the string and that only works with double quoted strings.
Let's take a look at some of the methods we can use with strings. We saw
one earlier, we had 
hello.reverse, 
and we also have 
capitalize, 
we also have
downcase, 
 of course we have 
 upcase, and 
 length, and you'll see it returns 5 to us.
 
That's how long the string is, how many characters are in it.

if we take Hello, and let's
say we take the reverse method, there we are, Hello reverse, and then after that
we ask it to upcase, you'll see that it does both.
So we can daisy chain these methods together.
So reverse.upcase.length, for example.
Of course, the length obviously is still 5.
It hasn't changed, but the point is that every time we start with our object,
we apply the reverse method to the object, and then we return an object.
Hello, backwards, and then that returned object gets the upcase method applied
to it, and then the returned object from that gets the length method applied to it.
So each time we're returning an object and applying a new method, and that's why
it's so great that everything in Ruby is an object is because we can do this
kind of thing to it.

And of course, daisy chaining these methods together applies to all objects in
Ruby, not just strings.



# Arrays #


An array is an ordered integer- indexed collection of objects.
we can take objects and put them together
in order, and keep their position in the same order, and we can refer to those
objects by their positions.
That's what that integer-indexed part is.

We can say give me the first object, give me the fifth object, and so on,
because they are going to be indexed according to what position they hold.

In our case, it would be nil when we are working with Ruby.
Now the things that can go in an array are any kind of object, any object at all.
That's strings. That's numbers.
That's more arrays.
That can be larger or more complex objects and classes
It can be mixed types as well.
We don't have to just have an array of strings or numbers. We can mix them together.

 we have an accounting program that has an array of all
the customers that have come to our shop, and we can add to or select from each
of those customers in that array.
Then each one of those customers could also have an array of items that they
purchased from the store or payments that they've made, and we can add to and
select from those as well.
And it will keep all of that data organized, and we'll be able then to move
to the data one item at a time, either searching for records or sorting
records.

to just create a new array, and I am going to assign a variable data_set equal to,
and for our array, we use the square bracket notation.
Open square brackets and close square brackets, that's an array.
In fact, this is an empty array that I've specified, and that's perfectly
legitimate. 

It's an array with nothing in it.

Let's just drop in here, and let's put in a couple of strings, a, b, c, and now
it holds those together, and it keeps them in order, so they will always stay in that order.
And we can pull certain items out of the array to work with them by asking the
array to return a certain item.
So data_set, and then inside parenthesis immediately after the data_set with no equals.
We are going to specify the position that we want.
So I am going to say position 1, and notice that returns back b to me.

All arrays are indexed starting with zero, so a is not in position 1. a is in position 0.
So in order to get that back, we'd asked for data_set 0.
That gives us a, or if we would've asked for 2, we'll get back c. Go ahead and
notice that if we asked for 3, it tells us nil.
That's because even though there's nothing in that fourth pocket, the third index,
so it just returns nil to us. It just says there is nothing in it.
It's a nice feature of Ruby, that it doesn't give us an error because we've
requested something that's not in our array.
We don't have to check and see how long it is.
It just says there's nothing there.

Now we can set values the same way.
Let's go ahead and let's just set our position 0 equal to, we'll make it d.
So it returns d to me.
That's the return value of the operation.
If we want to see what's actually in the data_set, we have to once again ask for
data_set, and it will return the entire thing.
We see now that a has been replaced with d, so we said, okay, in position 0, put d,
which of course is going to displace the a, so it gets thrown away, and the d
goes in there instead.
There is also another nice operator, which is the Append operator, and the symbol
for it is two less than signs together.
If we do the less than less than and then another string, what that does is
it appends it on to the end and you can see it returned as its return value, the full array.
So now we have d, b, c, and then e.
If we wanted to take a value out of the array, let's go back and just make
value 1 be nil, and then if we ask for a data_set again, you'll see now it
holds that first place with nil, all right, which is nothing, and that's how it
knows that there's something in pocket 0 and something in pocket 2, but
nothing in pocket 1.
Now that doesn't clear out the whole array.
If we wanted to actually clear the array, we have a couple of options.
One is we can do data_set clear, and that returns an empty array.
Let's do data_set. You'll see that it is empty.
The other we'd have done the same thing is if we'd done data_set equals, and
just set it back to an empty array, just like we did to initially start.
Now notice though if we said data_set equals nil, that's a different thing.
Now it's no longer an array.

Let's do this data_set, and then data_ set.class, you'll see it's an array.
If I said data_set equal to nil, and then ask for its class.
It comes back and says the class is nil.
So it's actually a different thing, an empty array, and having nothing are
two different things.
Now that we know the basics of how to create an array, how to put items into and
out of an array


 last movie we saw the fundamentals of creating an array, putting objects
into it, and taking objects out.


I am just going to call it array = 1,2, 3,4,5, and I am going to create another one
I will call array2.
I know it's not a very descriptive name, but for our purposes this will work.
I just want to show you that this is 1, and let's put in 2, and then 3.0, and
then while we are at it let's go ahead and put in a, b, and last of all, let's put in dog.
There we go.
I want to show you, first of all, with that array2 that we can mix these types
in there, and the array doesn't care.
We saw how we can return different values.
It works exactly the same way with the mix types.
Now, we have two arrays that we can work with.
The first thing I want to show you is that we can do inspect, array.inspect.
You can see that it just returns back to me the array, which is a nice way to
sort of see it and see what's going on.
Now, we can just say simply array and that returns the value of the array, but
that's not a string.
The one above it is actually a string.
You see those double quotes.
So when we are inside a program and we are programming. We want to be able to
put that version of it.
Let's try puts array, and you will see what it gives us.
If we do puts array, that's what it gives us.
If we do puts array.inspect, it gives us this.
 you can use that to sort of peek at what's inside your array.
That's especially useful if you have got something like this complex
array that's in array2.
If we were to just simply do puts array2 by itself, you will see that it gives
us this, which doesn't really show us the structure. a and b are just listed out
on separate lines, when in fact they are an array within the array.
There is also another version that we can use which is let's do array2 to string.
So 2_s is turned into a string.
That just smashes everything together.
So it doesn't give us this nicely formatted string that inspect gives us.
Instead it joins them together.
In fact, it's the exact same thing as if we do join.
The difference is that with a join, we can also specify what we want to join it with.
So I will use a comma space and now it will join them together and put
commas between them.
Incidentally, we can do the same thing in reverse.
Let's say we have x = and it's a string, 1, 2, 3, 4 and 5, and we could say y =
x.split, and split it on the commas.
So now it takes the string.
Every time it finds a comma, it says, "ah, that's a new element" and it turns it
into an array for us.
So it returns an array, and now y is equal to that array.
We can also do reverse on our arrays, and you will see it just simply reverses
the order like you would expect.
It's not just for strings.
Let's go back to our original array here, 1,2,3,4,5, and let's put at the end,
array, we will do the append that we learned before, and at the end we will append a 0.
So then we got 0 at the end.
Now we can say array.sort, and it will sort our array in order.
Now, we can't sort mix types, not using just a simple sort.


But when I have that very complex array that has some floats, and some integers,
and some strings in there.
It's not sure how you want to sort that.
There is no simple numerical order or alphabetical order that it can follow.
So we would have to write something more complex and we can learn to do that.
There is also unique. Let's say array.
Let's again put at the end of it.
This time we will put a 3.
So you see that it has now got this 3 at the end, so it has two 3s.
I can say array.uniq for unique, no 'ue' at the end, and it will return to me an
array that has no duplicates in it.
Now, it didn't actually change the array itself.
It's not the same as when we appended it on, it actually changed the array.
This just says return me another version, a new array that has no unique values in it,
while leaving the other one alone.
In fact, if we would do unique with an exclamation point at the end, it would
actually change it in place.
So there we go, array.
Now it's permanently changed.
It has been deduped.
Now, we saw how we could set values to nil earlier.
We also have array.delete_at, and let's say delete at position 2, and remember
that's going to be the third item.
So it returns what it deleted.
It deleted number 3, so 3 was returned.
If we take a look at the array, you will see it didn't set it to nil. Instead
it pulled it out of the array and shifted everything over.
So it actually removed it from the order completely.
The other version left nil there as a placeholder in that position 3.
Now, that's all great if we know the position, but what if we don't know what
position something is at, and we want to delete something?
We can also just use delete by itself.
Let's say we will delete number 4 and now it returns 4 to us.
But if we ask for the array, it went through and it found the number 4,
not position four, the number 4.
Now, the fact that both of these deletes return the value that's being deleted
is nice, because we can sort of catch it as it's coming out of there.
We can say pull it out of there, and while it's coming out, let me store it in
another variable that I might want to use.
We saw how we could have array with the append.
We could append something at the end. Let's say 3.
We can also do the same thing using array.push.
So we will push something onto the end.
Let's push a 4 onto the end. There we go.
We can do array.pop and it will take the last element off of the array and
return it just like the delete_at did.
But it basically takes whatever is in that last position and pulls them out of there.
We have the same thing with shift and unshift that we will work with at the beginning.
So let's do shift first, which will return the 1, and then there it is.
Let's do unshift now.
We will put back on the 1.
You can see the 1 goes back on there.
There is a lot more to learn with array methods and you can take a look at that
Ruby documentation to see what else is there.
The one other thing that I want to show you is that we can also add arrays together.
So array + and let's make a new array here which is going to have 9, 10, 11, and 12 in it.
You will see what it gives us back is that it takes the first array and just
adds those other elements on there.
Just an additive property to make one new array.
It didn't change the original array. I would have to store that if I wanted to
capture it and say new_array = array + and I will just do that for now.
We also have the same thing with array -. So there we are now.
It has subtracted out those.
We could also do, for example, array - 2 and that has the same effect as if we
had done a delete searching for 2.
I think that's enough array techniques to get us started.


# Hashes #

understanding of arrays, because hashes are going to be very similar.
Hashes are an unordered, object- indexed collection of objects.
So notice, first of all, that where an array is an ordered collection, a hash is
an unordered collection.
That's a very important difference.
We cannot count on the order that things are going to be stored in a hash.
And instead of being indexed by their position and keeping track of the number,
instead we are going to keep track of them using an object.
We call this a key-value pair.
We have one object that's the key and it references a second object that's a value.
If you think back to the expanding file folder metaphor that I gave you when we
were talking about arrays, well, hashes work a little bit more like hanging file folders.
They are not in any certain order.
They can be rearranged.
Each of those file folders is going to have a label on it, and that's how we are
going to find information.

Its contents will be the value.
So that's a key-value pair.
So both an array and a hash have a very good purpose.
When we want to preserve the order and the order matters to us, we want to use an array.
When it's not so much the order that matters, but we want the convenience of
having that label, and we want to be able to refer to things by label instead of
trying to remember what was in pocket number seven, I can't remember.
Well, we can put a label on it by using a hash.
So that's the two differences.
One is going to be labeled, which will be the hash, and the array will
preserve the order.


I am going to make an array.
It's going to be Kevin, Skoglund, and male, blue for my eyes, and blonde for my hair.
So there we go, now we have an array that describes a person.
Well, that's a little bit cumbersome if we want to remember, oh, blue, was that
the color of clothes he is wearing today, or is that the color of his eyes?
Is blonde the color of his hair or the color he wishes his hair was?
It's a little vague as to what things are.
So labels become important.
So instead we want to use a hash, and a hash, instead of having those square
brackets is going to use curly braces, and that's how we will know that it's a hash.
That's how we can recognize it right away is that it uses those curly braces.
We are going to have key-value pairs, and we are going to structure our
key-value pairs like this.
We will have first_name.
And that's an object.
It's a string, and it's going to refer to Kevin. 
We have a key and a value, and we have this equals greater than sign that points
from one to the other.
So that lets us know that this is the label first_name that applies to Kevin.
Now we can keep going with the rest, last_ name, and we will point that at Skoglund.
There we go. Now, you could keep going and do the rest of them for a time. 
I am just going to leave it at that, because it will allow me to show you that
we can use the same notation that we used when we were working with arrays, but
instead of providing the index that we want, we are going to provide that key.
So it will be the string, first_name.
That's the thing that points at the first_ name that's inside our gash.
If we wanted the last_name, the same thing.
It's a string that we are asking for.
So it's object-indexed.
Instead of being integer- indexed, it's object-indexed.
We are asking for that object back.

we can also use the index method, and we can ask for the reverse.
We put this inside parentheses, but we use the index method and tell it return
Kevin and it will return the key to us.
We said find the value Kevin and return its key.
So it's the reverse of what we are trying to do.

Return the index of the value Kevin.
I also told you earlier that we could have a mixed objects in arrays.
The same thing is true for the keys and the values that are inside a hash.
We could have the number 1 that points to a, b, c and then a comma and our next
one, which will be 'hello', which is a string that's going to point to 'world'.
Then let's make our next one actually be an array. 
That's going to point to a string.
We will just make it 'top', 
So now we have a mixed hash.
Notice that it switched the order around.
The order is not important.
We can't count on it being in any particular order.
What it returned to me may always be the same thing.
That's just because of the way it happened to be stored in memory at
this particular moment.
We can't count on it not moving around.
We have to refer to things by label.
So we could ask for mixed, and then 1, and it will return not the first element,
but the thing with the label that is 1.
Same thing we saw how we could do 'hello' earlier by doing a string.
So instead, I will just show you that we could also put 10, 20 and that will be
the array that we asked for.
And it says, "oh, let me see if I can find that as a label," and so it says "ah,
here is the array [10, 20] and so I will return the value, which is top."

Let's say we have mixed.keys, will return all the keys, and mixed.values, will
return all of the values.
It will turn it into an array when it does that.
We could also have mixed.length.
I don't know if I showed you earlier, but you can use length on an array for the same purpose.
Size is also synonymous with that.
We can also use a mixed.to an array.
That's to_a, and it turns all those key-value pairs into array pairings.
So each key-value pair is its own array.
Last, we also have mixed.clear, and that will just turn it to a simple empty
hash, or we could just do mixed equals, and just empty curly braces and that
will also then just set it back to an empty hash.
So the last thing that I just want to show you is just if we want to set a
value inside one of these hashes, besides just creating it, we do it just the
same way that we do with an array.
We use the square bracket notation and then we put the label that we want.
Even if it's not something that's in there already, it doesn't matter.
Equals and then whatever it is, so male.
You will see now it returns male to us, but if we ask for person again,
it actually has added that key-value pair to it.



# Symbols #


What asymbol is, is a label that's going to be used to identify a piece of data.
Now a string can also be a label too.
We just saw that when we were working with hashes, right?
So, why do we need symbols?
Well the reason is because a symbol is going to be stored in memory one time.
Whereas a string is going to get stored each time. 


And the way that we type a symbol is that we simply use the colon and than the name.
And the name works the same way the variable names would.
So we can have for example test.
That is a symbol, or this_test.
So, that's a symbol that we have just declared.
It's an simple object.
Now to show you how the symbol test is different from the string test.
Let's say this_test and then let's ask for it's object ID.

But we can ask for the object ID of something, and you see it gives me back a number.

But notice that when I do test. object_id, it has a different object ID.
Well, let's do the test. object_id again for a string.
I have a different one.
Third time, three different ones.
And it's because it created a new string called test, right?
It didn't reuse this old one.
It's a whole new object.
This is one object, and this is the second object.
Now, let's go up and let's do the symbol again.
Notice that this time it's the same one, because the symbol is stored one time
in memory, and then it goes back and reuses that same symbol, because it's just a label.
Now for that reason symbols are going to work really well inside hashes.
So, let's say hash = first_name Kevin and last_name Skoglund.
Now that's a great way to label our people, because then if we have another
person, who will use that same label, first name, again.
We don't have to create a new bit of memory to store it in.
So we conserve the amount of memory our computer has to use to run our program.
Where if we use a string for the first time, like we did back in the hash movie,
every time we created a new person, it would create a new Ruby object and
store that in memory.
So when we really want something to be a label, which is definitely what we want
with hash, we are going to want to use that symbol most times.
Unless we really need to use the string, go ahead and use a symbol.


Watch if I now ask for hash and ask it to give me back it's first name.
It goes back and says no, sorry, don't find that label.
That's because it doesn't have anything that has a string object called
first name as a key.
What it has is something with a symbol.
So it can tell the difference between them.

Let's say that I have four or five people and I have four or five first names.
Each one of those has a different object as the label.
And it's a different object every time.
How does hash then still return the same thing to me?
This is because when hashes have a string as the key, it does say well, it's good enough.
It doesn't have to be the exact same object.
It has to have the same value.
It has to be of the same class and have the same value.
Not necessarily be the exact same object.
The other thing that I don't want you to be confused about is that symbols are not variables.
So if we have something like test = 1, it comes back and says nope, sorry, I don't
know how to do that. That's a label.
So up here hash is the variable.
It's a hash that has the label first name.
So you may feel like this is a variable, but it's actually hash that's the variable.
First name is just the label that's in the hash.
So the rule of thumb is if what we are talking about really is a word and if
the sequence of a character is important, or if it is going to be for output,
then we are going to want to use a string.
But if it's a label that's being used to identify a piece of data, or as we will
see later on, to pass a message around between different parts of our program,
we will want to use a symbol.


# Boolean #



It's either going to be true or it's false, and we are going to use this
for doing comparisons.
So in a program we might say for example, if X=1, then output X, or if X is not
equal to 1, then output something different.
That's the kind of thing we are going to be wanting to work towards in our
control flow, 

For now, we just want to focus on the conditional part of that, which is a Boolean.
In order to do that, we are going to need to know some comparison and
logic operators in Ruby.
The first of these is the equal to operator.
That's probably the most common one you will use, and what we would use is for
example X and then = = 1.
And that would say well, if X is equal to 1, it's a test whether or not it's true.
That's very different from X=1, which does an assignment and it sets the value
of X=1. We are not doing an assignment here. We are comparing it.
So you want to be careful when you are writing these that you use the double equals sign.
That throws off some beginners.
It can especially be a problem, because doing an assignment like that will
almost always return true.
Therefore, your test case will return true, even though what you meant to do was
to compare and find out whether or not it was true.
Then we have less than greater than, less than or equal to, greater than or
equal to, I think those are all pretty self explanatory.
Then we have got the Not Operator.
Now the Not Operator is a logical operator and it says that something is not the case.
We can put it in front of just about anything, including just variable names.
So !X, means that X doesn't have a value.
X is either unset or it's been set to false or nil or something like that.
That would also return false.
Then we can see we put it in front of the Not Equal.
That's another very common one.
If X is not equal to 1, then we use the !=.
And then we have these other logic operators And and Or, the double ampersand or
the two upright pipes, one after another.
Find that on your keyboard.
It's an upright line followed by another upright line. We call those pipes.
In this case it's going to be the Or operator.
So that way we construct one set of comparison and then say and something else
is also true, or case number 2, or case number 3 is true.

that simple example. Let's say X=1.
So now we can say X==1 true, and it returned true to us.
Now true is actually an object in Ruby. Remember I said everything is an object.
This is our Boolean. true.class is the TrueClass and false.class is going to
return the FalseClass.
So those are actually objects as well.
So if we say X!=1, of course that returns false, because X is equal to 1.
Of course, we can say is X<3? Yes, it is.
Is X>3? No, it's not.
Let's try putting just the exclamation point in front of X. We will see that it
returned False because there is an X. With an exclamation point in front of Y,
it says, nope, Y wasn't set. Y=false.
Now, !Y=true. It's the reverse.


Logically sometimes you get in little tangles, and you have to kind of stop and
think your way through it.
So it would have returned False if we just had Y. We are telling it to
find the reverse of that, which is True.
Let's try out some of our And and Or operators.
So if 1<=4 and 5 <=100, True, because both conditions were true on both sides.
Now, notice I don't have parentheses around this. If things start getting really complicated,
you need to group things together,
you can put parentheses around your Booleans.
Let's say if this is true, and let's do another one here where we will say 100
is equal to or greater than 200, which of course is not true.
So now, it tries to go through all three of them.
The first one, it says that's true, and the second one, that's true, and
the third one, oops! That's not true.
So the requirement was for all three to be true.
This one to be true, and this one to be true, and this one to be true.
And since they are not, the whole thing returns False.
So notice the way it works its way down the chain.
We can do the same thing with Or.
Let's put an Or operator in here for each of these. Here we go.
Now, it comes back and it says True, because 1 <= 4, that was true, Or,
well, it doesn't matter what the rest is.
It doesn't even have to keep going, because the first one is already true.
So one of these things has to be true.
Let's just try and change that real quick.
Let's make this into, let's say 16 < 4. Still true, because it says well, is 16 < 4? No, it's not.
Or, maybe 5 <= 100.
Well, that is true.
And it stops right there, because it has found one of these that's true.
Let's go ahead and make that not true, just so we can see what happens.
Now it returns False, because none of those things are true.
If this Or this Or this, and none of them were true, so it returns False.
Now, there can be a lot of different methods that we can use that will
return Booleans to us.
For example, x.nil?
No, it's not nil. y.nil?
No, it's not either. Let's try z.nil?
Undefined local variable.
But if we had said, z=nil, and now do z.nil, we get back True.
We could also use something like Between.
Let's say the number 2, between, and let's put in two values. Is it between 1 and 4?
Actually I need a question mark.
A lot of these Booleans are going to have question marks in them, because it's
answering a question and that helps you to know.
There is no problem in using question marks in the names of methods inside Ruby.
You won't want to use them in your variable names, but they are in the method
names a lot of times.
So is it between them? Yes.
Is it between 3 and 4? No.
A couple of more quick ones that we can do.
If we have an array, let's say array 1,2,3 .empty? Is it empty?
No, it's not empty.
If we just had something by itself, then of course it is empty.
We could also do 1, 2, 3, does it include 2? Yes, it does.
Does it include 5? No, it does not.
We could do the same thing with hashes.
We can have has key and has value.
Let's just try one of those real quick, and I will make just a real simple hash here.
There we go, 1, and b will point to 2, and then we will take that hash and we
will just say does it has key a? Yes, it does.
Does it have key symbol a? No, it does not.
We could do the same thing with has_value.
Does it have the value 2? Yes, it does.
So there are going to be a lot more comparisons that we can learn to do in Ruby
and a lot more of these methods that are going to return Booleans.
The main thing is to understand the basic concept and understand how you can
use these comparison and logic operators to construct a Boolean expression.


# Ranges #

Now a range is going to typically be a range of numbers.
Right, so let's say numbers from 1-10.
Well, we could have an array that would contain all of those numbers or we
could simply have a range which will say well, here is the starting point and
here is the end point. It's from 1-10.
Specially if we have something like 1- 1000, it makes a lot more sense to have
something that just tells us the start and end point instead of trying to
construct an array or something that has all 1000 numbers in it.
We can use a range instead.
And there is two kinds of ranges.
There is the inclusive range, and the exclusive range.

It's just the first number and then either 2 or 3 dots depending on which
one you want to use.
Inclusive would be the numbers 1, 2, 3, 4, 5, 6, 7, 8, 9, 10.
Exclusive range would be 1, 2, 3, 4, 5, 6, 7, 8, 9.
It would exclude the last value.
So it would be one up to but not including 10.
Now when you're programming in Ruby, you'll find that the first one,
the inclusive range, is much more common. Why?
Because you can see both of the values that are included so that makes it nice
and clear what's included in it.
And it's one less character to type.
So that saves us a little bit of typing as well.
But if you need to use the exclusive range, it's there and you can use it.
You could also just do 1..9, which I would say is probably more common and what
I would recommend to you.
Let's try them out, see how they work.
So I am going to open up irb and let's start by just trying out that simple
inclusive range, 1-10.
You see that it returned 1..10 to me.
It didn't return all the numbers.
It didn't expand it.
It kept it as a range.
That's actually a range object.
x =1..10 x.class is a range.
Now I want to show you something here. 1..10.class is gong to give me some problems.
I set the value x equal to that and then ask for its class,
that's not a problem. The problem is with the dots.
The dots get a little bit confusing to Ruby and so it says, "oops, I don't
know what you mean."
If you put simply parentheses around it then it clears it all up.
And then it knows exactly what you mean.
So just be careful with that, with ranges.
If you try to apply one of these methods directly to the range, it will give you some problems.
If you assign it to a value or if you put it in those parentheses then
it will be all cleared up.
We have a couple of methods that we can use here. We have x.begin that will
return the beginning of the range, and end that will return the end of the range.
x.first is another one, and x.last, and those essentially do the same thing.

Let's say y = 1...10, another range but this one is now exclusive range.
Let's ask it for its y.begin and y.end.
Notice that it still reports the same beginning and end, even though it is
exclusive and inclusive.
So be careful with using begin and end on your ranges because it may not be what
you expect it to return.
To show you that they are actually different though I can say, for
example, x.include?(1). Yes, it does.
Does it include 10? Yes, it does.
But if I now try that on y. Does y include 10? No, it does not.
Now what if we actually did want to expand this?
What if we wanted to expand it out so we had all of those numbers 1 through 10
in an array that we could work with.
Well, there is a nice way that we can do that, if we use the array notation,
which is square brackets.
We will put our x inside of it and in front of the x we will put the asterisk.
We call that the splat operator.
So the splat operator in front of it and we will just say z is going to be equal to that.
And there is what it returns.
It breaks it all out.
So x is still equal to just the range but z is now equal to all of those
numbers. They have just spread it out and expanded it into all of its values.
Now numbers are not the only thing that we could have as ranges.
That's the most common thing we will use.
But let's say that we have 'a'..'m'.
So a to m. Actually let me do that again and we will just set alpha equal to it,
alpha.include. Does it include g?
Yes, it does include g because g is in that range between those letters.
And we can do the same thing if we have that splat operator, alpha, here we go.
And that returns all the letters a through m.
So it's a good shorthand to be able to use especially if we're working with
numbers like 1-5000.
but that's really all there is to using ranges. You don't use them that much but
when you do use them, they are really a critical tool to help you out.

# Constants #

They are not true objects in Ruby, they are a part of the language construct and
they point the objects the same way that variables do.
The difference is that a constant is constant.

A variable will change over time.
So x=1, x+=1, now x=2. It's variable.
A constant should stay the same.
Only in Ruby, it's not necessarily the case. Let's see.

We have already seen the way that we specify a variable name like test = 1, right?
That's a simple variable name.
Well, the way we want to specify constant names is with all capitals.
TEST equals, let's say, 2.
Two different things to return two different values.
The first is a variable, the second is a constant.
Now there are couple of quirks with constants that it's important for you to
know about and that's the main reason why I wanted to include it here.
The first is that actually anything that begins with a capital letter at the
beginning, it's like a variable, is considered a constant.
So Hello equals, let's just say, 10 for now.
Okay, that is actually going to be a constant and we'll see how we can tell the
difference in one moment.
The second quirk is that, of course, if we change a variable, test = 100, no problem.
But TEST = 100 comes back and gives us a warning and says you've already
initialized the constant TEST.
Because this is a constant,
it did not want to let us do that, but it did do it.
It is not truly constant.
It did go ahead, even though it raised this warning to us, letting us know that we
shouldn't be doing this, it went ahead and did it and the same thing is true
with Hello = 20, let's say. Same thing.
It's a constant, and that's how we can tell that it's a constant.
So those are the two quirks that I want to make sure I highlight to you.
These kinds of quirks are totally the kind of thing that I can see changing in
future versions of Ruby.

Most importantly what I want to make sure is that you saw that this is the way
to name your variables, not using these capital letters, because in that case,
it will consider a constant.
So you do want to always use all lower case for your variable names and that's
really all there is to working with constants.





 

