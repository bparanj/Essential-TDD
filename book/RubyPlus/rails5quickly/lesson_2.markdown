CHAPTER 2
=============
Hello Rails
------------------------------


## Objective ##

- To create a home page for your web application.

## Steps ##

### Step 1 ###

Open the config/routes.rb file in your IDE, routes.rb defines the routes that is installed on your web application. Rails will recognize the routes you define in this configuration file.

### Step 2 ###

Add the line :   
 
```ruby
root 'welcome#index'
```

to the routes.rb. So it now looks like this:

```ruby
Rails.application.routes.draw do
  root 'welcome#index'
end
```

The method root() takes a string parameter. In this case it maps the home page of your site to welcome controller (a class), index action (a method).

 \newpage

### Step 3 ###

Go to the terminal and change directory to the blog project and run:

```ruby
rails routes
```

```sh
Prefix Verb URI Pattern Controller#Action
  root GET  /           welcome#index
```

The output of this command shows you the installed routes. Rails will be able to recognize the GET request for welcome page.

The output has four columns, namely Prefix, Verb, URI Pattern and Controller#Action.

Prefix is the name of the helper that you can use in your view and controller to take the user to a given view or controller. In this case it is root_path or root_url that is mapped to your home page.

Verb is the Http Verb such as GET, POST, PUT, DELETE etc.

URI Pattern is what you see in the browser URL. In this case, it is http://localhost:3000

\newpage

### Step 4 ###

Go to the browser and reload the page : http://localhost:3000

![Uninitialized Constant WelcomeController](./figures/welcome_controller_absent.png)

We see the uninitialized constant WelcomeController routing error. This happens because we don't have a welcome controller to handle the incoming GET request for the home page.

### Step 5 ###

You can either open a new terminal and go to the blog project directory or open a new tab in your terminal and go to the blog project directory.

### Step 6 ###

In this new tab or the terminal, go the blog project directory and type:
 
```ruby
$rails g controller welcome index
```

You will see the output:

```sh
create  app/controllers/welcome_controller.rb
 route  get 'welcome/index'
invoke  erb
create    app/views/welcome
create    app/views/welcome/index.html.erb
invoke  test_unit
create    test/controllers/welcome_controller_test.rb
invoke  helper
create    app/helpers/welcome_helper.rb
invoke    test_unit
invoke  assets
invoke    coffee
create      app/assets/javascripts/welcome.coffee
invoke    css
create      app/assets/stylesheets/welcome.css
```
  
![Create WelcomeController](./figures/create_controller.png)

rails command takes the arguments g for generate, then the controller name and the action. In this case the controller name is welcome and the action name is index.

\newpage

### Step 7 ###

Reload the web browser again. 

![Welcome Page](./figures/welcome_index.png)

You will now see the welcome page.

### Step 8 ###

Go to app/views/welcome/index.html.erb and change it to 'Hello Rails' like this:

```ruby
<h1>Hello Rails</h1>
```

Save the file.

You can embed ruby in .html.erb files. The .erb stands for embedded Ruby. In this case we have html only. We will see how to embed ruby in views in the next lesson.

\newpage

### Step 9 ###

Reload the browser. 
 
![Hello Rails](./figures/hello_rails.png)
 
Now you will see 'Hello Rails' as the home page content.

### Step 10 ###

Open the welcome_controller.rb in app/controllers directory and look at the index action. 

### Step 11 ###

Look at the terminal where you have the rails server running, you will see the request shown in the following image:

```sh
Started GET "/" for ::1 at 2016-07-05 15:22:44 -0700
Processing by WelcomeController#index as HTML
  Rendering welcome/index.html.erb within layouts/application
  Rendered welcome/index.html.erb within layouts/application (0.5ms)
Completed 200 OK in 25ms (Views: 22.8ms | ActiveRecord: 0.0ms)
```

![Server Output](./figures/server_output_1.png)

You can see that the browser made a GET request for the resource '/' which is the home page of your site. The request was processed by the server where Rails recognized the request and it routed the request to the welcome controller, index action. Since we did not do anything in the index action, Rails looks for the view that has the same name as the action and renders that view. In this case, the view that corresponds to the index action is app/views/welcome/index.html.erb.

### Step 12 ###

Open a new terminal or a new tab and go to Rails console by running:

```ruby
$rails c
```

from the blog project directory.

 \newpage

### Step 13 ###

In Rails console run:

```ruby
app.get '/'
```

Here we are simulating the browser GET request for the resource '/', which is your home page.

```sh
Started GET "/" for 127.0.0.1 at 2016-07-05 15:26:25 -0700
Processing by WelcomeController#index as HTML
  Rendering welcome/index.html.erb within layouts/application
  Rendered welcome/index.html.erb within layouts/application (1.4ms)
Completed 200 OK in 295ms (Views: 272.8ms | ActiveRecord: 0.0ms)
```

![Simulating Browser GET Request](./figures/get_request.png)

You can see the http status code is 200. You can also see which view was rendered for this request.

 \newpage
 
 
## Exercise ##

Can you go to http://localhost:3000/welcome/index and explain why you see the contents shown in the page?

Before you go to the next page and read the answer, make an attempt to answer this question.

\newpage

## Answer ##

You will see the same 'Hello Rails' page. Because if you check the rails server log you can see it made a request : GET '/welcome/index' and if you look at the config/routes.rb file, you see :

```ruby
get 'welcome/index'
```

This line in routes was added when you ran the rails generator to create the welcome controller. This definition is used by the Rails router to handle this request. It knows the URI pattern of the format 'welcome/index' with http verb GET must be handled by the welcome controller, index action.

![GET Request for Home Page](./figures/get_welcome_index.png)

\newpage
  
### Step 14 ###

Delete the  get "welcome/index"  line in the config/routes.rb file. Reload the page, by entering this URL in the browser : http://localhost:3000/welcome/index
 
![Welcome Index](./figures/welcome_index_routing_error.png) 

```sh
No route matches [GET] "/welcome/index"
```
 
You will now see the error page. Since we no longer need this route, we can ignore this error message because the home page will be accessed by typing just the domain name of your site like this: www.mysite.com

 \newpage
 
## Summary ##
 
 In this lesson we wrote a simple *Hello Rails* program. We saw how the router recognizes the browser request and how the view and controller work in Rails to handle it. We have seen just the View and Controller part of MVC framework. We will see how the model fits in the MVC framework in the next lesson.
 
 \newpage
 