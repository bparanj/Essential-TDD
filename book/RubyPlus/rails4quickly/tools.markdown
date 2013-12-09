#  B. Troubleshooting #

1. Use rails console to experiment.
2. To inspect a variables in views you can use debug, to_yaml and inspect.

```ruby
<%=  debug(@article) %>
```

will display the @article object in YAML format.

The to_yaml can be used anywhere (not just views). You can do a query in Rails console and call to_yaml on an article object.

```ruby
article = Article.first
article.to_yaml
```

The inspect method is handy to display values in arrays and hashes. 

```ruby
a = [1,2,3,4]

p a.inspect
```

If you customize the to_s method in your classes then the inspect method will use your to_s method to create a human friendly representation of the object.

```ruby
class Car
  
  def to_s
    "I am a car"
  end
end

c = Car.new

print c
```


3. You can use logger.info in the controller to log messages to the log file. In development log messages will go to development.log in log directory.

```ruby
logger.info "You can log anything here #{@article.inspect}"
```

To use the logger in model, you have to do the following:

```ruby
Rails.logger.info "My logging goes here"
```

4. Using tail to view development log file.

Open a new tab in the terminal (On Mac Command+T opens a new tab on an existing open terminal), go the rails project blog directory and type the following command:

```ruby
$ tail -f log/development.log
```

5. View source in the browser. For example: Checking if path to images are correct. 
6. Use rails dbconsole
7. Firebug Firefox plugin, Chrome Dev Tools or something equivalent
8. Debugger in Rubymine is simply the best debugger. JetBrains updates fixes any issues with Ruby debugging gems and provides a well integrated IDE for serious development.
9. Useful plugins:

- [Rails Footnotes](https://github.com/josevalim/rails-footnotes "Rails Footnotes")
- [Rails Panel](https://github.com/dejan/rails_panel "Rails Panel")


\newpage

# C. FAQ #

1. Adding a new source to gem.

```ruby
$ gem sources -a http://gems.github.com
```

2. Suppress installing rdoc for gems. For example to install passenger gem without any rdoc or ri type:
	
```ruby	
$ gem install passenger -d --no-rdoc --no-ri
```

3. How to upgrade gems on my system?

```ruby
$ gem update —system
```

\newpage

