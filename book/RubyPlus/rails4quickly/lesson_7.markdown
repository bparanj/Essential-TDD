CHAPTER 7
=============
Show Article
------------------------------


## Objective ##

- Learn how to display a selected article in the article show page.

## Steps ##

### Step 1 ###

Add the 'Show' link to each article in the index page. The hyperlink text will be 'Show'.

```ruby
<%= link_to 'Show', ? %>
```

When the user clicks the 'Show' link we need to go the articles controller show action. We will retrieve the record from the database and display it in the view. 

What should be the url helper? 

\newpage

You can view the output of rake routes to find the url helper to use in the view. In this case we know the resource end point. We go from the right most column to the left most column and find the url helper under the Prefix column.

![URL Helper For Show](./figures/rake_routes_show.png)

So, we now have :

```ruby
<%= link_to 'Show', article_path %>
```

\newpage

### Step 2 ###

Go to Rails console and type:

```ruby
app.article_path
```

![Article Path Error](./figures/article_path_error.png)

Rails does not recognize the article_path. 

\newpage

### Step 3 ###

Look at the output of rake routes command. You can see in the URI pattern column the :id variable for primary key. 

![Show Article Path Primary Key](./figures/article_path_id.png)

So we need to pass the id as the parameter as shown below:

```ruby
<%= link_to 'Show', article_path(article.id) %>
```

![Show Article Path](./figures/app_article_path.png)

Rails recognizes article path when an id is passed in as the parameter to the url helper method.

You can see the generated string is the same as the URI pattern in the output of the rake routes command.

![Show Article Path](./figures/article_show_path.png)

We can simplify it even further by letting Rails call the id method for us by just passing the article object.

\newpage

### Step 4 ###

Since Rails automatically calls the id method of the ActiveRecord we can simplify it as follows:

```ruby
<%= link_to 'Show', article_path(article) %>
```

\newpage

### Step 5 ###

Rails has optimized this even further so you can do :

```ruby
<%= link_to 'Show', article %>
```

Let's now see how Rails makes this magic happen. 

![Loading First Article from Database](./figures/first_article.png)

Retrieving first article from database in Rails console.

![Show Article Path](./figures/show_article_path.png)

Experimenting in Rails console to check the generated URI for a given article resource.

Rails internally uses the polymorphic_path method that takes an argument to generate the url.

\newpage

### Step 6 ###

The app/views/articles/index.html.erb looks as shown below:

```ruby
<h1>Listing Articles</h1>

<% @articles.each do |article| %>

	<%= article.title %> : 

	<%= article.description %> 
	
	<%= link_to 'Edit', edit_article_path(article) %>
	<%= link_to 'Show', article_path(article) %>
	
	<br/>

<% end %>
<br/>
<%= link_to 'New Article', new_article_path %>
```

\newpage

### Step 7 ###

Reload the articles index page http://localhost:3000/articles 

![Show Link](./figures/show_link.png)

You will see the show link.

\newpage

### Step 8 ###

If you view the page source for articles index page, you will see the hyperlink for 'Show' with the URI pattern '/articles/1'. Since this is a hyperlink the browser will use the http verb GET when the user clicks on show.

![Show Link Source](./figures/show_link_source.png)

\newpage

In the rails server log you will see the GET request for the resource '/articles/1'. In this case the value of :id is 1. Rails will automatically populate the params hash with :id as the key and the value as the primary key of the record which in this case is 1. We can retrieve the value of the primary key from the params hash and load the record from the database.

![Http GET Request](./figures/get_articles_server_log)

Server log is another friend.

### Step 9 ###

If you click on the 'Show' link you will get the 'Unknown action' error.

![Unknown Action Show](./figures/unknown_action_show.png)

As we saw in the previous step, we can get the primary key from the params hash. So, define the show action in the articles controller as follows:

```ruby
def show
  @article = Article.find(params[:id])
end
```

We already know the instance variable @article will be made available in the view.

### Step 10 ###

If you click the 'Show' link, you will get the 'Template is missing' error. 

![Template Missing Error](./figures/show_template_missing)

We need a view to display the selected article. Let's define app/views/show.html.erb with the following content:

```ruby
<p>
  <%= @article.title %><br>
</p>

<p>
  <%= @article.description %><br>
</p>
```

Since the @article variable was initialized in the show action, we can retrieve the values of the columns for this particular record and display it in the view. Now the 'Show' link will work. 

## Summary ##

In this lesson we saw how to display a selected article in the show page. In the next lesson we will see how to delete a given record from the database.

\newpage
