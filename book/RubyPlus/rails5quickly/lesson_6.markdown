CHAPTER 6
=============
Update Article
------------------------------


## Objective ##

- Learn how to update an existing record in the database

## Steps ##

### Step 1 ###

Let's add 'Edit' link to each record that is displayed in the index page. Open the app/views/articles/index.html.erb and add the edit link:

```ruby
<%= link_to 'Edit', ? %>
```

What should be the url helper to use in the second parameter to the link_to method? 

\newpage

### Step 2

We know that when someone clicks the 'Edit' link we need to load a form for that particular row with the existing values for that record. So we know the resource endpoint is articles#edit, if you look at the rails routes output, the Prefix column gives us the url helper to use. 

![Edit Article URL Helper](./figures/edit_article_route.png)

So we now have:

```ruby
<%= link_to 'Edit', edit_article_path() %>
```

\newpage

### Step 3 ###

Go to Rails console and type:

app.edit_article_path

```ruby
$rails c
Loading development environment (Rails 5.0.0.beta1)
 > app.edit_article_path
ActionController::UrlGenerationError: No route matches {:action=>"edit", :controller=>"articles"} missing required keys: [:id]
```

![Edit Article URL Helper Error](./figures/edit_article_path_error.png)

Rails does not recognize edit_article_path helper method.

\newpage

### Step 4 ###

Examine the output of rake routes command. In the URI Pattern column you see the pattern for edit as : /articles/:id/edit

URI Pattern can consist of symbols which represent variable. You can think of it as a place holder. The symbol :id in this case represents the primary key of the record we want to update. So we pass an instance of an article to url helper. We could call the id method on article, since Rails automatically calls id on this instance, we will just let Rails do its magic. Modify the link_to method as follows:

```ruby
<%= link_to 'Edit', edit_article_path(article) %>
```

![Edit Article URL Helper](./figures/edit_article_path.png)

Rails recognizes edit_article_path when the primary key :id value is passed in as the argument.

\newpage

### Step 5 ###

The app/views/articles/index.html.erb will look like this :

```ruby
<h1>Listing Articles</h1>

<% @articles.each do |article| %>

	<%= article.title %> : 

	<%= article.description %> 
	
	<%= link_to 'Edit', edit_article_path(article) %>
	
	<br/>

<% end %>
<br/>
<%= link_to 'New Article', new_article_path %>
```

\newpage

### Step 6 ###

Reload the http://localhost:3000/articles page. 

![Edit Article Link](./figures/edit_article_link.png)

You will now see the 'Edit' link for each article in the database.

\newpage

### Step 7 ###

Right click on the browser and select 'View Page Source'. 

![Edit Article Page Source](./figures/edit_article_link_source.png)

You will see the primary keys of the corresponding row for the :id variable.

```html
<body>
  <h1>Listing Articles</h1>

  test 
  first row
  <a href="/articles/1/edit">Edit</a>
  
<br/>

  record two 
  second row
  <a href="/articles/2/edit">Edit</a>
  
<a href="/articles/new">New Article</a>

</body>
```

\newpage

### Step 8 ###

Click on the 'Edit' link. 

![Unknown Action Edit](./figures/unknown_action_edit.png)

You will see `The action 'edit' could not be found for ArticlesController` error page.

### Step 9 ###

Let's define the edit action in the articles controller :

```ruby
def edit
  
end
```

\newpage

### Step 10 ###

Click on the 'Edit' link. You now get the following error in the rails server log. 

```sh
Started GET "/articles/1/edit" for ::1 at 2016-07-05 17:33:25 -0700
Processing by ArticlesController#edit as HTML
  Parameters: {"id"=>"1"}
Completed 406 Not Acceptable in 56ms (ActiveRecord: 0.0ms)

ActionController::UnknownFormat (ArticlesController#edit is missing a template for this request format and variant.

request.formats: ["text/html"]
request.variant: []
```

Let's create app/views/articles/edit.html.erb with the following contents:

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

### Step 11 ###

Click on the 'Edit' link. You now get the following error page:

![Argument Error in Articles Edit](./figures/argument_error_in_edit.png)

```ruby
ActionView::Template::Error (First argument in form cannot contain nil or be empty):
    1: <%= form_for @article do |f| %>
    2:   <p>
    3:     <%= f.label :title %><br>
    4:     <%= f.text_field :title %>

app/views/articles/edit.html.erb:1:in `_app_views_articles_edit_html_erb___29158'
```

We are getting this error because the first argument to form_for helper method cannot be nil or empty. In our case, it is nil. You can verify this by typing:

```ruby
@article
```

in the Webconsole on the browser.

\newpage

### Step 12 ###

Look at the server log:

![Edit Article Server Log](./figures/edit_article_server_log.png)

```sh
Started GET "/articles/1/edit" for ::1 at 2016-07-05 17:35:12 -0700
Processing by ArticlesController#edit as HTML
  Parameters: {"id"=>"1"}
  Rendering articles/edit.html.erb within layouts/application
  Rendered articles/edit.html.erb within layouts/application (2.4ms)
Completed 500 Internal Server Error in 8ms (ActiveRecord: 0.0ms)
```

You can see that the primary key of the selected article id and it's value.

![Params Hash Populated by Rails](./figures/populating_params_hash.png)

Rails automatically populates params hash and makes it available to the controllers. In this case, the params hash will contain id as the key and 1 as its value.

\newpage

### Step 13 ###

In the edit action we need to load the selected record from the database so that we can display it with the existing values for its columns. You already know that Rails populates params hash with the values submitted in the GET request for resource '/articles/1/edit'. We can now define the edit method as follows:

```ruby
def edit
  @article = Article.find(params[:id])
end
```

Here we find the record for the given primary key and save it in the instance variable @article. Since this variable is available in the view, we can now display the record with its existing values.

\newpage

### Step 14 ###

Click on the 'Edit' link. 

![Edit Article Form](./figures/edit_article_form.png)

You will now see the form with values populated.

\newpage

### Step 15 ###

Right click on the browser and click 'View Page Source'.

![Edit Article Source](./figures/edit_article_source.png)

```html
<form class="edit_article" id="edit_article_1" action="/articles/1" accept-charset="UTF-8" method="post">
```

We see that the URI pattern is '/articles/1' and the http verb is POST. If you look at the output of rails routes you will see that POST is used only once for create. The browser knows only GET and POST, it does not know how to use any other http verbs. 

![HTTP Verb POST](./figures/only_one_post_routes.png)

The question is how to overcome the inability of browsers to speak the entire RESTful vocabulary of using the appropriate http verb for a given operation?

The answer lies in the hidden field called _method that has the value PATCH. Rails piggybacks on the POST http verb to actually sneak in a hidden variable that tells the server it is actually a PATCH http verb. 

```html
<input type="hidden" name="_method" value="patch" />
```

If you look at the output of rails routes, for the combination of PATCH and '/articles/1' you will see that it maps to update action in the articles controller.

```sh
PATCH  /articles/:id(.:format)      articles#update
```

![HTTP Verb PATCH](./figures/patch_in_routes.png)

Rails 5 uses PATCH instead of PUT that it used in previous versions. This is because PUT is an idempotent operation.

> An idempotent HTTP method is a HTTP method that can be called many times without different outcomes. It would not matter if the method is called only once, or ten times over. The result should be the same. - The RESTful Cookbook by Joshua Thijssen

### Step 16 ##

Let's implement the update method that will take the new values provided by user for the existing record and update it in the database. Add the following update method to articles controller.

```ruby
def update
  @article = Article.find(params[:id])
  @article.update_attributes(params[:article])
end
```

Before we update the record we need to load the existing record from the database. Why? Because the instance variable in the controller will only exist for one request-response cycle. Since http is stateless we need to retrieve it again before we can update it.

### Step 17 ###

Go to articles index page by going to http://localhost:3000/articles. Click on the 'Edit' link. In the edit form, you can change the value of either the title or description and click 'Update Article' button.

### Step 18 ###

We can see in the console:

```sh
Started PATCH "/articles/1" for ::1 at 2016-07-05 17:44:22 -0700
Processing by ArticlesController#update as HTML
```

The combination of PATCH http verb and '/articles/1' routed the request to the update action of the articles controller. 

To fix the forbidden attributes error, we can do the same thing we did for create action. Change the update method as follows:

```ruby
def update
  @article = Article.find(params[:id])
  permitted_columns = params.require(:article).permit(:title, :description)
  @article.update_attributes(permitted_columns)
end
```

Change the title and click 'Update Article'. We see in the console, the template is missing but the record has been successfully updated.

```sh
SQL (0.3ms)  UPDATE "articles" SET "title" = ?, "updated_at" = ? WHERE "articles"."id" = ?  [["title", "testing update"], ["updated_at", 2016-07-06 00:46:39 UTC], ["id", 1]]
   (255.5ms)  commit transaction
No template found for ArticlesController#update, rendering head :no_content
Completed 204 No Content in 325ms (ActiveRecord: 256.9ms)
```		

### Step 19 ###

Let's address the no template found error. We don't need update.html.erb, we can redirect the user to the index page where all the records are displayed. Change the update method as follows:

```ruby
def update
  @article = Article.find(params[:id])
  permitted_columns = params.require(:article).permit(:title, :description)
  @article.update_attributes(permitted_columns)
  
  redirect_to articles_path
end
```

### Step 20 ###

Edit the article and click 'Update Article'. You should see that it now updates the article and redirects the user to the articles index page.

### Step 21 ###

An annoying thing about Rails 5 is that when you run the rails generator to create a controller with a given action it also creates an entry in the routes.rb which is not required for a RESTful route. Because we already have resources :articles declaration in the routes.rb, let's delete the following line: 

```ruby
get "articles/index"
```

in the config/routes.rb file. Now we longer have the articles_index_path helper, let's update the create method to use the articles_path as follows:

```ruby
def create
  Article.create(params.require(:article).permit(:title, :description))
  
  redirect_to articles_path
end
```

## Summary ##

In this lesson you learned how to update an existing record by displaying a form for an existing article and saving the new values in the database. In the next lesson we will see how to display a given article.

\newpage
