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

The output on my machine is : ruby 2.2.0p0 (2014-12-25 revision 49005) [x86_64-darwin11.0]

```ruby  
$ rails -v
```

The output on my machine is: Rails 4.2.0

```ruby
$ gem env
```		 

The output on my machine is: RUBYGEMS VERSION: 2.4.5

### Step 2 ###
 
Change directory to where you want to work on new projects. 

```ruby
$ cd projects
```

### Step 3 ###

Create a new Rails project called blog by running the following command.

```ruby
$ rails new blog
```

### Step 4 ###

Open a terminal and change directory to the blog project.

```ruby
$ cd blog
```

### Step 5 ###

Open the blog project in your favorite IDE. For textmate :

```ruby
$ mate .
```

### Step 6 ###

Run the rails server:

```ruby
$ rails s
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

### Step 9 ###

Click on the 'About' link and check the versions of software installed. If the background of the about section is yellow, installation is fine. If it is red then something is wrong with the installation.

\newpage

![Details About Your Environment](./figures/about_env.png)

\newpage


## Explanation					

The rails generator automatically runs the Bundler command bundle to install your application dependencies by reading the Gemfile. The Gemfile contains all the gems that your application needs. rails s (s is a short-cut for server) runs your server on your machine on port 3000.

## Summary ##

In this lesson you learned how to run the server locally. We also saw how to check if everything is installed properly on our machine. In the next lesson you will learn how to create a home page for your web appliction.

\newpage
