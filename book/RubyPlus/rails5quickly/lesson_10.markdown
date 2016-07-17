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

```ruby
rails g model comment commenter:string description:text article:references
```

You will see the output:

```sh
invoke  active_record
create    db/migrate/20160717220101_create_comments.rb
create    app/models/comment.rb
invoke    test_unit
create      test/models/comment_test.rb
create      test/fixtures/comments.yml
```

### Step 2 ### 

Open the db/migrate/xyz_create_comments.rb file in your IDE. You will see the create_table() method within change() method that takes comments symbol :comments as the argument and the description of the columns for the comments table. 

What does references do? It creates the foreign key article_id in the comments table. We also create an index for this foreign key in order to make the SQL joins faster.

\newpage

### Step 3 ###

Run :

```ruby
$ rails db:migrate
```

![Create Comments Table](./figures/db_migrate_comments)

```sh
== 20160717220101 CreateComments: migrating =============
-- create_table(:comments)
   -> 0.0196s
== 20160717220101 CreateComments: migrated (0.0197s) ====
```

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

You can also use the rails db command to view the tables, schema and work with database from the command line.

```sh
$ rails db
SQLite version 3.7.7 2011-06-25 16:35:41
Enter ".help" for instructions
Enter SQL statements terminated with a ";"
```

To get help:

```sh
sqlite> .help
```

To list all the databases:

```sh
sqlite> .databases
seq  name             file                                                      
---  ---------------  ----------------------------------------------------------
0    main             /Users/zepho/projects/blog/db/development.sqlite3           
```

To list all the tables:

```sh
sqlite> .tables
ar_internal_metadata  comments            
articles              schema_migrations  
```

To list the schema for comments table:

```sh
sqlite> .schema comments
REATE TABLE "comments" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "commenter" varchar, "description" text, "article_id" integer, "created_at" datetime NOT NULL, "updated_at" datetime NOT NULL);
CREATE INDEX "index_comments_on_article_id" ON "comments" ("article_id");
```

### Step 9 ###

Open the app/models/comment.rb file. You will see the 

```ruby
belongs_to :article
```

declaration. This means you have a foreign key article_id in the comments table.

The belongs_to declaration in the model will not create database tables. Since your models are not aware of the database relationships, you need to declare them.

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

You will see the output:

```
create  app/controllers/comments_controller.rb
invoke  erb
create    app/views/comments
invoke  test_unit
create    test/controllers/comments_controller_test.rb
invoke  helper
create    app/helpers/comments_helper.rb
invoke    test_unit
invoke  assets
invoke    coffee
create      app/assets/javascripts/comments.coffee
invoke    scss
create      app/assets/stylesheets/comments.scss
```

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

```html
<form class="new_comment" id="new_comment" action="/articles/5/comments" accept-charset="UTF-8" method="post">
```

\newpage

## Exercise 1 ##

Take a look at the output of `rails routes` command and find out the resource endpoint for the URI pattern /articles/5/comments and http method POST combination found in step 15.

### Step 16 ###

Run rails routes in the blog directory.

![Comments Resource Endpoint](./figures/resource_endpoint_comments.png)

You can see how the rails router takes the comment submit form to the comments controller, create action.

```sh
POST   /articles/:article_id/comments(.:format)          comments#create
```

### Step 17 ###

Fill out the comment form and click on 'Create Comment'. You will see a unknown action create for Comments controller error page.

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

```ruby
Started POST "/articles/4/comments" for ::1 at 2016-07-17 15:10:36 -0700
Processing by CommentsController#create as HTML
  Parameters: {"utf8"=>"✓", "authenticity_token"=>"2Gp+UXhpHx", "comment"=>{"commenter"=>"bugs", "description"=>"dafasdfsa"}, "commit"=>"Create Comment", "article_id"=>"4"}
No template found for CommentsController#create, rendering head :no_content
Completed 204 No Content in 48ms (ActiveRecord: 0.0ms)
```

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

You can find the value for comment model by doing: params['comment'] in the Rails console.

```ruby
{"commenter"=>"test", "description"=>"tester"} 
```

You can extract the article_id from the parameters like this:

```ruby
> params['article_id']
```

\newpage

### Step 21 ###

Let's create a comment for a given article by changing the create action as follows:

```ruby
def create
  @article = Article.find(params[:article_id])
  permitted_columns = params[:comment].permit(:commenter, :description)
  @comment = @article.comments.create(permitted_columns)
  
  redirect_to article_path(@article)
end
```

The only new thing in the above code is this:

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

The params[:comment] will retrieve the comment column values.

\newpage

### Step 22 ###

Fill out the comment form and submit it.

![Comment Record in Database](./figures/comments_in_db)

```ruby
Started POST "/articles/4/comments" for ::1 at 2016-07-17 15:13:37 -0700
Processing by CommentsController#create as HTML
  Parameters: {"utf8"=>"✓", "authenticity_token"=>"oozS3q4nkxrXCxBZraMyr64B2ohB5E2QVai5N4SQByZpZnUSMhT/RoJr+mW+wcdhRy7CFjCYfADG7loSpR07CA==", "comment"=>{"commenter"=>"bugs", "description"=>"test"}, "commit"=>"Create Comment", "article_id"=>"4"}
  Article Load (0.1ms)  SELECT  "articles".* FROM "articles" WHERE "articles"."id" = ? LIMIT ?  [["id", 4], ["LIMIT", 1]]
   (0.1ms)  begin transaction
  SQL (0.4ms)  INSERT INTO "comments" ("commenter", "description", "article_id", "created_at", "updated_at") VALUES (?, ?, ?, ?, ?)  [["commenter", "bugs"], ["description", "test"], ["article_id", 4], ["created_at", 2016-07-17 22:13:37 UTC], ["updated_at", 2016-07-17 22:13:37 UTC]]
   (54.3ms)  commit transaction
Redirected to http://localhost:3000/articles/4
Completed 302 Found in 61ms (ActiveRecord: 54.9ms)
```

You can now view the record in the MySQLite Manager or Rails db console. Let's now display the comments made for a article in the articles show page.

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
