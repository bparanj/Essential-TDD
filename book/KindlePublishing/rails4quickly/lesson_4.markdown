# Model View Controller #

## Objective ##

- Learn how the View communicates with Controller 
- Learn how Controller interacts with the Model and how Controller picks the next View to show to the user.

## Steps ##

### Step 1 ###

Let's modify the existing static page in welcome/index.html.erb to use a view helper for hyperlink:

```ruby
<%= link_to 'My Blog', ? %>
```

The tag <%= should be used whenever you want the generated output to be shown in the browser. If it not to be shown to the browser and it is only for dynamic embedding of Ruby code then you should use <% %> tags.

The link_to(text, url) method is a view helper that will generate an html hyperlink that users can click to navigate to a web page. In this case we want the user to go to articles controller index page. Because we want to get all the articles from the database and display them in the app/views/articles/index.html.erb page.
 
So the question is what should replace the ? in the second parameter to the link_to view helper? Since we know we need to go to articles controller index action, let use the output of rake routes to find the name of the view_helper we can use.
 
![Rake Routes](./figures/rake_routes_2.png)
 
As you can see from the output, for articles#index the Prefix value is articles. So we can use either articles_path (relative url) or articles_url (absolute url). 
 
### Step 2 ###

Change the link as follows :

```ruby
<%= link_to 'My Blog', articles_path %>
```

### Step 3 ###
   
Go to the home page by going to the http://localhost:3000 in the browser. 

![My Blog](./figures/my_blog_link.png)

### Step 4 ###

You will the hyper link in the home page. Right click and do 'View Page Source', you will the hyperlink which is a relative url. 

![Relative URL](./figures/hyperlink_source.png)

### Step 5 ###

Change the articles_path to articles_url in the welcome/index.html.erb. View page source you will see the absolute URL.

![Absolute URL](./figures/hyperlink_source2.png)

### Step 6 ###

Click on the 'My Blog' link. You will see the following error page.

![Missing Articles Controller](./figures/articles_controller_missing.png)

### Step 7 ###

When you click on that link, you can see from rails server log that the client made a request:

![Articles Http Request](./figures/articles_controller_output.png)

GET '/articles' that was recognized by the Rails router and it looked for articles controller. Since we don't have the articles controller, we get the error message for the uninitialized constant. In Ruby class names are constant.

### Step 8 ###

Create the articles controller by running the following command in the blog directory:

```ruby
$ rails g controller articles index 
```
 
### Step 9 ###

Go back to the home page and click on My Blog link. You will see a static page.

![Articles Page](./figures/static_articles_list_page.png)

### Step 10 ###

We need to replace the static page with the list of articles from the database. Open the articles_controller.rb and change the index method as follows :

```ruby
def index
	@articles = Article.all
end
```

Here the @articles is an instance variable of the articles controller class. It is made available to the corresponding view class. In this case the view is app/views/articles/index.html.erb

### Step 11 ###

Open the app/views/articles/index.html.erb in your IDE and add the following code:

```ruby
<h1>Listing Articles</h1>

<% @articles.each do |article| %>

  <%= article.title %> <br/>

  <%= article.description %>

<% end %>
```

Here we are using the Ruby scriptlet tag <% %> for looping through all the records in the articles collection and the values of each record is displayed using <%= %> tags.

### Step 12 ###

Go to the browser and reload the page for http://localhost:3000/articles You should see the list of articles now displayed in the browser.

![ ](./figures/listing_articles.png)

## Explanation ##

View --> Controller --> Model
						|__________ View

As you can see from the diagram Controller controls the flow of data into and out of the database and also decides which View should be rendered next.

###  Summary ###
 
In this chapter we went from the view (home page) to the controller for articles and to the article model and back to the view (index page for articles). So the MVC components interaction was : View --> Controller --> Model --> View. The data flow was from the database to the user. 

\newpage


In real world the user data comes from the user so we cannot create them in the rails console or in the database directly. In the next chapter we will see how we can capture data from the view provided by the user and save it in the database.

### Exercise ###

Go to the rails server log terminal, what is the http verb used to make the request for displaying all the articles? What is the resource that was requested?

\newpage
