# 11. Delete Comment #

## Objective ##

- Learn how to work with nested resources

## Steps ##

### Step 1 ###

Let's add 'Delete' link for the comment in app/views/articles/show.html.erb. We know the hyperlink text will be 'Delete Comment', so:

```ruby
<%= link_to 'Delete Comment', ? %>
```

What should be URL helper to use in the second parameter?

### Step 2 ###

From the blog directory run:

```ruby
$ rake routes | grep comments
```

![Filtered Routes](./figures/filtered_routes.png)

We are filtering the routes only to the nested routes so that it is easier to read the output in the terminal.

\newpage

### Step 3 ###

The Prefix column here is blank for the comments controller destroy action. So we go up and look for the very first non blank value in the Prefix column and find the URL helper for delete comment feature.

![Delete URL Helper for Nested Routes](./figures/nested_routes_delete.png)

So, we now have:

```ruby
<%= link_to 'Delete Comment', article_comment(article, comment) %>
```

![Nested Routes Foreign and Primary Keys](./figures/nested_routes_key.png)

We need to pass two parameters to the URL helper because in the URI pattern column you can see the :article_id as well as the primary key for comment :id. You already know that Rails is intelligent enough to call the id method on the passed in objects. The order in which you pass the objects is the same order in which it appears in the URI pattern.

\newpage

### Step 4 ###

There are other URI patterns which are similar to the comments controller destroy action. So we need to do the same thing we did for articles resource. So the link_to now becomes:

```ruby
<%= link_to 'Delete Comment', 
						article_comment(article, comment), 
						method: :delete %>
```

### Step 5 ###

The 'Delete Comment' is a destructive operation so let's add the confirmation popup to the link_to helper.

```ruby
<%= link_to 'Delete Comment', 
						 article_comment(article, comment), 
						 method: :delete,
						 data: { confirm: 'Are you sure?' } %>									 	 					 
```

The app/views/articles/show.html.erb now looks as follows:

```ruby
<p>
  <%= @article.title %><br>
</p>

<p>
  <%= @article.description %><br>
</p>

<h2>Comments</h2>
<% @article.comments.each do |comment| %>
  <p>
    <strong>Commenter:</strong>
    <%= comment.commenter %>
  </p>
 
  <p>
    <strong>Comment:</strong>
    <%= comment.description %>
  </p>
	
	<%= link_to 'Delete Comment', 
							 article_comment_path(article, comment), 
							 method: :delete,
							 data: { confirm: 'Are you sure?' } %>	
	
<% end %>

<h2>Add a comment:</h2>
<%= form_for([@article, @article.comments.build]) do |f| %>
  <p>
    <%= f.label :commenter %><br />
    <%= f.text_field :commenter %>
  </p>
  <p>
    <%= f.label :description %><br />
    <%= f.text_area :description %>
  </p>
  <p>
    <%= f.submit %>
  </p>
<% end %>
```

\newpage

### Step 6 ###

Lets implement the destroy action in the comments controller as follows:

```ruby
def destroy
  @article = Article.find(params[:article_id])
  @comment = @article.comments.find(params[:id])
  @comment.destroy
  
  redirect_to article_path(@article)
end
```

We first find the parent record which in this case is the article. The next step scopes the find for that particular article record due to security. Then we delete the comment by calling the destroy method. Finally we redirect the user to the articles index page similar to the create action.

\newpage

### Step 7 ###

Go to the articles index page by reloading the http://localhost:3000/articles Click on the 'Show' link for any article that has comments.

![Delete Comment Links](./figures/delete_comment_links.png)

You will see the 'Delete Comment' link for every comment of the article.

\newpage

![URL Error](./figures/url_error.png)

You will get the url error page if you forget to append the _path or _url to the article_comment Prefix.

\newpage

![Article Instance Variable Error](./figures/article_instance_error.png)

If you forget to use the instance variable @article, then you will get the above error message.

### Step 8 ###

Click the 'Delete Comment' link in the articles show page. The confirmation popup will appear and if you click 'Ok' the record will be deleted from the database and you will be redirected back to the articles show page.

\newpage

## Exercise 1 ##

Change the destroy action redirect_to method to use notice that says 'Comment deleted'. If you are using MySQLite Manager you can click on the 'Refresh' icon which is the first icon in the top navigation bar to see the comments gets deleted.

![Refresh Icon](./figures/refresh_icon.png)

\newpage

### Exercise 2 ###

Go to articles index page and delete an article that has comments. Now go to either rails dbconsole or use MySQLite Manager to see if the comments associated with that articles is still in the database.

### Step 9 ###

When you delete the parent the children do not get deleted automatically. The comment records in our application become useless because they are specific to a given article. In order to delete them when the parent gets deleted we need to change the Article ActiveRecord like this :

```ruby
class Article < ActiveRecord::Base
  has_many :comments, dependent: :destroy
end
```

Now if you delete the parent that has comments, all the comments associated with it will also be deleted. So you will not waste space in the database by retaining records that are no longer needed.

### Exercise 3 ###

Change the second parameter, url helper to :

```ruby
[@article, comment]
```

The delete functionality will still work. Since Rails allows passing the parent and child instances in an array instead of using the Prefix.

## Summary ##

In this lesson we learned about nested routes and how to deal with deleting records which has children. Right now anyone is able to delete records, in the next lesson we will restrict the delete functionality only to blog owner.

\newpage
