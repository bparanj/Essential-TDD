CHAPTER 11
=============
Delete Comment
------------------------------

## Objective ##

- Learn how to work with nested resources

## Steps ##

### Step 1 ###

Let's add 'Delete' link for the comment in app/views/articles/show.html.erb. We know the hyperlink text will be 'Delete Comment', so:

```ruby
<%= link_to 'Delete Comment', ? %>
```

What should be URL helper to use in the second parameter?

\newpage

### Step 2 ###

From the blog directory run:

```ruby
$ rails routes | grep comments
```

```sh
         Prefix 	 Verb   URI Pattern               						  Endpoint	
    article_comments GET    /articles/:article_id/comments(.:format)          comments#index
                     POST   /articles/:article_id/comments(.:format)          comments#create
 new_article_comment GET    /articles/:article_id/comments/new(.:format)      comments#new
edit_article_comment GET    /articles/:article_id/comments/:id/edit(.:format) comments#edit
     article_comment GET    /articles/:article_id/comments/:id(.:format)      comments#show
                     PATCH  /articles/:article_id/comments/:id(.:format)      comments#update
                     PUT    /articles/:article_id/comments/:id(.:format)      comments#update
                     DELETE /articles/:article_id/comments/:id(.:format)      comments#destroy
```

![Filtered Routes](./figures/filtered_routes.png)

We are filtering the routes only to the nested routes for comments so that it is easier to read the output in the terminal.

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
						article_comment_path(article, comment), 
						method: :delete %>
```

### Step 5 ###

The 'Delete Comment' is a destructive operation so let's add the confirmation popup to the link_to helper.

```ruby
<%= link_to 'Delete Comment', 
						 article_comment_path(article, comment), 
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
			  article_comment_path(@article, comment), 
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

Lets implement the destroy action in the comments_controller.rb as follows:

```ruby
def destroy
  @article = Article.find(params[:article_id])
  @comment = @article.comments.find(params[:id])
  @comment.destroy
  
  redirect_to article_path(@article)
end
```

We first find the parent record which in this case is the article. The next step scopes the find for that particular article record due to security. Because we don't want to delete comments that belongs to some other article. Then we delete the comment by calling the destroy method. Finally we redirect the user to the articles index page similar to the create action.

\newpage

### Step 7 ###

Go to the articles index page by reloading the http://localhost:3000/articles Click on the 'Show' link for any article that has comments.

![Delete Comment Links](./figures/delete_comment_links.png)

You will see the 'Delete Comment' link for every comment of the article.

\newpage

![URL Error](./figures/url_error.png)

You will get:

```sh
undefined method `article_comment' Did you mean?  article_comment_url
```

if you forget to append the _path or _url to the article_comment Prefix.

\newpage

![Article Instance Variable Error](./figures/article_instance_error.png)

```sh
NameError : undefined local variable or method `article' for #<#<Class:0x007fe>
```

If you forget to use the instance variable @article, then you will get the error message.

```sh
undefined local variable or method `article' for Class:0x007ff
Did you mean?  @article
```

### Step 8 ###

Click the 'Delete Comment' link in the articles show page. The confirmation popup will appear and if you click 'Ok' the record will be deleted from the database and you will be redirected back to the articles show page.

```sh
Started DELETE "/articles/4/comments/1" for ::1 at 2016-07-17 15:28:28 -0700
Processing by CommentsController#destroy as HTML
  Parameters: {"authenticity_token"=>"+y4bt1gGyeZK38xZ", "article_id"=>"4", "id"=>"1"}
  Article Load (0.1ms)  SELECT  "articles".* FROM "articles" WHERE "articles"."id" = ? LIMIT ?  [["id", 4], ["LIMIT", 1]]
  Comment Load (0.2ms)  SELECT  "comments".* FROM "comments" WHERE "comments"."article_id" = ? AND "comments"."id" = ? LIMIT ?  [["article_id", 4], ["id", 1], ["LIMIT", 1]]
   (0.1ms)  begin transaction
  SQL (0.3ms)  DELETE FROM "comments" WHERE "comments"."id" = ?  [["id", 1]]
   (48.3ms)  commit transaction
Redirected to http://localhost:3000/articles/4
Completed 302 Found in 54ms (ActiveRecord: 49.1ms)
```

\newpage

## Exercise 1 ##

Change the destroy action redirect_to method to use notice that says 'Comment deleted'. If you are using MySQLite Manager you can click on the 'Refresh' icon which is the first icon in the top navigation bar to see the comments gets deleted.

![Refresh Icon](./figures/refresh_icon.png)

Refresh icon of Firefox Plugin MySQLite Manager.

## Exercise 2 ##

Go to articles index page and delete an article that has comments. Now go to either rails dbconsole or use MySQLite Manager to see if the comments associated with that articles is still in the database.

### Step 9 ###

When you delete the parent the children do not get deleted automatically. The comment records in our application become useless because they are specific to a given article. In order to delete them when the parent gets deleted we need to change the Article ActiveRecord sub-class like this :

```ruby
class Article < ActiveRecord::Base
  has_many :comments, dependent: :destroy
end
```

Now if you delete the parent that has comments, all the comments associated with it will also be deleted. So you will not waste space in the database by retaining records that are no longer needed.

\newpage

### Step 10 ###

Let's experiment with polymorphic_url method in rails console.

```ruby
a = Loading development environment (Rails 5.0.0)
>> a = Article.first
  Article Load (0.2ms)  SELECT  "articles".* FROM "articles" ORDER BY "articles"."id" ASC LIMIT ?  [["LIMIT", 1]]
=> #<Article id: 5, title: "Basics of Abstraction", description: "The must know concepts for every developer.", created_at: "2016-07-17 22:32:16", updated_at: "2016-07-17 22:32:16">
>> c = a.comments.first
  Comment Load (0.2ms)  SELECT  "comments".* FROM "comments" WHERE "comments"."article_id" = ? ORDER BY "comments"."id" ASC LIMIT ?  [["article_id", 5], ["LIMIT", 1]]
=> #<Comment id: 5, commenter: "bugs", description: "I agree.", article_id: 5, created_at: "2016-07-17 22:32:29", updated_at: "2016-07-17 22:32:29">
>> app.polymorphic_url(a, c)
ArgumentError: wrong number of arguments (given 1, expected 0)
```

![Polymorphic Path Method Error](./figures/nested_routes_polymorphic_path_error.png)

The polymorphic_path method will throw an error when two arguments are passed. 

![Polymorphic Path Method](./figures/nested_routes_polymorphic_path.png)

Rails internally uses polymorphic_path method with an array containing the parent and child objects to generate the url helper.

```ruby
>> app.polymorphic_url([a, c])
=> "http://www.example.com/articles/5/comments/5"
>> app.polymorphic_path([a, c])
=> "/articles/5/comments/5"
``` 

Change the second parameter, url helper in the view to :

```ruby
[@article, comment]
```

The link_to will now look like this:

```ruby
<%= link_to 'Delete Comment', 
						 [@article, comment], 
						 method: :delete,
						 data: { confirm: 'Are you sure?' } %>	
```

The delete functionality will still work. Since Rails allows passing the parent and child instances in an array instead of using the Prefix, article_comment_path.

```ruby
a = Article.first
c = a.comments.first
app.polymorphic_url([a, c])
 => "http://www.example.com/articles/4/comments/4" 
```

You can learn more about the polymorphic_url by reading the Rails source code. Go to Rails console to find out where it is implemented.

```ruby
 > app.respond_to?(:polymorphic_url)
 => true 
 > app.method(:polymorphic_url).source_location
 => ["/Users/zepho/.rvm/gems/ruby-2.3.1@r5.0/gems/actionpack-5.0.0/lib/action_dispatch/routing/polymorphic_routes.rb", 99]
 ```

Open the polymorphic_routes.rb and look at line 99 in your editor:

```ruby
 module PolymorphicRoutes
   # Constructs a call to a named RESTful route for the given record and returns the
   # resulting URL string. For example:
   #
   #   # calls post_url(post)
   #   polymorphic_url(post) # => "http://example.com/posts/1"
   #   polymorphic_url([blog, post]) # => "http://example.com/blogs/1/posts/1"
   #   polymorphic_url([:admin, blog, post]) # => "http://example.com/admin/blogs/1/posts/1"
   #   polymorphic_url([user, :blog, post]) # => "http://example.com/users/1/blog/posts/1"
   #   polymorphic_url(Comment) # => "http://example.com/comments"
   #
   # ==== Options
   #
   # * <tt>:action</tt> - Specifies the action prefix for the named route:
   #   <tt>:new</tt> or <tt>:edit</tt>. Default is no prefix.
   # * <tt>:routing_type</tt> - Allowed values are <tt>:path</tt> or <tt>:url</tt>.
   #   Default is <tt>:url</tt>.
   #
   # Also includes all the options from <tt>url_for</tt>. These include such
   # things as <tt>:anchor</tt> or <tt>:trailing_slash</tt>. Example usage
   # is given below:
   #
   #   polymorphic_url([blog, post], anchor: 'my_anchor')
   #     # => "http://example.com/blogs/1/posts/1#my_anchor"
   #   polymorphic_url([blog, post], anchor: 'my_anchor', script_name: "/my_app")
   #     # => "http://example.com/my_app/blogs/1/posts/1#my_anchor"
   #
   # For all of these options, see the documentation for <tt>url_for</tt>.
   #
   # ==== Functionality
   #
   #   # an Article record
   #   polymorphic_url(record)  # same as article_url(record)
   #
   #   # a Comment record
   #   polymorphic_url(record)  # same as comment_url(record)
   #
   #   # it recognizes new records and maps to the collection
   #   record = Comment.new
   #   polymorphic_url(record)  # same as comments_url()
   #
   #   # the class of a record will also map to the collection
   #   polymorphic_url(Comment) # same as comments_url()
   #
   def polymorphic_url(record_or_hash_or_array, options = {})
     if Hash === record_or_hash_or_array
       options = record_or_hash_or_array.merge(options)
       record  = options.delete :id
       return polymorphic_url record, options
     end

     opts   = options.dup
     action = opts.delete :action
     type   = opts.delete(:routing_type) || :url

     HelperMethodBuilder.polymorphic_method self,
                                            record_or_hash_or_array,
                                            action,
                                            type,
                                            opts
   end
 ```
  
## Summary ##

In this lesson we learned about nested routes and how to deal with deleting records with children. The current implementation allows anyone to delete records. In the next lesson we will restrict the delete functionality to blog owner.

\newpage
