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

What is the url helper we should use? We know we need to display the articles/new.html.erb page. We also know that the action that is executed is 'new' before new.html.erb is displayed. Take a look at the rake routes output:

![New Article URL Helper](./figures/new_article.jpg)

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

![View Page Source](./figures/view_page_source)

You will see 'New Article' link pointing to the resource "/articles/new".

\newpage

### Step 5 ###

Click the 'New Article' link. Go to the terminal and look at the server output.

![HTTP Verb Get](./figures/get_articles_new.png)

You can see that the browser made a http GET request for the resource "/articles/new". 

![Action New Not Found](./figures/unknown_action_new)

You will see the above error page.

\newpage

### Step 6 ###

Let's create the new action in articles controller. Add the following code to articles controller:

```ruby
def new
  
end
```

### Step 7 ###

Reload the browser http://localhost:3000/articles/new page. You will see the missing template page.

![Missing Template](./figures/missing_template.png)

After the new action is executed Rails looks for view whose name is the same as the action, in this case app/views/articles/new.html.erb

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

Reload the browser http://localhost:3000/articles/new page. 

![Argument Error](./figures/argument_error)

You will now see the above error.

\newpage

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

![New Article Form](./figures/new_article_form)

You will now see an empty form to create a new article.

\newpage

### Step 12 ###

Right click and select 'View Page Source' on the new article form page. 

![New Article Page Source](./figures/new_article_page_source)

As you can see, form will be submitted to the url '/articles' and the http verb used is POST. When the user submits the form, which controller and which action will be executed?

\newpage

### Step 13 ###

Look at the output of rake routes, the combination of the http verb and the URL uniquely identifies the resource end point.

![Identifying Resource Endpoint](./figures/creating_new_article.jpg)

In this case we see that it maps to the articles controller and create action.

\newpage

### Step 14 ###

Fill out the form and click 'Create Article'. Check the server log output.

![Post Article Server Log](./figures/post_articles)

You can see that the browser made a post to the URL '/articles'.

![Unknown Action Create](./figures/unknown_action_create)

This error is due to absence of create action in the articles controller.

\newpage

### Step 15 ###

Define the create method in the articles controller as follows:

```ruby
def create
  
end
```

### Step 16 ###

Fill out the form and click 'Create Article'.

![Article Form Values](./figures/article_form_values)

You can see that the form values submitted by the user is sent to the server. Rails automatically populates a hash called params which contains a key whose name is the article symbol and the values are the different database columns and its values. You will see missing tempate error.

\newpage

![Article Create Missing Template](./figures/article_create_missing_template)

\newpage

### Step 17 ###

Before we fix the missing template issue, we need to save the data submitted by the user in the database. You already know how to use the ActiveRecord class method 'create' to save a record. You also know how Rails populates the params hash, this hash is made available to you in the controller. So we can access it like this :

```ruby
def create
  Article.create(params[:article])
end
```

In Figure 50, you see that the hash key article is a string, but I am using the symbol :article in the create method. How does this work? 

\newpage

![HashWithIndifferentAccess](./figures/hash_with_indifferent_access)

As you can see from the rails console, params hash is not a regular Ruby hash, it is a special hash called HashWithIndifferentAccess. It allows you to set the value of the hash with either a symbol or string and retreive the value using either string or symbol.

\newpage

### Step 18 ###

Fill out the form and submit again. 

![Forbidden Attributes Error](./figures/forbidden_attributes_error)

Now we get a forbidden attributes error.

\newpage

### Step 19 ###

Due to security reasons we need to specify which fields must be permitted as part of the form submission. Modify the create method as follows:

```ruby
def create
  Article.create(params.require(:article).permit(:title, :description))
end
```

\newpage

### Step 20 ###

Fill out the form and submit again. You will get the template missing error but you will now see that the user submitted data has been saved to the database.

![Save User Data](./figures/last_article)

The ActiveRecord class method 'last' method retrieves the last row in the articles table. 

\newpage

### Step 21 ### 

Let's now address the template is missing error. Once the data is saved in the database we can either display the index page or the show page for the article. Let's redirect the user to the index page. We will be able to see all the records including the new record that we created. Modify the create method as follows:

```ruby
def create
  Article.create(params.require(:article).permit(:title, :description))
  
  redirect_to articles_index_path
end
```

How do we know that we need to use articles_index_path url helper? We already saw how to find the URL helper to use in the view, we can do the same. If you see the output of rake routes command, we know the resource end point, to find the URL helper we look at the Prefix column.

\newpage

### Step 22 ###

Fill out the form and submit again. 

![Displaying All Articles](./figures/display_all_articles)

You will now see all the articles displayed in the index page.

\newpage

![Redirect to Articles Index Page](./figures/redirecting_to_articles_index.png)

Redirecting user to the articles index page.

\newpage

## Summary ##

We saw how we can save the user submitted data in the database. We went from the View to the Controller to the Model. We also saw how the controller decides which view to render next. We learned about the http verb and identifying resource endpoint in our application. Now we know how the new and create action works. In the next lesson we will see how edit and update action works to make changes to an existing record in the database.

\newpage
