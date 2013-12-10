# 2. Hello Rails #

## Objective ##

- To create a home page for your web application.

## Steps ##

### Step 1 ###

Open the config/routes.rb file in your IDE, routes.rb defines the routes that is installed on your web application. Rails will recognize the routes you define in this configuration file.

### Step 2 ###

 Look for the line :   
 
```ruby
# root 'welcome#index'
```

### Step 3 ###

Uncomment that line by removing #.   
 
```ruby
root 'welcome#index'
```		 

The method root() takes a string parameter. In this case it maps the home page of your site to welcome controller (class), index action (method).

 \newpage

### Step 4 ###

Go to the terminal and change directory to the blog project and run:

```ruby
rake routes
```

![Rake Output](./figures/rake_1.png)

The output of this command shows you the installed routes. Rails will be able to recognize the GET request for welcome page.

The output has four columns, namely Prefix, Verb, URI Pattern and Controller#Action.

Prefix is the name of the helper that you can use in your view and controller to take the user to a given view or controller. In this case it is root_path or root_url that is mapped to your home page.

Verb is the Http Verb such as GET, POST, PUT, DELETE etc.

URI Pattern is what you see in the browser URL. In this case, it is www.example.com

\newpage

### Step 5 ###

Go to the browser and reload the page : http://localhost:3000

![Create Controller](./figures/welcome_controller_absent.png)

We see the uninitialized constant WelcomeController error. This happens because we don't have a welcome controller.

\newpage

### Step 6 ###

Go the root of the project and type:
 
```ruby
$ rails g controller welcome index
```

![Create Controller](./figures/create_controller.png)

rails command takes the arguments g for generate, then the controller name and the action.

\newpage

### Step 7 ###

Reload the web browser again. 

![Welcome Page](./figures/welcome_index.png)

You will now see the above page.

### Step 8 ###

Go to app/views/index.html.erb and change it to 'Hello Rails' like this:

```ruby
<h1>Hello Rails</h1>
```

Save the file.

You can embed ruby in .html.erb files. In this case we have html only. We will see how to embed ruby in views in the next lesson.

\newpage

### Step 9 ###

Reload the browser. 
 
![Hello Rails](./figures/hello_rails.png)
 
Now you will see 'Hello Rails'.

### Step 10 ###

Telnet is a great way to learn about HTTP requests. 

![Making HTTP Requests using Telnet](./figures/telnet.png)

Connecting to our blog application via telnet.

The command here simulates the GET HTTP request. The http version is 1.1. The command is followed by 2 line feeds. Just hit the enter key twice for line feeds. The response returns the headers as well as the requested resource which in this case is the home page html document.

![Server Response](./figures/telnet_response.png)

You can see the Http status code, Etag, Cookie and other useful information in the server response.

### Step 11 ###

Open the welcome_controller.rb in app/controllers directory and look at the index action. 

### Step 12 ###

Look at the terminal where you have the rails server running, you will see the request shown in the following image:

![Server Output](./figures/server_output_1.png)

You can see that the browser made a GET request for the resource '/' which is the home page of your site. The request was processed by the server where Rails recognized the request and it routed the request to the welcome controller index action. Since we did not do anything in the index action, Rails looks for the view that has the same name as the action and renders that view. In this case, it is app/views/welcome/index.html.erb.

### Step 13 ###

Go to Rails console by running:

```ruby
$ rails c
```

from the blog project directory.

 \newpage

### Step 14 ###

In Rails console run:

```ruby
app.get '/'
```

Here we are simulating the browser GET request for the resource '/', which is your home page.

![Simulating Browser GET Request](./figures/get_request.png)

The first request makes database calls and processes the incoming request. You can see the http status code is 200. You can also see which view was rendered for this request.

 \newpage
 
### Step 15 ###

In Rails console run the same command again:

```ruby
app.get '/'
```

![Subsequent GET Request Cached Database Calls](./figures/get_request_db_cached.png)

You can see the caching behavior when you retrieve the home page in subsequent calls.

 
## Exercise ##

Can you go to http://localhost:3000/welcome/index and explain why you see the contents shown in the page?

Before you go to the next page and read the answer, make an attempt to answer this question.

\newpage

## Answer ##

You will see the same 'Hello Rails' page. Because if you check the rails server log you can see it made a request : GET '/welcome/index' and if you look at the routes.rb file, you see :

```ruby
get "welcome/index" 
```

This definition is used by the Rails router to handle this request. It knows the URI pattern of the format 'welcome/index' with http verb GET must be handled by the welcome controller index action.

\newpage
  
### Step 16 ###

Delete the  get "welcome/index"  line in the routes.rb file. Reload the page : http://localhost:3000/welcome/index. 
 
![Welcome Index](./figures/welcome_index_routing_error.png) 
 
You will now see the error page.

 \newpage
 
## Summary ##
 
 In this lesson we wrote a simple Hello Rails program. We saw how the view and controller work in Rails to handle browser requests. We have seen just the VC part of MVC framework. We will see how the model fits in the MVC framework in the next lesson.
 
 \newpage
 