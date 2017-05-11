CHAPTER 5
=============
View to Model
------------------------------


## Objective ##

 - Learn how to get data from the user and save it in the database
 
## Steps ##

### Step 1 ###

We need to display a form for the user to fill out the text field for the article title and text area for the description. In order for the user to go to this form, let's create a 'New Article' link to load an empty form in the articles index page.

Add the following code to the bottom of the app/views/articles/index.html file:

```ruby
<%= link_to 'New Article', ? %>
```

\newpage

### Step 2 ###

What is the url helper we should use? We know we need to display the articles/new.html.erb page. We also know that the action that is executed is 'new' before new.html.erb is displayed. Take a look at the rails routes output:

![New Article URL Helper](./figures/new_article.png)

The first column named Prefix gives us the URL helper we can use. We can either append 'url' or 'path' to the prefix. Let's fill in the url helper to load the new page as follows:

```ruby
<%= link_to 'New Article', new_article_path %>
```

\newpage

### Step 3 ###

Reload the page http://localhost:3000/articles in the browser. 

![New Article Link](./figures/new_article_link.png)

The hyperlink for creating a new article will now be displayed.

\newpage

### Step 4 ###

Right click on the browser and click 'View Page Source'. 

![View Page Source](./figures/view_page_source.png)

You will see 'New Article' link pointing to the resource "/articles/new".

```html
<a href="/articles/new">New Article</a>
```

\newpage

### Step 5 ###

Click the 'New Article' link. Go to the terminal and look at the server output.

![HTTP Verb Get](./figures/get_articles_new.png)

```sh
Started GET "/articles/new" for ::1 at 2016-07-05 16:33:59 -0700
  
AbstractController::ActionNotFound (The action 'new' could not be found for ArticlesController):
```

You can see that the browser made a http GET request for the resource "/articles/new". 

![Action New Not Found](./figures/unknown_action_new.png)

You will see the unknown action error page.

\newpage

### Step 6 ###

Let's create the new action in articles controller. Add the following code to articles controller:

```ruby
def new
  
end
```

### Step 7 ###

Go back to http://localhost:3000/articles page. Click on the 'New Article' link, in the log, you will see:

```sh
Started GET "/articles/new" for ::1 at 2016-07-05 16:34:54 -0700
Processing by ArticlesController#new as HTML
Completed 406 Not Acceptable in 55ms (ActiveRecord: 0.0ms)
  
ActionController::UnknownFormat (ArticlesController#new is missing a template for this request format and variant.

request.formats: ["text/html"]
request.variant: []
```

After the new action is executed Rails looks for view whose name is the same as the action, in this case app/views/articles/new.html.erb. Since this view is missing we don't see the page with the form to fill out the article fields.

\newpage

### Step 8 ###

So lets create new.html.erb under app/views/articles directory with the following content:

```ruby
<%= form_for @article do |f| %>
  <p>
    <%= f.label :title %><br>
    <%= f.text_field :title %>
  </p>
 
  <p>
    <%= f.label :description %><br>
    <%= f.text_area :description %>
  </p>
 
  <p>
    <%= f.submit %>
  </p>
<% end %>
```

\newpage

### Step 9 ###

Click on the 'New Article' link on the 'Listing Articles' page.

![Argument Error](./figures/argument_error.png)

```sh
ActionView::Template::Error (First argument in form cannot contain nil or be empty):
    1: <%= form_for @article do |f| %>
    2:   <p>
    3:     <%= f.label :title %><br>
    4:     <%= f.text_field :title %>
```
  
You will now see the above error.

### Step 10 ###

Change the new method in articles controller as follows:

```ruby
def new
  @article = Article.new
end
```

Here we are instantiating an instance of Article class, this gives Rails a clue that the form fields is for Article model.

\newpage

### Step 11 ###

Reload the browser http://localhost:3000/articles/new page. 

![New Article Form](./figures/new_article_form.png)

You will now see an empty form to create a new article.

\newpage

### Step 12 ###

Right click and select 'View Page Source' on the new article form page. 

![New Article Page Source](./figures/new_article_page_source.png)

```html
<form class="new_article" id="new_article" action="/articles" accept-charset="UTF-8" method="post">
```

As you can see, form will be submitted to the url '/articles' and the http verb used is POST. When the user submits the form, which controller and which action will be executed?

\newpage

### Step 13 ###

Look at the output of rails routes, the combination of the http verb and the URL uniquely identifies the resource end point.

![Identifying Resource Endpoint](./figures/creating_new_article.jpg)

```sh
POST   /articles(.:format)          articles#create
```

In this case we see that it maps to the articles controller and create action.

\newpage

### Step 14 ###

Fill out the form and click 'Create Article'. Check the server log output.

![Post Article Server Log](./figures/post_articles.png)

```sh
Started POST "/articles" for ::1 at 2016-07-05 16:40:29 -0700
  
AbstractController::ActionNotFound (The action 'create' could not be found for ArticlesController):  
```

You can see that the browser made a POST to the URL '/articles'.

![Unknown Action Create](./figures/unknown_action_create.png)

This error is due to absence of the create action in the articles controller.

\newpage

### Step 15 ###

Define the create method in the articles controller as follows:

```ruby
def create
  
end
```

### Step 16 ###

Fill out the form and click 'Create Article'.

![Article Form Values](./figures/article_form_values.png)

You can see that the form values submitted by the user is sent to the server. Rails automatically populates a hash called params which contains a key whose name is the article symbol and the values are the different database columns and its values.

```sh
Started POST "/articles" for ::1 at 2016-07-05 16:41:31 -0700
Processing by ArticlesController#create as HTML
  Parameters: {"utf8"=>"✓", "authenticity_token"=>"1ILXAjse7lVYATqub/WzUrPwdOVF4pTHnjO/QI/ReI8faHDOpy2CCQ1h0JJ8l0acWt9sezSepVcNdVxlrlxEoQ==", "article"=>{"title"=>"sadfasd", "description"=>"adfasdf"}, "commit"=>"Create Article"}
No template found for ArticlesController#create, rendering head :no_content
Completed 204 No Content in 56ms (ActiveRecord: 0.0ms)
```

You will see `No template found` in the log file.

### Step 17 ###

Before we fix the missing template issue, we need to save the data submitted by the user in the database. You already know how to use the ActiveRecord class method 'create' to save a record. You also know that Rails populates the params hash, this hash is made available to you in the controller. So we can access it like this :

```ruby
def create
  Article.create(params[:article])
end
```

In Figure 50, you see that the hash key article is a string, but I am using the symbol :article in the create method. How does this work? 

![HashWithIndifferentAccess](./figures/hash_with_indifferent_access.png)

As you can see from the rails console, params hash is not a regular Ruby hash, it is a special hash called HashWithIndifferentAccess. It allows you to set the value of the hash with either a symbol or string and retreive the value using either string or symbol.

\newpage

### Step 18 ###

Fill out the form and submit again. 

![Forbidden Attributes Error](./figures/forbidden_attributes_error.png)

Now we get a ActiveModel::ForbiddenAttributesError error.

### Step 19 ###

Due to security reasons we need to specify which fields must be permitted as part of the form submission. Modify the create method as follows:

```ruby
def create
  Article.create(params.require(:article).permit(:title, :description))
end
```

\newpage

### Step 20 ###

Fill out the form and submit again. You will get the no template error but you will now see that the user submitted data is saved in the database.

```sh
Started POST "/articles" for ::1 at 2016-07-05 16:44:10 -0700
Processing by ArticlesController#create as HTML
  Parameters: {"utf8"=>"✓", "authenticity_token"=>"b1XvtCYVw5P0GYFO28LA==", "article"=>{"title"=>"Basics of Abstraction", "description"=>"testing"}, "commit"=>"Create Article"}
   (0.1ms)  begin transaction
  SQL (0.5ms)  INSERT INTO "articles" ("title", "description", "created_at", "updated_at") VALUES (?, ?, ?, ?)  [["title", "Basics of Abstraction"], ["description", "testing"], ["created_at", 2016-07-05 23:44:10 UTC], ["updated_at", 2016-07-05 23:44:10 UTC]]
   (48.8ms)  commit transaction
No template found for ArticlesController#create, rendering head :no_content
Completed 204 No Content in 122ms (ActiveRecord: 50.3ms)
```

![Save User Data](./figures/last_article.png)

Let's go to the rails console and check the record that we just created.

```ruby
$ rails c
Loading development environment (Rails 5.0.0)
>> Article.last
  Article Load (0.2ms)  SELECT  "articles".* FROM "articles" ORDER BY "articles"."id" DESC LIMIT ?  [["LIMIT", 1]]
=> #<Article id: 3, title: "Basics of Abstraction", description: "testing", created_at: "2016-07-05 23:44:10", updated_at: "2016-07-05 23:44:10">
```

The ActiveRecord class method 'last' method retrieves the last row in the articles table. 

### Step 21 ### 

Let's now address the no template error. Once the data is saved in the database we can either display the index page or the show page for the article. Let's redirect the user to the index page. We will be able to see all the records including the new record that we created. Modify the create method as follows:

```ruby
def create
  Article.create(params.require(:article).permit(:title, :description))
  
  redirect_to articles_index_path
end
```

How do we know that we need to use articles_index_path url helper? We already saw how to find the URL helper to use in the view, we can do the same. If you see the output of rails routes command, we know the resource end point, to find the URL helper we look at the Prefix column.

\newpage

### Step 22 ###

Fill out the form and submit again. 

![Displaying All Articles](./figures/display_all_articles.png)

You will now see all the articles displayed in the index page.

\newpage

![Redirect to Articles Index Page](./figures/redirecting_to_articles_index.png)

Redirecting user to the articles index page.

## Exercise

Open the routes.rb file and delete the line:

```ruby
get 'articles/index'
```  
  
Change the helper name for redirect_to method in create action by looking at the 

```ruby
rails routes 
```

output.

## Summary ##

We saw how we can save the user submitted data in the database. We went from the View to the Controller to the Model. We also saw how the controller decides which view to render next. We learned about the http verb and identifying resource endpoint in our application. Now we know how the new and create action works. In the next lesson we will see how edit and update action works to make changes to an existing record in the database.

\newpage
