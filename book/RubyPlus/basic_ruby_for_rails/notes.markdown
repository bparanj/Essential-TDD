
http://www.chrisducker.com/virtual-assistants-101/

Interview Questions

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

A block captures the bindings that are around when you first define the block. You can also define additonal bindings inside the block, but they disappear after the block ends:

def foo
  yield
end

top_level_variable = 1

foo do
  top_level_variable += 1
  local_to_block = 1
end

p top_level_variable 
p local_to_block     

# top_level_variable ----> 2
# local_to_block     ----> Error


Instance Exec

This is similar to instance_eval, but it also allows you to pass arguments to the block:

class C
  def initialize
    @x, @y = 1,2
  end
end

p C.new.instance_exec(3){|a|(@x + @y) * a }

prints 9.

Class Definitions

In Ruby, when you use the class keyword, you are not dictating how objects will behave in the future. You are actually running code. Ruby class definition is actually regular code that runs.

Inside Class Definitions

You can put any code you want in a class definition.

class C
  p 'hi'
end

prints hi

Class definitions also return the value of the last statement, just like methods and blocks. 

result = class C
           self
         end
         
p result

prints C.

In a class definition, the class itself takes the role of the current object self. Classes and modules are objects. So a class can be self. 

Current Class

Wherever you are in a Ruby program, you always have a current object : self. Likewise, you always have a current class or module. When you define a method, that method becomes an instance method of the current class.

You can get a reference to the current object through self. There's no equivalent keyword to get a reference to the current class. You can keep track of the current class just by looking at the code. Whenever you open a class with the class keyword ( or a module with module keyword), that class becomes the current class:

class C
  The current class is C
  def foo
    so this is an instance method of C
  end
end

The class keyword has a limitation: it needs the name of a class. In some situations you may not know the name of the class that you want to open. Ex: A method that takes a class and adds a new instance method to it:

def add_method_to(a_class)
  define method foo() on a_class.
end

How can you open a class if you don't know it's name? You need some way other than the class keyword to change the current class. Enter the class_eval() method.

class_eval() : Module#class_eval (alternate name module_eval()) evaluates a block in the context of an existing class: 

def add_method_to(a_class)
  a_class.class_eval do
    def foo
      'hi'
    end
  end
end

add_method_to(String)

p 'abc'.foo

prints 'hi'.

By changing the current class, class_eval effectively reopens the class, just like the class keyword. Class eval is more flexible than class. You can use class_eval on any variable that references the class, while class requires a constant. Also, class opens a new scope, losing sight of the current bindings, while class_eval has a flat scope. This means you can reference variables from the outer scope in a class_eval block.

Current Class Summary

In a class definition, the current object self is the class being defined. The Ruby interpreter always keeps a reference to the current class (or module). All methods defined with def become instance methods of the current class.

In a class definition, the current class is the same as self - the class being defined. If you have a reference to the class,  you can open the class with class_eval. At the top level, the current class is Object, the class of main. So, if you define a method at the top level, that method becomes an instance method of Object.

$irb
1.9.2p180 :001 > def m
1.9.2p180 :002?>   'hi'
1.9.2p180 :003?>   end
 => nil 
1.9.2p180 :004 > o = Object.new
 => #<Object:0x00000101850370> 
1.9.2p180 :005 > o.m
NoMethodError: private method `m' called for #<Object:0x00000101850370>
	from (irb):5
	from /Users/bparanj/.rvm/rubies/ruby-1.9.2-p180/bin/irb:16:in `<main>'
1.9.2p180 :006 > o.send(:m)
 => "hi" 

Class Instance Variables

The Ruby interpreter assumes that all instance variables belong to the current object self. This is also true in a class definition:

class C
  @v = 1
end

In a class definition, the role of self belongs to the class itself, so the instance variable @v belongs to the class. Instance variables of the class are different from instance variables of that class's objects.

class C
   @v = 1
  
  def self.read
    @v
  end
  
  def write
    @v = 2
  end
  
  def read
    @v
  end
end

o = C.new
o.write
p o.read
p C.read

prints 2 and 1.

The two instance variables @v are named same but they're defined in different scopes and they belong to different objects. To see how this works, remember that classes are just objects and you have to track self through the program. One @v is defined with o as self, so itss an instance variable of the o object. The other @v is defined with C as self, so its an instance variable of the C object - a Class Instance Variable. They are instance variables that belong to an object of class Class. Because of that, a Class Instance Variable can be accessed only by the class itself - not by an instance or by a subclass.

Class Variables

A class variable is identified by an @@ prefix: 

class C
  @@v = 1
end

Class variables are different from Class Instance Variables, because they can be accessed by subclasses and by regular instance methods. Go to irb:

@@v = 1
class D
  def m
    @@v
  end
end

p D.new.m

prints 1.

Class variables don't belong to classes - they belong to class hierarchies. Since @@v is defined in the context of main, it belongs to main's class Object and to all the descendants of Object. D inherits from Object, so it  ends up sharing the same class variable.

## Singleton Methods

Ruby allows you to add a method to a single object.

s = 'a regular string'
def s.title?
  self.upcase == self
end

p s.title?
p s.methods.grep(/title?/)
p s.singleton_methods

false
["title?"]
["title?"]

A method which is specific to a single object is called a Singleton Method. In Ruby, type of an object is not strictly related to its class. Instead, the type is simply the set of methods to which an object can respond. 

## Class Methods

Classes are just objects and class names are just constants. So, calling a method on a class is the same as calling a method on an object:

an_object.a_method 
a_class.a_class_method

In the first case, we call a method on an object referenced by a variable. In the second case, we call a method on an object (that also happens to be a class) referenced by a constant.

Class methods are Singleton Methods of a class. If you compare the definition of a Singleton Method and the definition of a class method, you'll see that they are the same:

def obj.a_singleton_method
def C.a_class_method

If you're writing code in a class definition, you can take advantage of the fact that self is the class itself. Then you can use self in place of the class name to define a class method:

class C
  self.a_class_method
end

So, you always define a Singleton Method in the same way:

def object.method

object can be an object reference, a constant class name or self.

## Class Macros

class C
  attr_accessor :cost
end

All the attr_* methods are defined on class Module so you can use them whenever self is a module or a class. Class macros look like keywords, but they are just regular class methods that are meant to be used in a class definition.

## Eigen Classes

Ruby finds methods by going right into the receiver's class and then up the class hierarchy.

class C
  def m
    
  end
end

o = C.new
o.m()

When you call m(), Ruby goes right into C and finds the method there.

Page 17 diagram on from 2013_09_22_13_30_49_ruby.pdf

What happens if you define a Singleton Method on o?

def o.my_singleton_method
  
end

The Singleton Method can't live in o, because o is not a class. It can't live in C, because if it did, all instances of C would share it. And it cannot be an instance method of C's superclass, Object.

Class methods are a special kind of Singleton Method:

def C.my_class_method
  
end

Diagram on page 18 of 2013_09_22_13_30_49_ruby.pdf

And again my_class_method is not in the diagram. An object can have a hidden class. If you want to get a reference to the eigenclass, you can return self out of the scope of the eigenclass.

o = Object.new
eigenclass = class << o
               self
             end
p eigenclass


prints Class.

Eigenclasses have only a single instance. They are also called singleton classes. They can't be inherited.

An object's Singleton methods live in an Eigen class. 

o = Object.new
eigenclass = class << o
self
end

eigenclass

def o.my_singleton_method
end

p   eigenclass.instance_methods.grep(/my_/)  

prints ["my_singleton_method"]

class_eval changes both self and the current class. instance_eval changes self and the current class to the eigenclass of the receiver. Example using instance_eval to define a Singleton Method.

s1, s2 = 'abc', 'def'
s1.instance_eval do
  def woo
    reverse
  end
end

p s1.woo
p s2.respond_to?(:woo)
p s1.respond_to?(:woo)

prints :

"cba"
false
true

It's rare to see instance_eval used to change the current class. The standard meaning of instance_eval is : I want to change self.

## Method Lookup

class C
  def m
    'C#m()'
  end
end

class D < C
end

o = D.new
p o.m()

prints "C#m()"

Diagram on page 20 in 2013_09_22_13_30_49_ruby.pdf

The method lookup goes 'one step to the right, then up'. When you call o.m(), Ruby goes right into o's class D. From there, it climbs up the ancestors chain until it finds m() in class C. 

## Eigen Classes and Method Lookup

Helper method that returns the eigenclass of any object:

class Object
  def eigenclass
    class << self
      self
    end
  end
end

p 'ab'.eigenclass

Since class methods are just Singleton methods that live in the class's eigenclass, you can just open the eigenclass and define the method inside:

class C
  class << self
    def m
      
    end
  end
end

Diagram on page 21 of 2013_09_22_13_30_49_ruby.pdf.

class << o
  def a_singleton_m
    'o#a_singleton_m'
  end
end

We know that an eigenclass is a class, so it must have a superclass. Which is the superclass of the eigenclass?

o.eigenclass.superclass ----> D

The superclass of o's eigenclass is D. This diagram shows how Singleton Methods fit into the normal process of method lookup. If an object has an eigenclass, Ruby starts looking for methods in the eigenclass rather than a class and that's why you can call Singleton methods such as o#a_singleton_m(). If Ruby can't find the method in the eigenclass then it goes up the ancestors chain, ending in the super class of the eigenclass - which is the object's class. From there everything is same as before.

## Eigenclasses and Inheritance

class C
  class << self
    def a_class_method
      'C.a_class_method()'
    end
  end
end

p C.eigenclass
p D.eigenclass
p D.eigenclass.superclass
p C.eigenclass.superclass

prints, C, D, C, Object

Diagram on page 22 of 2013_09_22_13_30_49_ruby.pdf

S - Link classes to their super classes
C - Link objects (including classes) to their classes, which in this case are all eigenclasses.

C do not point at the same classes that the class() method would return, because the class() method doesn't know about eigenclasses. For example, o.class() would return D, even if the class of object o is actually its eigenclass, #o.

Diagram on page 23 on 2013_09_22_13_30_49_ruby.pdf

The superclass of #D is #C, which is also the eigenclass of C. By the same rule, the superclass of #C is #Object. The superclass of the eigenclass is the eigenclass of the superclass. Due to this arrangement, you can call a class method on a sub class:

D.a_class_method ----> C.a_class_method()

Even if a_class_method() is defined on C, you can call it on D. This is possible because method lookup starts in #D and goes up to the #D's superclass #C, where it finds the method.

The Seven Rules of the Ruby Object Model

1. There is only one kind of object - be it a regular object or a module.
2. There is only one kind of module - be it a regular module, a class, an eigen class or a proxy class.
3. There is only one kind of method and it lives in a module - most often in a class.
4. Every object, class included, has its own 'real class', be it a regular class or an eigen class.
5. Every class has exactly one superclass, with the exception of BasicObject. This means you have a single ancestors chain from any class upto BasicObject.
6. The superclass of the eigenclass of an object is the object's class. The superclass of the eigenclass of a class is the eigenclass of the class's superclass.
7. When you call a method, Ruby goes right in the receiver's real class and then up the ancestors chain.

## Class Attributes

class C
  attr_accessor :a
end

o = C.new
o.a = 2
p o.a

prints 2. attr_accessor method generates for any object. But what if you want to define an attribute on a class instead? You can reopen Class and define attributes there:

class C
  attr_accessor :b
end

This works, but it adds the attribute to all classes. If you want an attribute that's specific to C, you can define the attribute in the eigenclass. 

class C
  class << self
    attr_accessor :c
  end
end

C.c = 'It works'
p C.c

prints "It works".

An attribute is actually a pair of methods. If you define those methods in the eigenclass, they become class methods; as if you had written this:

def C.c=(value)
  @c = value
end

def C.c
  @c
end

Class attributes live in the class's eigenclass. 

Diagram on page 26 of 2013_09_22_13_30_49_ruby.pdf

Diagram on page 27 of 2013_09_22_13_30_49_ruby.pdf

The superclass of #BasicObject is class. This explains why you can call MyClass#b() and MyClass#b=().

## Modules and Class Methods

module MyModule
  def self.my_method
    'hi'
  end
end

class MyClass
  include MyModule
end

MyClass.my_method 

gives undefined method my_method error.

When a class includes a module, it gets the module's instance methods - not the class methods. Class methods stay out of reach, in the module's eigenclass.

Solution : First, define my_method as a regular instance method of MyModule. Then include the module in the eigenclass of MyClass.

module MyModule
  def my_method
    'hi'
  end
end

class MyClass
  class << self
    include MyModule
  end
end

p MyClass.my_method 

prints hi

my_method() is an instance method of the eigenclass of MyClass. As such, my_method() is also a class method of MyClass. This technique is called Class Extension.

## Class Methods and include()

You can define class methods by mixing them into the class's eigenclass. Class methods are special case of Singleton methods, so you can generalize this trick to any object. In the general case, this is called Object Extension. Ex: Object o is extended with the instance methods of MyModule:

module MyModule
  def my_method
    'hi'
  end
end

o = Object.new
class << o
  include MyModule
end

p o.my_method
p o.singleton_methods

prints :

"hi"
["my_method"]

Opening the eigenclass is a way to extend a class or an object. Here is an alternative technique.

## Object#extend

Class extensions and Object extensions are common, Ruby provides a method for them, Object#extend() 

module MyModule
  def my_method
    p 'hi'
  end
end

o = Object.new
o.extend MyModule
o.my_method

prints 'hi'

class MyClass
  extend MyModule
end

MyClass.my_method

prints 'hi'

Object#extend() is a shortcut that includes a module in the receiver's eigenclass.

## Aliases

We have a method that we can't modify directly, because it is in a library. We want to wrap additional functionality around this method so that all clients get the additional functionality automatically.

### Method Aliases

You can give an alternate name to a Ruby method by using the alias keyword. 

class MyClass
  def my_method
    p 'my method'
  end
  
  alias :m :my_method
  
end

o = MyClass.new
o.my_method
o.m

prints 'my_method' twice.

alias :new_name :original_name

alias is a keyword not a method. So there is no comma between method names). Ruby also provides Module#alias_method(), a method equivalent to alias. 

class MyClass
  def m
    p 'hi'
  end
  alias_method :m2, :m
end

o = MyClass.new
o.m2
o.m

prints 'hi' twice.

### Around Aliases

What happens if you alias a method and then redifine it?

class String
  alias :real_length :length
  
  def length
    real_length > 5 ? 'long' : 'short'
  end
end

p 'War and Peace'.length
p 'War and Peace'.real_length

prints :

"long"
13

We redefine String#length, but the alias still refers to the original method. When you redefine a method, you don't change the method. Instead, you define a new method and attach an existing name to that new method. You can still call the old version of the method as long as you have another name that's still attached to it.

The new length() is wrapped around the old length(), that's why this is called an Around Alias. You can write an Around Alias in three simple steps:

1. You alias a method
2. You redefine it
3. You call the old method from the new method

class M < Array
  def m
    p 'hi'
  end
end

Rewrite this without using class keyword. 

c = Class.new(Array) do
  def m
    p 'hi'
  end
end

Since a class is an instance of Class, we can create it by calling Class#new(). Class#new() also accepts an argument (the superclass of the new class) and a block that is evaluated in the context of the new born class.

Now you have a variable that references a class, but the class is still anonymous. The name of the class of the class is just a constant, so you can assign it yourself.

C = c

Now the constant references the Class, and the Class also references the constant. If it weren't for this trick, a class wouldn't be able to know its own name, and you couldn't wirte this:

c.name

"C"

## Introspection

### Semantic Introspection vs Syntactic Introspection

Syntactic introspection is the lowest level of instrospection - direct examination of the program text or token stream. Template based and macors-based metaprogramming usually operate at the syntactic level. 

The higher level alternative to syntactic introspection is semantic introspection or examination of a program through the language's higher-level data structures. In Ruby, it generally means working at the class and method level: creating, rewriting and aliasing methods; intercepting method calls; and manipulating the inheritance chain. This treats existing methods as black boxes instead poking inside their implementations.

## Bottom-Up Programming

Build abstractions from the lowest level. Write the lowest level constructs first and build the program on top of those abstractions. You are writing a DSL in which you build your programs.

## Classes

Facilitate encapsulation and separation of concerns. Every class name is a constant. The constant evaluates to a class object which is an object of the class Class. When we refer to a 'class object', we mean any object that represents a class (including the Class itself). Class object - class Class (superclass of all class objects). Classes can be instantiated. Class names are nouns most often. 

## Modules

- Mixins (multiple inheritance)
- Uses to separate classes into namespaces
- The class Class inherits from Module (every class is also a module)
- Classes cannot be mixed in to other classes and classes cannot extend objects (Modules can)
- Module names are adjectives
- Modules contain behaviors and characteristics that belong to more than one class. Eg: Enumerable, Comparable. Pg 230 Sam's Ruby in 21 days

## Closures

Closures are created when a block or Proc accesses variables defined outside of its scope. Even though the containing block may go out of scope, the variables are kept around until the block or Proc referencing them goes out of scope. 

def get_closure
  data = [1,2,3]
  lambda { data }
end

block = get_closure
p block.call

prints [1, 2, 3]

The anonymous function (the lambda) returned from get_closure, which references the local variable data, which is defined outside of its scope. As long as the block variable is in scope, it will hold its own reference to data and that instance of data will not be destroyed (even after get_closure returns). Each time get_closure is called, data references a different variable (since it is a function-local).


def get_closure
  data = [1,2,3]
  lambda { data }
end

block = get_closure
b2 = get_closure

p block.call.object_id
p b2.call.object_id

prints : 
2157494800
2157494740

Example of closure:

def counter(i=0)
  lambda { i+= 1 } # counter function (proc) increments and returns its counter
end

x = counter
p x.call
p x.call

prints 1, 2

y = counter
p y.call
p y.call

prints 1, 2

The lambda function creates a closure that closes over the current value of the local variable i (i var can be accessed and modified). Each closure gets a separate instance of the var (because it is a var local to a particular instantiation of counter). Since x and y contain references to different instances of the local variable i, they have different state. Page 56, 57 elaborate on the Programming Ruby examples.

MetaProgramming in Ruby - Peter Vanbroekhoven

class ActiveRecord
  def initialize
    @attributes = {}
  end
  def read_attribute(attribute_name)
    @attributes[attribute_name]
  end
end

class Foo < ActiveRecord
end

f = Foo.new
f.read_attribute('mouse')

class Foo < ActiveRecord
  def mouse
    @attributes['mouse']
  end
  def printer
    @attributes['printer']
  end
  def scanner
    @attributes['scanner']
  end
end

class Foo < ActiveRecord
  ['mouse', 'printer', 'scanner'].each do |f|
    define_method(f) { @attribute[f] }
  end
end

def create_plugin(name, keys, values)
  Object.const_get(name).new(keys, values)
end

A Ruby DSL is just Ruby
- Easy to build
- Familiar Syntax
- Abstraction

## DSL Implementation

- Changing self
- Missing constants
- Missing methods
- Implementing custom operators

### Changing Self

The self is the current object, changed by :
1. method calls
2. instance variables
3. class variables
4. dotless methods
5. class defs

### What is self?

Top Level
p self # main
p self.class # Object

banks = self.query do
  p self # main
end

Kernel Module defines puts, raise, require, eval

module Kernel
  def query
    yield
  end
end

banks = query do
  from c: Customer, s: Bank, a: Account
end

Sometimes we want to change self.

class Query
end

module Kernel
  def query(&blk)
    Query.new.instance_eval(&blk)
  end
end

bank = query do
  p self
end

prints Query object.

instance_eval changes self for the duration of a block.

class Query
  def initialize
    @from = {}
  end
  def from(map)
    @from = map
  end
end

banks = query do
  from c: Customer, b: Bank, a: Account
  p self # Query
end

@from is now = {b: Bank, a: Account, c: Customer}

## Missing Constants

Rails can do lazy class loading. 

### Lazy Class Loading

## Implementing Custom Operators

### Operator Overloading

Operators are just methods (==, & ...)

&&, ||, ! are NOT methods





Declarative code reveals semantic intent
Imperative code reveals implementation










  
  








