# 6. Update Article #

## Objective ##

- Learn how to update an existing record in the database

## Steps ##

### Step 1 ##

Let's add 'Edit' link to each record that is displayed in the index page. Open the app/views/index.html.erb and add the edit link:

```ruby
<%= link_to 'Edit', ? %>
```

What should be the url helper to use in the second parameter to the link_to method? We know that when someone clicks the 'Edit' link we need to load a form for that particular row with the existing values for that record. So we know the resource endpoint is articles#edit, if you look at the rake routes output, the Prefix column gives us the url helper to use. 

![Edit Article URL Helper](./figures/edit_article_route.png)

So we now have:

```ruby
<%= link_to 'Edit', edit_article_path() %>
```

In the URI Pattern column you see the pattern for edit as : /articles/:id/edit
URI Pattern can consist of symbols which represent variable. You can think of it as a place holder. The symbol :id in this case represents the primary key of the record we want to update. So we pass an instance of article to url helper. We could call the id method on article, since Rails automatically calls id on this instance, we will just let Rails do its magic.

```ruby
<%= link_to 'Edit', edit_article_path(article) %>
```

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

### Step 2 ###

Reload the http://localhost:3000/articles page. 

![Edit Article Link](./figures/edit_article_link)

You will now see the 'Edit' link for each article in the database.

\newpage

### Step 3 ###

Right click on the browser and select 'View Page Source'. 

![Edit Article Page Source](./figures/edit_article_link_source)

You will see the primary keys of the corresponding row for the :id variable.

\newpage

### Step 4 ###

Click on the 'Edit' link. 

![Unknown Action Edit](./figures/unknown_action_edit)

You will see unknown action edit error page.

### Step 5 ###

Let's define the edit action in the articles controller :

```ruby
def edit
  
end
```

### Step 6 ###

Click on the 'Edit' link. You now get template is missing error. Let's create app/views/articles/edit.html.erb with the following contents:

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

### Step 7 ###

Click on the 'Edit' link. You now get the following error page:

![Argument Error in Articles Edit](./figures/uninitialized_edit_form)

We have already seen similar error when we implemented the create action. 

### Step 8 ###

Look at the server log:

![Edit Article Server Log](./figures/edit_article_server_log)

You can see that the primary key of the selected article id and it's value.

### Step 9 ###

In the edit action we need to load the selected record from the database so that we can display it with the existing values for its columns. You already know that Rails populates params hash with the values submitted in the GET request for resource '/articles/1/edit'. We can now define the edit method as follows:

```ruby
def edit
  @article = Article.find(params[:id])
end
```

Here we find the record for the given primary key and save it in the instance variable @article. Since this variable is available in the view, we can now display the record with its existing values.

\newpage

### Step 10 ###

Click on the 'Edit' link. 

![Edit Article Form](./figures/edit_article_form)

You will now see the form with values populated.

\newpage

### Step 11 ###

Right click on the browser and click 'View Page Source'.

![Edit Article Source](./figures/edit_article_source.png)

We see that the URI pattern is '/articles/1' and the http verb is POST. If you look at the output of rake routes you will see that POST is used only once for create. The browser knows only GET and POST, it does not know how to use any other http verbs. 

![HTTP Verb POST](./figures/only_one_post_routes.png)

The question is how to overcome the inability of browsers to speak the entire RESTful vocabulary of using the appropriate http verb for a given operation?

The answer lies in the hidden field called method that has the value PATCH. Rails piggybacks on the POST http verb to actually sneak in a hidden variable that tells the server it is actually a PATCH http verb. If you look at the output of rake routes, for the combination of PATCH and '/articles/1' you will see that it maps to update action in the articles controller.

![HTTP Verb PATCH](./figures/patch_in_routes.png)

The output of rake routes is your friend.

### Step 12 ##

Let's implement the update method that will take the new values provided by user for the existing record and update it in the database. 

```ruby
def update
  @article = Article.find(params[:id])
  @article.update_attributes(params[:article])
end
```

Before we update the record we need to load the existing record from the database. Why? Because the instance variable in the controller will only exist for one request-response cycle. Since http is stateless we need to retrieve it again before we can update it.

### Step 13 ###

Go to articles index page. Click on the 'Edit' link. In the edit form, you can change the value of either the title or description and click 'Update Article'.

### Step 14 ###

To fix the forbidden attributes error, we can do the same thing we did for create action. Change the update method as follows:

```ruby
def update
  @article = Article.find(params[:id])
  @article.update_attributes(params.require(:article).permit(:title, :description))
end
```

Change the title and click 'Update Article'. We see the template is missing but the record has been successfully updated.

![First Article](./figures/updated_first_article.png)

The ActiveRecord class method first retrieves the first record in the table. In this case we got the first row in the articles table.

### Step 15 ##

Let's address the template is missing error. We don't need update.html.erb, we can redirect the user to the index page where all the records are displayed. Change the update method as follows:

```ruby
def update
  @article = Article.find(params[:id])
  @article.update_attributes(params.require(:article).permit(:title, :description))
  
  redirect_to articles_path
end
```

Edit the article and click 'Update Article'. You should see that it now updates the article.

Note : An annoying thing about Rails 4 is that when you run the rails generator to create a controller with a given action it also creates an entry in the routes.rb which is not required for a RESTful route. Let's delete the following line: 

```ruby
get "articles/index"
```

in the config/routes.rb file. Update the create method to use the articles_path as follows:

```ruby
def create
  Article.create(params.require(:article).permit(:title, :description))
  
  redirect_to articles_path
end
```

## Summary ##

In this lesson you learned how to update an existing record. In the next lesson we will see how to display a given article.

\newpage
