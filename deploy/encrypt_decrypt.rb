#!/usr/local/bin/ruby
require 'rubygems'
require 'digest/sha1'
require 'highline/import'
require 'clipboard'

# Recall server credentials

def unlock_password(account, domain)
  salt = ask("Enter your secret key : ") do |q|
    q.echo = false
    q.verify_match = true
    q.gather = {"Enter your secret key" => '', "" => ''}
  end
  
  password = Digest::SHA1.hexdigest(domain + account + salt)
  Clipboard.copy(password)  
end

choose do |menu|
  domain = ask("Enter the domain : ")
  menu.prompt = "Please make a selection : "
  
  menu.choice :root do 
    unlock_password('root', domain)
    say("Root password copied.") 
  end

  menu.choice :mysql do 
    unlock_password('mysql', domain)
    say("MySQL password copied.") 
  end

  menu.choice :deploy do 
    unlock_password('deploy', domain)
    say("Deploy password copied.") 
  end
  
  # Generate shadow compatible password using openssl
  menu.choice :shadow do 
    password = ask("Enter your password : ") do |q|
      q.echo = false
    end

    command = "openssl passwd -1 #{password}"
    shadow = `#{command}`
    
    say("Shadow compatible password is : #{shadow}") 
  end
  
end

