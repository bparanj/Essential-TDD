CHAPTER 4
=============
Model View Controller
------------------------------

## Objectives ##

- Learn how the View communicates with the Controller 
- Learn how Controller interacts with the Model and how Controller picks the next View to show to the user.

## Context ##

Router knows which controller can handle the incoming request. Controller is like a traffic cop who controls the flow of traffic on busy streets. Controller has the knowledge of which model can get the job done, so it delegates the work to the appropriate model object. Controller also knows which view to display to the user after the incoming request has been processed.

Why MVC architecture? The advantage of MVC is the clean separation of View from the Model and Controller. It allows you to allocate work to teams according to their strengths. The View layer can be developed in parallel by the front-end developers without waiting for the Model and Controller parts to be completed by the back-end developers.

If we agree on the contract between the front-end and back-end by defining the data representation exchanged between the client and server then we can develop in parallel.

## Steps ##

### Step 1 ###

Let's modify the existing static page in app/views/welcome/index.html.erb to use a view helper for hyperlink:

```ruby
<%= link_to 'My Blog', ? %>
```

The tag <%= should be used whenever you want the generated output to be shown in the browser. If it is not to be shown to the browser and it is only for dynamic embedding of Ruby code then you should use <% %> tags.

The link_to(text, url) method is a view helper that will generate an html hyperlink that users can click to navigate to a web page. In this case we want the user to go to articles controller, index page. Because we want to get all the articles from the database and display them in the app/views/articles/index.html.erb page.
 
So the question is what should replace the ? in the second parameter to the link_to view helper? Since we know we need to go to articles controller, index action, let's use the output of rake routes to find the name of the view_helper we can use.
 
![Rake Routes](./figures/rake_routes_2.png)
 
As you can see from the output, for articles#index the Prefix value is articles. So we can use either articles_path (relative url, which would be /articles) or articles_url (absolute url, which would be www.example.com/articles). 
 
\newpage
 
### Step 2 ###

Change the link as follows :

```ruby
<%= link_to 'My Blog', articles_path %>
```

### Step 3 ###
   
Go to the home page by going to the http://localhost:3000 in the browser. 

![My Blog](./figures/my_blog_link.png)

What do you see in the home page?

\newpage

You will see the hyper link in the home page. 

### Step 4 ###

Right click and do 'View Page Source' in Chrome or 'Show Page Source' in Safari.

![Page Source for Relative URL](./figures/hyperlink_source.png)

You will see the hyperlink which is a relative url. 


\newpage

### Step 5 ###

Change the articles_path to articles_url in the welcome/index.html.erb. 

![Page Source for Absolute URL](./figures/hyperlink_source2.png)

Reload the page. 

\newpage

### Step 6 ###

Click on the 'My Blog' link. 

![Missing Articles Controller](./figures/articles_controller_missing.png)

You will see the above error page with 'unitialized constant ArticlesController' error.

\newpage

### Step 7 ###

When you click on that link, you can see from rails server log that the client made a request:

![Articles Http Request](./figures/articles_controller_output.png)

GET '/articles' that was recognized by the Rails router and it looked for articles controller. Since we don't have the articles controller, we get the error message for the uninitialized constant. In Ruby, class names are constant.

\newpage

![Live HTTP Headers Client Server Interaction](./figures/live_http_headers_4.png)

You can also use HTTP Live Headers Chrome plugin to see the client and server interactions.\

\newpage

![Live HTTP Headers Showing Client Server Interaction](./figures/live_http_headers.png)

Here you see the client-server interaction details. As you see in the above figure, you can learn a lot by looking at the Live HTTP Header details such as Etag which is used for caching by Rails.

![Live HTTP Headers Gives Ton of Information](./figures/live_http_headers_2.png)


\newpage

### Step 8 ###

Create the articles controller by running the following command in the blog directory:

![Generate Controller](./figures/generate_articles_controller.png)

```ruby
$ rails g controller articles index 
```

\newpage 

### Step 9 ###

Go back to the home page and click on My Blog link. 

![Articles Page](./figures/static_articles_list_page.png)

You will see a static page.

\newpage

### Step 10 ###

We need to replace the static page with the list of articles from the database. Open the articles_controller.rb in the app/controllers directory and change the index method as follows :

```ruby
def index
  @articles = Article.all
end
```

Here the @articles is an instance variable of the articles controller class. It is made available to the corresponding view class by Rails. In this case the view is app/views/articles/index.html.erb

The class method 'all' retrieves all the records from the articles table.

### Step 11 ###

Open the app/views/articles/index.html.erb in your code editor and add the following code:

```ruby
<h1>Listing Articles</h1>

<% @articles.each do |article| %>

  <%= article.title %> 

  <%= article.description %>
<br/>
<% end %>
```

Here we are using the Ruby scriptlet tag <% %> for looping through all the records in the articles collection and the values of each record is displayed in the browser using <%= %> tags.

\newpage

If you make a mistake and use <%= %> tags instead of Ruby scriptlet tag in app/views/index.html.erb like this:

```ruby
<%= @articles.each do |article| %>
```

You will see the objects in the array displayed on the browser.

![Using the Wrong Tags](./figures/wrong_tags.png)

Articles are displayed as objects inside an array.

\newpage

If you use the Ruby scriptlet tag :

```ruby
Title : 	<% article.title %>
```

instead of the tags used to evaluate expressions and display to the browser then you will not see it in the browser.

![No Title Value in Browser](./figures/no_output_in_browser.png)

\newpage

### Step 12 ###

Go to the browser and reload the page for http://localhost:3000/articles 

![List of Articles](./figures/listing_articles.png)

You should see the list of articles now displayed in the browser.

\newpage

![Model View Controller](./figures/mvc)

As you can see from the diagram Controller controls the flow of data into and out of the database and also decides which View should be rendered next.

\newpage

## Exercise ##

Go to the rails server log terminal, what is the http verb used to make the request for displaying all the articles? What is the resource that was requested?

##  Summary ##
 
In this lesson we went from the view (home page) to the controller for articles and to the article model and back to the view (index page for articles). So the MVC components interaction as shown in the diagram: 

1. View to Controller 
2. Controller to Model 
3. Controller to View

The data flow was from the database to the user. In the real world the user data comes from the user so we cannot create them in the rails console or in the database directly. In the next lesson we will see how we can capture data from the view provided by the user and save it in the database.


\newpage
