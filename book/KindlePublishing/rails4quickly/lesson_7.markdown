# 7. Show Article #

## Steps ##

### Step 1 ###

Add the 'Show' link to each article in the index page. The hyperlink text will be 'Show'.

```ruby
<%= link_to 'Show', ? %>
```

When the user clicks the 'Show' link we need to go the articles controller show action. We will retrieve the record from the database and display it in the view. What should be the url helper? You can view the output of rake routes to find the url helper to use in the view. In this case we know the resource end point. We go from the right most column to the left most column and find the url helper under the Prefix column.

![URL Helper For Show](./figures/rake_routes_show.png)

```ruby
<%= link_to 'Show', article_path %>
```

Since we need the primary key to load the selected article from the database, we need to pass the id as the parameter as below:

```ruby
<%= link_to 'Show', article_path(article.id) %>
```

Since Rails automatically calls the id method of the ActiveRecord we can simplify it as follows:

```ruby
<%= link_to 'Show', article_path(article) %>
```

Rails 4 has optimized this even further so you can do :

```ruby
<%= link_to 'Show', article %>
```

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

### Step 2 ###

Reload the articles index page http://localhost:3000/articles 

![Show Link](./figures/show_link.png)

You will see the show link.

\newpage

### Step 3 ###

If you view the page source for articles index page, you will see the hyperlink for 'Show' with the URI pattern '/articles/1'. Since this is a hyperlink the browser will use the http verb GET when the user clicks on show.

![Show Link Source](./figures/show_link_source.png)

\newpage

In the rails server log you will see the GET request for the resource '/articles/1'. In this case the value of :id is 1. Rails will automatically populate the params hash with :id as the key and the value as the primary key of the record which in this case is 1. We can retrieve the value of the primary key from the params hash and load the record from the database.

![Http GET Request](./figures/get_articles_server_log)

Server log is another friend.

### Step 4 ###

If you click on the 'Show' link you will get the 'Unknown action' error.

![Unknown Action Show](./figures/unknown_action_show.png)

As we saw in the previous step, we can get the primary key from the params hash. So, define the show action in the articles controller as follows:

```ruby
def show
  @article = Article.find(params[:id])
end
```

We already know the instance variable @article will be made available in the view.

### Step 5 ###

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
