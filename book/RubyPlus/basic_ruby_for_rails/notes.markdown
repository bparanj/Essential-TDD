
http://www.chrisducker.com/virtual-assistants-101/


1. What is the difference between load and require? When do you use load vs require?
2. I have two person objects. How can I compare them?
3. What is the difference between class and module?
4. I have a person class with greet method. What are the different ways to invoke the greet method? How do I invoke the greet method if it has argument?
5. What is the difference between symbol and string?

6. Is print a language keyword or a method?
7. 

module A
  def hello
    'A'
  end
end

module B
  def hello
    'B'
  end
end

class Test
  include A
  include B
end

t = Test.new

p t.hello


8. How does Test::Unit Framework execute all the tests automatically?
9. What is closure? Can you give an example?


# Introspection

## Language Constructs 

Objects, classes, modules, instance variables, methods etc are language constructs. You can read language constructs at runtime. 

class Greeting
  def initialize(text)
    @text = text
  end
  
  def welcome
    @text
  end
end

obj = Greeting.new('Hi')

I can use language constructs to ask questions.

obj.class
inherited = false
obj.class.instance_methods(inherited)
obj.instance_variables

The false flag makes the inherited instance_methods to be not included.

You can also write language constructs at runtime. You can add new instance methods to a class while the program is running.

## Metaprogramming 

Metaprogramming is writing code that manipulates language constructs at runtime. You are not separated from the code that you're writing from the code that computer executes when you run the program. Metaprogramming manipulates these language constructs. Master metaprogramming to tap into the full power of the Ruby language. 

## The Object Model

Object model answers questions like:

1. Which class does this method come from?
2. What happens when I include this module?

## Open Classes

class String
  def	to_alphanumeric
    
  end
end

## Inside Class Definitions

In Ruby there is no real distinction between code that defines a class and code of any other kind.

3.times do
  class C
    p 'hi'
  end
end

This prints hi three times. Ruby executed the code within the class just as it would execute any other code. However, it did not define 3 classes with the same name.

class D
  def x
    'x'
  end
end

class D
  def y
    'y'
  end
end

o = D.new

p o.x
p o.y

The class keyword is more like a scope operator than a class declaration. Yes, it does create classes that don't yet exist, but you might argue that it does this as a side effect. For class, the core job is to move you in the context of teh class, where you can define methods.

Check if the method already exists before you define your own methods. Like this :

p [].methods.grep(/^re/)

This displays the list of all methods that begin with 're'.

["reject!", "reject", "replace", "reverse", "reverse_each", "reverse!", "respond_to?", "reduce"]

(selector namespace is Ruby 2.0 ?)

## Objects and Classes

class MyClass
  def foo
    @v = 1
  end
end

o = MyClass.new
p o.class

### Instance Variables

Objects contain instance variables.

p o.instance_variables

The output is empty.

o.foo

p o.instance_variables

The output now has instance variable @v.

There is no connection between an object's class and it's instance variables. Instance variables spring into existence when you assign them a value.

### Methods

Objects also have methods. 

p o.methods.grep(/foo/)

The outputs displays the foo method of MyClass. 

Objects that share the same class also share the same methods, so the methods must be stored in the class. The foo is an instance method of MyClass. Meaning that it's defined in MyClass and you actually need an instance of MyClass to call it.

Diagram on page 5 of 2013_09_22_13_25_38_ruby.pdf

When you talk about the object, you simply call it a method.

p String.instance_methods == "x".methods

prints true whereas:

p String.methods == "x".methods

prints false.

Objects of the same class share methods but don't share instance variables.

### Classes

Classes are objects. Class is an object. They have their own class, as instances of a class called Class.

p 'x'.class

prints String

p String.class

prints Class

p Class.class

prints Class

Classes also have methods. The methods of a class are the instance methods of Class.

inherited = false

p Class.instance_methods(inherited)

prints :

["superclass", "allocate", "new"]


p String.superclass
Object
p Object.superclass
BasicObject
p BasicObject.superclass
nil
p Class.superclass
Module
p Module.superclass
Object

Class is a souped up module with 3 additional methods : new, allocate, superclass that allow you to create objects or arrange classes into hierarchies.

Diagram on page 7 of 2013_09_22_13_25_38_ruby.pdf

MyClass and o1 are both references. The only difference is that o1 is a variable, while MyClass is a constant. Class is an object. Class name is a constant.

### Constants

Any reference that begins with an uppercase letter, including the names of classes and modules is a constant.

module M
  Y = 1
  class C
  end
end

p M.constants

prints : ["C", "Y"]

module M
  class C
    module M2
      p Module.nesting
    end
  end
end

prints : [M::C::M2, M::C, M]

The load is used to execute code, require is used to import libraries. The difference is that load will reload the file if you load a file again whereas import will not. Also load requires the extension of the file and can take an optional second parameter as a flag to indicate whether to wrap the loaded library in an anonymous module.

### Namespace

module Zepho
  class String
  end
end

Prevents clashes.

## Ruby Object Model

What's the class of Object?
What's the superclass of Module?
What's the class of Class?

Add o3 to the diagram:

o3 = MyClass.new
o3.instance_variable_set('@x', 10)

Use irb and Ruby documentation to find out the answers.

Diagram on page 8 of 2013_09_22_13_25_38_ruby.pdf

### What Happens When You Call a Method

Ruby does two things:

1. It finds the method. This process is called method lookup.
2. It executes the method. To do that, Ruby needs something called self.

Method lookup and self will help us find where a particular method was defined. 

### Method Lookup

Simplest case of method lookup: When you call a method, Ruby looks into the object's class and find the method there.

Receiver

The object that you call a method on is the receiver. Ex: 'fido'.reverse, 'fido' is the receiver.

Ancestors Chain

Look at any Ruby class, move from the class into its superclass, then into the superclass's superclass and so on, until you reach BasicObject (the root of the Ruby class hierarchy). The path of classes you traversed is the ancestors chain of the class.

Method lookup: To find a method, Ruby goes in the receiver's class, and from there it climbs the ancestors chain until it finds the method.

class MyClass
  def greet
    p 'hi'
  end
end

class MySubClass < MyClass
end

o = MySubClass.new
o.greet

When you call greet() method, Ruby goes right from object o, the receiver, into MySubClass. Since it can't find greet() method there, Ruby continues its search by going up into MyClass, where it finally finds the method. If it hadn't found the method there, Ruby would have climbed up the chain into Object and then BasicObject. One step to the right, then up. Rule : Go one step to the right into the receiver's class and then go up the ancestors chain until you find the method. You can ask a class for its ancestors chain:

MyClass.ancestors

Diagram on page 10 of 2013_09_22_13_25_38_ruby.pdf

### Modules and Lookup

You learned that the ancestors chain goes from class to superclass. Actually, the ancestors chain also includes modules.

module M
  def foo
    'M#foo'
  end
end

class C
  include M
end

class D < C
end

p D.new.foo()

"M#foo"

When you include a module in a class (or even in another module), Ruby creates an anonymous class that wraps the module and inserts the anonymous class in the chain, just above the including class itself.

p D.ancestors

prints : [D, C, M, Object, Kernel]

Here the module M appears after the class C. These wrapper classes are called include classes (or proxy classes). You cannot access them from regular Ruby code. 

### The Kernel

p Kernel.private_instance_methods.grep(/^pr/)

prints : ["print", "proc", "printf"]

The class Object includes Kernel, so Kernel gets into every object's ancestors chain. Since you are always sitting inside an object, you can call the Kernel methods from anywhere. So print is not a language keyword, it's a method.

Diagram on page 12 of 2013_09_22_13_25_38_ruby.pdf

If you add a method to Kernel, this Kernel method will be available to all objects. Ex: RubyGems:

module Kernel
  def gem(name, *reqs)
    
  end
end

### Method Execution

When you call a method, Ruby does two things:

1. It finds the method
2. It executes the method

def foo
  t = @x + 1
  bar(t)
end

To execute this method, you need to answer two questions:

1. What object does the instance variable @x belong to?
2. What object should you call bar() mthod on?

When you call a method, Ruby needs to tuck away a reference to the receiver. Now, it can remember the receiver as it executes the method.

Discovering self : Every line of Ruby code is executed inside an object. It is called current object. The current object is also known as self, because you can access it with the self keyword.

Only one object can take the role of self at a given time, but no object holds that role for a long time. When you call a method, the receiver becomes self. From that moment on, all instance variables are instance variables of self and all methods called without an explicit receiver are  called on self. As soon as your code explicitly calls a method on some other object, that other object becomes self.

class A
  def foo
    @v = 10 # instance variable of self
    bar     # same as self.bar
    self
  end
  
  def bar
    @v = @v+1
  end
end

o = A.new
p o.foo 

<A:0x109f16300 @v=11>

The receiver o becomes self. Because of that, the instance variable @v is an instance variable of o and the method bar() is called on o. As bar() is executed, o is still 'self', so @v is still an instance variable of o. Finally foo returns a reference to self. The output of @v will be 11.

You should always know which object has the role self at any given moment. In most cases, you have to track which object was the last method receiver.

### The Top Level

What is self when you haven't called any method yet?

self
self.class

You are in the context of main object that the Ruby interpreter created. This object is called the top level context. Because its the object you're in when you're at the top level of the call stack : either you haven't called any method yet or all the methods that you called have returned.

### Class Definitions and Self

In a class or module definition (outside of any method) the role of self is taken by the class or module:

class MyClass
  self
end

When you call a method, Ruby looks up the method by following the 'one step to the right, then up' rule and then executes the method with the receiver as self. There are some special cases (eg. when you include a module) but there are no exceptions.

### Private Method

Rule : You cannot call a private method with an explicit receiver. You can call a private method only with an implicit receiver - self. 

Can you call a private method that you inherited from a superclass?

### Object Model

An object is composed of a bunch of instance variables and a link to a class. The methods of an object live in the object's class (from the point of view of the class, they're called instance methods).

The class itself is just an object of class Class. The name of the class is just a constant. Class is a subclass of Module. A module is a package of methods and constants. A class can also be instantiated with new() or arranged in a hierarchy (through its superclass).

Constants are arranged in a tree similar to a file system, where the names of modules and classes play the part of directories and regular constants play the part of files.

Each class has an ancestors chain, beginning with the class itself and going up to BasicObject. When you call a method, Ruby goes right into the class of the receiver and then up the ancestor chain, until it either finds the method or reaches the end of the chain. Every time a class includes a module, the module is inserted in the ancestors chain right above the class itself. When you call a method, the receiver takes the role of self. When you're defining a module (or a class), the module takes the role of self. Instance variables are always assumed to be instance variables of self. Any method called without an explicit receiver is assumed to be a method of self.

## Methods

Ruby does not have compiler policing method calls. Until that line of code is executed, everything works fine.

## Dynamic Methods

How to call and define methods dynamically and avoid duplication.

### Calling Methods Dynamically

class Car
  
  def start(speed)
    p "Starting speed : #{speed}"
  end
  
end

c = Car.new
c.start(0)

c.send(:start, 10)

c.method(:start).call(20)

The first argument can be string or symbol that represents the name of a method. The arguments and blocks are passsed to the method.

With send(), the name of the method that you want to call becomes a regular argument. You can wait until the last moment to decide which method to call, while the code is running. This is called Dynamic Dispatch.

### Camping Framework

In config file: 

admin:Bill

Configuration code: 

conf.admin = 'Bill'

Parses the YAML file to get the keys at runtime. For each key-value pair, it composes the name of an assignment method such as admin=() and sends the method to conf.

YAML.load_file(conf.rc).each do |k, v|
  conf.send("#{k}=", v)
end

### Test::Unit Framework

method_names = public_instance_methods(true)
tests = method_names.delete_if{|method_name| method_name !~ |^test|}

The aray now has all test methods. Later, it uses send() to call each method in the array. This flavor of Dynamic Dispatch is called Pattern Dispatch, before it filters methods based on a pattern in their names.

You can call methods dynamically. You can also define methods dynamically.

### Defining Methods Dynamically

You can define a method with Module#define_method(). Method name and block becomes the method body.

class Car
  define_method :start do |x|
    x * 3
  end
end

c = Car.new
p c.start(2)

prints 6

define_method is executed with Car, so start is defined as an instance method of Car. This technique of defining a method at runtime is called a Dynamic Method.

### Method Missing

It's an instance method of Kernel. It's a private method. NoMethorError come from method_missing(). Overriding method_missing() - You can override it to intercept unknown messages. Each message landing on method_missing includes the name of the method that was called, any arguments and blocks associated with the call. 

class Car
  def method_missing(method, *args)
    
  end
end

### Dynamic Proxies

Collect method calls through method_missing and forward them to the wrapped object. Tip : 

p Object.instance_methods.grep(/^d/)

prints ["dup", "display"]

Look for duplication not just inside methods but also among methods. 

## Blocks

Blocks are a powerful tool for controlling scope, meaning which variables and methods can be seen by which lines of code. Blocks, procs and lambdas are callable objects. We can store a block and execute it later. Blocks are functional programming language construct. 

### Basics of Blocks 

An overview of scopes and how you can carry variables through scopes by using blocks as closures. Manipulate scopes by passing a block to instance_eval. Convert blocks into callable objects that you can set aside and call later, such as Procs and lambdas.

### Basics

def foo(a, b)
  a + yield(a, b)
end

p foo(1,2) {|x,y| (x+y) * 3}

prints 10

You can define a block only when you call a method. The block is passed straight into the method and the method can then call back to the block with the yield keyword.

A block can have arguments, when you call back to the block, you can provide values for it's arguments, just like a method call. Also like a method, a block returns the result of the last line of code it evaluates.

### The Current Block

Within a method, you can ask Ruby whether the current call includes a block. 

Kernel#block_given?

def foo
  return yield if block_given?
  'no block'
end

foo
foo { 'here is a block' }

prints :

"no block"
"here is a block"

If you use yield when block_given? is false, you'll get a runtime error. 

Quiz Solution

module Kernel
  def using(resource)
    begin
      yield
    ensure
      resource.dispose
    end
  end
end

You can't define a new keyword, but you can fake it with a Kernel Method. The method takes the managed resources as an argument. It also takes a block, which it executes. Whether or not the block completes normally, the ensure clauses calls dispose on the resource to release it cleanly. In case of an exception, Kernel#using also rethrows the exception to the caller.

### Closures

Learn how to smuggle variables across scopes. Code that runs is actually made up of two things : the code itself and a set of bindings. 

Code						Bindings

x = a + 1      a ----> 2
x += @b			  @b ----> 4

Something that runs :

x = a + 1 ----> 3
x += @b   ----> 7

A block is not just a floating piece of code. You can't run code in vacuum. When code runs, it needs an environment: local variables, instance variables, self... Since these entities are basically name bound to objects, you can call them the bindings for short. Blocks contain both the code and a set of bindings. They are ready to run. 

Block picks up its bindings by simply grabbing the bindings that are there at that moment when you define the block. Then it carries those bindings along when you pass the block into a method. 

def foo
  x = 'Goodbye'
  yield('cruel')
end

x = 'Hello'
p foo {|y| "#{x}; #{y} world"}

prints : "Hello; cruel world"

When you create the block, you capture the local bindings, such as x. Then you pass the block to a method that has its own set of bindings. In the example, the bindings also include a variable named x. Still, the code in the block sees the x that was around when the block was defined, not the method's x, which is not visible at all in the block. We can say that a block is a closure. Closure means a block captures the local bindings and carries them along with it. So how do you use closures in practice? To understand that, you need to take a closer look at the place where all the bindings reside - the scope. Here you'll learn to identify the spots where a program changes scope and you'll encounter a particular problem when changing scopes that can be solved with closures.

### Scope

Imagine being a debugger making your way through a Ruby program. You jump from statement to statement until you finally hit a breakpoint. Now, look around, the scenery around you is the scope. You can see bindings, local variables, you are within an object, with its own methods and instance variables; that's the current object, also known as self. You can also see constants and global variables. 

### Changing Scope

This example shows how scope changes as your program runs, tracking the names of bindings with the Kernel#local_variables method:

v1 = 1
class C
  v2 = 2
  p local_variables
  
  def m
    v3 = 3
    p local_variables
  end
  p local_variables
end

o = C.new
p o.m
p o.m

Let's track the program as it moves through scopes. It starts within the top level scope, where it defines v1. Then it enters the scope of C's definition. As soon as you enter a new scope, the previous bindings are simply replaced by a new set of bindings. This means that when the program enters C, v1 falls out of scope and is no longer visible.

in the scope of the definition of C, the program defines v2 and a method. The code in the method isn't executed yet, so the program never opens a new scope until the end of the class definition. At that moment, the scope opened with the class keyword is closed forever and the program gets back to the top-level scope.

What happens when the program creates a C object and calls method m twice. The first time the program enters m() it opens a new scope and defines a local variable v3. Then the program exits the method, falling back to the top-level scope. At this point, the method's scope is lost. When the program calls m() a second time, it opens yet another new scope and it defines a new v3 variable (unrelated to previous v3, which is now lost). Finally the program returns to the top level scope, where you can see v1 and o again.

The example's important point : 'Whenever the program changes scope, some bindings are replaced by a new set of bindings'. This doesn't happen to all the bindings each and every time. For example, if a method calls another method on the same object, instance variables stay in scope through the call. In general, bindings tend to fall out of scope when the scope changes. In particular local variables change at every new scope. 

### Scope Gates

You can spot scopes more quickly if you learn about scope gates. There are exactly three places where a program leaves the previous scope behind and opens a new one:

- Class definitions
- Module definitions
- Methods

Scope changes whenever the program enters or exits a class or module definition or a method. These three borders are marked by the keywords class, module and def respectively. Each of these keywords acts like a Scope Gate. 

v1 = 1

class C             # Scope Gate : Entering class
  v2 = 2
 p local_variables   # ['v2']
  def m             # Scope Gate : Entering def
    v3 = 3
  p  local_variables
  end
  p local_variables    # ['v2']
end                  # Scope Gate : Leaving class

o = C.new
o.m          [:v3]
o.m          [:v3]
local_variables ["v1", "o"]

The program opens four separate scopes: the top-level scope, one new scope when it enters C and one new scope each time it calls m().

The code in a class or module definition is executed immediately. Conversely, the code in a method definition is executed later, when you eventually call the method.

What if you want to pass a variable through one of the scope gates?

### Flattening the Scope

How do you pass bindings through a Scope Gate?

v = 'success'
class MyClass
  def m
    
  end
end

Scope gates are a barrier, as soon as you walk through one of them, local variables fall out of scope. How can you carry v across two scope gates?

Look at the class Scope Gate first. You can't pass v through it, but you can replace class with something else that is not a Scope Gate : a method. If you could use a method in place of class, you could capture v in a closure and pass that closure to the method. Can you think of a method that does the same thing that class does?

Class.new is a perfect replacement for class. You can also define instance methods in the class if you pass a block to Class.new():

v = 'success'
C = Class.new do
  # Now we can print v here
  puts "#{v} in the class definition"
  
  def m
    # How can we print it here ?
  end
end

Now, how can you pass v through the def scope gate? Once again, you have to replace the keyword with a method. Instead of def, you can use Module#define_method

v = 'success'
C = Class.new do
  p "#{v} in the class definition"
  
  define_method :m do
    p "#{v} in the method"
  end
end

C.new.m

prints :

"success in the class definition"
"success in the method"

If you replace Scope Gates with methods, you allow one scope to see variables from another scope. This is flattening the scope : meaning that the two scopes share variables as if the scopes were squeezed together.

### Sharing the Scope

You can do whatever you want with scopes using Flat Scopes. Example: You want to share a variable among a few methods and you don't want anybody else to see that variable. You can do that by defining all the methods in the same Flat Scope as the variable:

def define_methods
  shared = 0

  Kernel.send :define_method, :counter do
    shared
  end
  
  Kernel.send :define_method, :inc do |x|
    shared += x
  end
end

define_methods
p counter         ----> 0
 inc(4)
p counter					----> 4

This example defines two Kernel methods. We had to use Dynamic Dispatch to access the private method define_method() on Kernel. Both Kernel#counter and Kernel#inc can see the shared variable. No other method can see shared, because it's protected by a Scope Gate. This smart way to control the sharing of variables is called a Shared Scope.

With the combination of Scope Gates, Flat Scopes and Shared Scopes, you can twist and bend your scopes to see exactly the variables you need, from the place you want.

### Scope Summary

Each Ruby scope contains a bunch of bindings and the scopes are separated by Scope Gates : class, module and def. To sneak binding through a Scope Gate, you can replace the Scope Gate with a method call : you capture the current bindings in a closure and pass the closure to the method. You can replace class with Class.new, module with Module.new and def with Module#define_method(). This is a Flat Scope, the basic closure related concept. If you define multiple methods in the same Flat Scope, maybe protected by a Scope Gate, all those methods can share bindings. That's called a Shared Scope.

### Instance Eval

Another way to mix code and bindings at will. Let's evaluate a block in the context of an object:

class C
  def initialize
    @v = 1
  end
end

o = C.new
o.instance_eval do
  p self
  p @v
end

prints:

<C:0x1027b5540 @v=1>
1

The block is evaluated with the receiver as self, so it can access the receiver's private methods and instance variables such as @v. Even if instance_eval() changes self, it leaves all the other bindings alone :

class C
  def initialize
    @v = 1
  end
end

o = C.new
v = 2
o.instance_eval { @v = v }
p o.instance_eval { @v }

prints : 2

The three lines above are evaluated in the same Flat Scope, so they can all access the local variable v - but the blocks are evaluated with the object as self, so they can also access o's instance variable @v. In all these cases, you can call the block that you pass to instance_eval a Context Probe, because it's like a snippet of code that you dip inside an object to do something in there.

### Clean Rooms

Sometimes you create an object just to evaluate blocks inside it. An object like that is called a Clean Room.

class CleanRoom
  def complex_calc
    
  end
  
  def do_something
    
  end
end

cr = CleanRoom.new
cr.instance_eval do
  if complex_calc > 10
    do_something
  end
end

A Clean Room is just an environment where you can evaluate your blocks and it usually exposes a few useful methods that the block can call.

### Callable Objects

Using a block is a two-step process. First, you set some code aside and second you call the block (with yield) to execute code. This package code first, call it later mechanism is not exclusive to blocks. You can package code:

1. In a proc (which is a block turned object)
2. In a lambda (which is slight variation on a proc)
3. In a method.

### Proc Objects

Blocks are not objects. To store a block and execute it later, you need an object. Ruby provides the standard library class Proc. A Proc is a block that has been turned into an object. You can create a Proc by passing the block to Proc.new. Later, you can evaluate the block-turned-object with Proc#call():

inc = Proc.new {|x| x+ 1 }
inc.call(2)

This technique is called Deferred Evaluation. Ruby provides two Kernel Methods that convert a block to a Proc: lambda() and proc().

dec = lambda {|x| x - 1}
dec.class ---> Proc
dec.call(2)

### The & Operator

The & operator converts a block to a Proc. A block is like an additional, anonymous argument to a method. In most cases, you execute the block right there in the method, using yield. There are two cases where yield is not enough:

- You want to pass the block to another method
- You want to convert the block to a Proc

In both cases, you need to point at the block and say, "I want to use this block" - to do that, you need a name. To attach a binding to the block, you can add one special argument to the method. This argument must be the last in the list of arguments and prefixed by an & sign. Here's a method that passes the block to another method:

def add(a, b)
  yield(a, b)
end

def teach_add(a, b, &operation)
  p 'Lets do the math'
  p math(a, b, &operation)
end

teach_math(2,3) { |x,y| x * y }

THIS EXAMPLE IS NOT WORKING

If you call teach_math without a block, the & operation argument is bound to nil and the yield operation in math() fails.

What if you want to convert the block to a Proc? As it turns out, if you referenced operation in the previous code, you'd already have a Proc object. The meaning of &: 'This is a Proc that I want to use as a block'. Just drop the &, and you'll be left with a Proc again.

def m(&tproc)
  tproc
end

p = m { |name| "Hello #{name}" }
p p.class
p p.call('Bugs')

Proc
"Hello Bugs"

These are the different ways to covert a block to a Proc. But what if you want to convert it back? Again, you can use the & operator to covert the Proc to a block.

def m(greet)
  p "#{greet}, #{yield}"
end

my_proc = proc { "Bugs" }
m("Hello", &my_proc)

"Hello, Bugs"

When you call m() method, the & converts the my_proc to a block and passes that block to the method. Now we know how to convert a block to a Proc and vice-versa.

The Highline gem is a good example of Deferred Evaluation. It is an example of a callable object that starts its life as a lambda and is then coverted to a regular block.

### Procs vs Lambdas

There are two differences between procs and lambdas. In a lambda, return just returns from the lambda:

def double(callable_object)
  callable_object.call * 2
end

l = lambda { return 10 }

p double(l)

prints 20

In a proc, return returns from the scope where the proc itself was defined. 

def double
  p = Proc.new{return 10}
  result = p.call
  return result * 2  # unreachable code
end

p double

prints 10

This distinction avoids buggy code like:

def double(callable_object)
  callable_object.call * 2
end

p = Proc.new{ return 10 }

double(p)

LocalJumpError: unexpected return

This tries to return from the scope where p is defined. Since you can't return from the top-level scope, the program fails. To fix this bug, avoid using explicit returns:

def double(callable_object)
  callable_object.call * 2
end

p = Proc.new{ 10 }

print double(p)

prints 20

Lambdas are less tolerant than procs when it comes to arguments. Call a lambda with the wrong arity, and it fails with an ArgumentError. A proc fits the argument list to its own expectations:

p = Proc.new {|a,b| [a,b]}
puts p.call(1,2,3)      ----> [1, 2]
puts p.call(1)					----> [1, nil]

If there are too many arguments a proc drops the excess arguments. If there are too few arguments, it assigns nil to the missing arguments. 

p.arity 

prints 2.

use lambdas as first choice, unless you need the specific features of procs.

### Methods

Are just callable objects.

class C
  def initialize(value)
    @x = value
  end
  def foo
    @x
  end
end

o = C.new(1)
m = o.method(:foo)
print m.call

prints 1.

By calling Object#method() you get the method itself as a Method object, which you can later execute with Method#call(). A Method object is similar to a lambda, with an important difference : a lambda is evaluated in the scope it's defined in (it's a closure), while a Method is evaluated in the scope of its object. 

You can detach a method from its object with Method#unbind() which returns an UnboundMethod object. You can't execute an UnboundMethod, but you can turn it back into a Method by binding it to an object.

class C
  def initialize(value)
    @x = value
  end
  def foo
    @x
  end
end

o = C.new(1)
m = o.method(:foo)

unbound = m.unbind
f = C.new(2)
n = unbound.bind(f)
puts n.call

prints 2.

This technique works only if f has the same class as the method's original object. Otherwise you'll get an exception.

You can convert a Method object to a Proc object by calling Method#to_proc and you can convert a block to a method with define_method().

## Callable Objects Summary

Callable objects are snippets of code that you can evaluate and they carry their own scope along with them. They can be the following:

Blocks : They aren't objects, but they are still callable. Evaluated in the scope in which they're defined.

Procs: Objects of class Proc. Like blocks, they are evaluated in the scope where they're defined.

Lambdas : Also objects of class Proc but subtly different from procs. They're closures like blocks and procs and as such they're evaluated in the scope where they're defined.

Methods: Bound to an object, they are evaluated in that object's scope. They can also be unbound from their scope and rebound to the scope of another object.

You can convert from one callable object to another by using Proc.new(), Method#to_proc() or the & operator.


## Block-Local Variables










  
  








