CHAPTER 10
=============
Relationships 
------------------------------


## Objective ##

- To learn relationships between models.

## Steps ##

### Step 1 ###

Let's create a comment model by using the Rails generator command:

![Generate Comment Model](./figures/comment_model)

$ rails g model comment commenter:string description:text article:references

### Step 2 ### 

Open the db/migrate/xyz_create_comments.rb file in your IDE. You will see the create_table() method that takes comments symbol :comments as the argument and the description of the columns for the comments table. 

What does references do? It creates the foreign key article_id in the comments table. We also create an index for this foreign key in order to make the SQL joins faster.

\newpage

### Step 3 ###

Run :

```ruby
$ rake db:migrate
```

![Create Comments Table](./figures/db_migrate_comments)

Let's install SQLiteManager Firefox plugin that we can use to open the SQLite database, query, view table structure etc.

### Step 4 ###

Install SqliteManager Firefox plugin [SqliteManager Firefox plugin](https://addons.mozilla.org/en-US/firefox/addon/sqlite-manager/ "SqliteManager Firefox plugin")

\newpage

### Step 5 ###

Let's now see the structure of the comments table. In Firefox go to : 
Tools --> SQLiteManager

![SQLite Manager Firefox Plugin](./figures/SQLiteManager)

\newpage

### Step 6 ###

Click on 'Database' in the navigation and select 'Connect Database', browse to blog/db folder.

![Folder Icon](./figures/open_folder_icon.png)

You can also click on the folder icon as shown in the screenshot.

### Step 7 ###

Change the file extensions to all files.

![SQLite Manager All Files](./figures/format_all_files)

\newpage

### Step 8 ###

Open the development.sqlite3 file. Select the comments table.

![Comments Table Structure](./figures/comments_structure)

You can see the foreign key article_id in the comments table. 

\newpage

### Step 9 ###

Open the app/models/comment.rb file. You will see the 

```ruby
belongs_to :article
```

declaration. This means you have a foreign key article_id in the comments table.

The belongs_to declaration in the model will not create or manipulate database tables. The belongs_to or references in the migration will manipulate the database tables. Since your models are not aware of the database relationships, you need to declare them.

![Belongs To Declaration](./figures/belongs_to.png)


### Step 10 ###

Open the app/models/article.rb file. Add the following declaration:

```ruby
has_many :comments
```

This means each article can have many comments. Each comment points to it's corresponding article. 

![Has Many Declaration](./figures/has_many.png)

### Step 11 ###

Open the config/routes.rb and define the route for comments:

```ruby
resources :articles do
  resources :comments
end
```

Since we have parent-children relationship between articles and comments we have nested routes for comments.

\newpage

### Step 12 ###

Let's create the controller for comments.

```ruby
$ rails g controller comments
```

![Generate Comments Controller](./figures/comments_controller)

Readers can comment on any article. When someone comments we will display the comments for that article on the article's show page.

\newpage

### Step 13 ###

Let's modify the app/views/articles/show.html.erb to let us make a new comment:

```ruby
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

The app/views/show.html.erb file will now look like this:

```ruby
<p>
  <%= @article.title %><br>
</p>

<p>
  <%= @article.description %><br>
</p>


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

### Step 14 ###

Go to http://localhost:3000/articles page and click on 'Show' for one of the article.

![Add Comment Form](./figures/add_comment_form)

You will now see the form for filling out the comment for this specific article.

\newpage

### Step 15 ###

View the page source for the article show page by clicking any of the 'Show' link in the articles index page.

![Add Comment Page Source](./figures/add_comment_source)

You can see the URI pattern and the http method used when someone submits a comment by clicking the 'Create Comment' button.

\newpage

## Exercise 1 ##

Take a look at the output of rake routes and find out the resource endpoint for the URI pattern and http method combination found in step 12.

### Step 16 ###

Run rake routes in the blog directory.

![Comments Resource Endpoint](./figures/resource_endpoint_comments.png)

You can see how the rails router takes the comment submit form to the comments controller, create action.

### Step 17 ###

Fill out the comment form and click on 'Create Comment'. You will get a unknown action create error page.

\newpage

### Step 18 ###

Define the create method in comments_controller.rb as follows:

```ruby
def create

end
```

### Step 19 ###

Fill out the comment form and submit it again.

![Comment Values in Server Log](./figures/comments_values_in_log)

You can see the comment values in the server log.

\newpage

### Step 20 ###

Copy the entire Parameters hash you see from the server log. Go to Rails console and paste it like this:

```ruby
params =  {"comment"=>{"commenter"=>"test", "description"=>"tester"}, 
"commit"=>"Create Comment", "article_id"=>"5"}
```

![Parameters for Comment](./figures/params_comments)

Here you initialize the params variable with the hash you copied in the rails server log.

![Retrieving Comment](./figures/retrieving_comment)

You can find the value for comment model by doing: params['comment'] in the Rails console

\newpage

### Step 21 ###

Let's create a comment for a given article by changine the create action as follows:

```ruby
def create
  @article = Article.find(params[:article_id])
  permitted_columns = params[:comment].permit(:commenter, :description)
  @comment = @article.comments.create(permitted_columns)
  
  redirect_to article_path(@article)
end
```

The only new thing in the above code is the 

```ruby
@article.comments.create
```

Since we have the declaration

```ruby
has_many :comments
```

in the article model. We can navigate from an instance of article to a collection of comments:

```ruby
@article.comments
```

We call the method create on the comments collection like this:

```ruby
@article.comments.create
```

This will automatically populate the foreign key article_id in the comments table for us.

The params[:comment] will retreive the comment column values.

\newpage

### Step 22 ###

Fill out the comment form and submit it.

![Comment Record in Database](./figures/comments_in_db)

You can now view the record in the MySQLite Manager or Rails dbconsole. Let's now display the comments made for a article in the articles show page.

\newpage

### Step 23 ###

Add the following code to the app/views/articles/show.html.erb

```ruby
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
<% end %>
```

\newpage

Your app/views/articles/show.html.erb will now look like this:

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

### Step 24 ###

Reload the article show page or click on the 'Show' link for the article with comments by going to the articles index page.

![Comments For an Article](./figures/comments_for_article)

You will now see the existing comments for an article.

\newpage

## Summary ##

We saw how to create parent-child relationship in the database and how to use ActiveRecord declarations in models to handle one to many relationship. We learned about nested routes and how to make forms work in the parent-child relationship. In the next lesson we will implement the feature to delete comments to keep our blog clean from spam.

\newpage
