# Uncommenter #

## Objective ##

- Using fake objects to speed up test

## The Ugly Before Version ##

test_file.rb

```ruby
# This is a comment
This is not a comment
# Another comment
```

uncommenter_spec.rb

```ruby
require_relative 'uncommenter'

describe Uncommenter do
  it "should uncomment a given file" do
    infile = File.new(Dir.pwd + "/uncommenter/test_file.rb")
    outfile = File.new(Dir.pwd + "/uncommenter/test_file.rb.out", "w")
    
    Uncommenter.uncomment(infile, outfile)
    outfile.close
    
    resultfile = File.open(Dir.pwd + "/uncommenter/test_file.rb.out","r")
    result_string = resultfile.read
    result_string.should == "This is not a comment\n"
    resultfile.close
  end
end
```

uncommenter.rb

```ruby
class Uncommenter
  def self.uncomment(infile, outfile)
    infile.each do |line|
      outfile.print line unless line =~ /\A\s*#/
    end
  end
end
```

This requires manual deleting of the file test_file.rb.out after every test run. Also whenever you access a file system, it is not a unit test anymore. It will run slow. It becomes an integration test and requires setup and cleanup of external resources. 

## The Sexy After Version ##

Here is the spec that runs fast:

uncommenter_spec.rb

```ruby
require_relative 'uncommenter'
require 'stringio'

describe Uncommenter do
  it "should uncomment a given file" do
    input = <<-EOM
    # This is a comment.
      This is not a comment.
    # This is another comment
    EOM
    infile = StringIO.new(input)
    outfile = StringIO.new("")
    
    Uncommenter.uncomment(infile, outfile)
    
    result_string = outfile.string
    result_string.strip.should == "This is not a comment."
  end
end
```

This example illustrates using Ruby builtin StringIO as a Fake object. File accessing is involved. It requires the right read or write mode. It also requires closing and opening the file at the appropriate times. 

StringIO is a ruby builtin class that mimics the interface of the file. This version of spec runs faster than the file accessing version. The spec is also smaller. In this case, StringIO is a real object acting as a Fake object. You don't have to manually write and maintain a Fake object for file processing. Just use the StringIO.

To run the spec:

```ruby
rspec uncommenter/uncommenter_spec.rb --format doc --color
```

## Reference ##

Before version stolen from : The Well Grounded Rubyist

\newpage
