#!/usr/local/bin/ruby
require 'rubygems'
require 'digest/sha1'
require 'highline/import'
require 'clipboard'

# www.rubyplus.com server credentials

def unlock_password(account)
  salt = ask("Enter your secret key : ") do |q|
    q.echo = false
    q.verify_match = true
    q.gather = {"Enter your secret key" => '', "" => ''}
  end
  
  root_password = Digest::SHA1.hexdigest(account + salt)
  Clipboard.copy(root_password)  
end

choose do |menu|
  menu.prompt = "Please make a selection : "
  
  menu.choice :root do 
    unlock_password('rubyplus.com+root')
    say("Root password copied.") 
  end

  menu.choice :mysql do 
    unlock_password('rubyplus.com+mysql')
    say("MySQL password copied.") 
  end

  menu.choice :deploy do 
    unlock_password('rubyplus.com+deploy')
    say("Deploy password copied.") 
  end
  
end


