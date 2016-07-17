CHAPTER 1
=============
Running the Server
------------------------------
 
## Objective ##

- To run your rails application on your machine and check your application's environment.

## Steps ##

### Step 1					

Check the versions of installed ruby, rails and ruby gems by running the following commands in the terminal:

```ruby
$ ruby -v
```

The output on my machine is : ruby 2.3.1p112 (2016-04-26 revision 54768) [x86_64-darwin11.0]

```ruby  
$ rails -v
```

The output on my machine is: Rails 5.0.0
 
```ruby    
$ gem env
```		 
The output on my machine is: RUBYGEMS VERSION: 2.5.1

### Step 2 ###
 
Change directory to where you want to work on new projects. 

```ruby
$ cd projects
```

### Step 3 ###

Create a new Rails project called blog by running the following command.

```ruby
$ rails new blog --skip-spring
```

We are skipping Spring because we don't need it.

### Step 4 ###

Open a terminal and change directory to the blog project.

```ruby
$ cd blog
```

### Step 5 ###

Open the blog project in your favorite IDE. For textmate:

```ruby
$ mate .
```

### Step 6 ###

Run the rails server:

```sh
$rails s

=> Booting Puma
=> Rails 5.0.0 application starting in development on http://localhost:3000
=> Run `rails server -h` for more startup options
Puma starting in single mode...
* Version 3.4.0 (ruby 2.3.1-p112), codename: Owl Bowl Brawl
* Min threads: 5, max threads: 5
* Environment: development
* Listening on tcp://localhost:3000
Use Ctrl-C to stop
```

![Rails Server](./figures/rails_server.png)

\newpage

### Step 7 ###

Open a browser window and enter http://localhost:3000

![Welcome Aboard](./figures/welcome_page.png)

Welcome page displayed as the home page.

\newpage

### Step 8 ###

You can shutdown your server by pressing Control+C. 

## Explanation					

The rails generator automatically runs the Bundler command bundle to install your application dependencies by reading the Gemfile. The Gemfile contains all the gems that your application needs. rails s (s is a short-cut for server) runs your server on your machine on port 3000.

## Summary ##

In this lesson you learned how to run the server locally. In the next lesson you will learn how to create a home page for your web application.

\newpage
