CHAPTER 9
=============
View Duplication
------------------------------

## Objective ##

- Learn how to eliminate duplication in views by using partials

## Steps ##

### Step 1 ###

Look at the app/views/new.html.erb and app/views/edit.html.erb. There is duplication. 

### Step 2 ###

Create a file called _form.html.erb under app/views/articles directory with the following contents:

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

### Step 3 ###

Edit the app/views/articles/new.html.erb and change the content as follows:

```ruby
<h1>New Article</h1>

<%= render 'form' %>
```

### Step 4 ###

Edit the app/views/articles/edit.html.erb and change the content as follows:

```ruby
<h1>Edit Article</h1>

<%= render 'form' %>
```

\newpage

### Step 5 ###

Go to http://localhost:3000/articles and create a new article and edit an existing article. The name of the partial begins with an underscore, when you include the partial by using the render helper you don't include the underscore. This is the Rails convention for using partials.

If you get the following error:

![Missing Partial Error](./figures/missing_partial_error.png)


It means you did not create the app/views/articles/_form.html.erb file. Make sure you followed the instruction in step 2.

## Summary ##

In this lesson we saw how to eliminate duplication in views by using partials. In the next lesson we will learn about relationships between models.

\newpage
