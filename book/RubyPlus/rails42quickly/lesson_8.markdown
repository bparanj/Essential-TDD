CHAPTER 8
=============
Delete Article
------------------------------


## Objectives ##

- Learn how to delete a given article.
- Learn how to use flash messages.

## Steps ##

### Step 1 ###

Let's add 'Delete' link to each record displayed in the articles index page. Look at the output of rake routes.

![URL Helper For Delete](./figures/delete_route.png)

The last row is the route for destroy. The Prefix column is empty in this case. It means whatever is above that column that is not empty carries over to that row. So we can create our hyperlink as:

```ruby
<%= link_to 'Delete', article_path(article) %> 
```

This will create an hyperlink, when a user clicks on the link the browser will make a http GET request, which means it will end up in show action instead of destroy. Look the Verb column, you see we need to use DELETE http verb to hit the destroy action in the articles controller. So now we have:

```ruby
<%= link_to 'Delete', article_path(article), method: :delete %> 
```

The third parameter specifies that the http verb to be used is DELETE. Since this is an destructive action we want to avoid accidental deletion of records, so let's popup a javascript confirmation for delete like this:

```ruby
<%= link_to 'Delete', 
             article_path(article), 
						 method: :delete, 
						 data: { confirm: 'Are you sure?' } %> 
```

The fourth parameter will popup a window that confirms the delete action. The app/views/articles/index.html.erb now looks like this:

```ruby
<h1>Listing Articles</h1>

<% @articles.each do |article| %>

	<%= article.title %> : 

	<%= article.description %> 
	
	<%= link_to 'Edit', edit_article_path(article) %>
	<%= link_to 'Show', article %>
	<%= link_to 'Delete', 
	             article_path(article), 
							 method: :delete, 
							 data: { confirm: 'Are you sure?' } %> 
	
	<br/>

<% end %>
<br/>
<%= link_to 'New Article', new_article_path %>
```

\newpage

### Step 2 ###

Reload the articles index page http://localhost:3000/articles

![Delete Link](./figures/delete_link)

The delete link in the browser.

\newpage

### Step 3 ###

In the articles index page, do a 'View Page Source'.

![Delete Link Page Source](./figures/delete_link_source)

You see the html 5 data attribute data-confirm with the value 'Are you sure?'. This is the text displayed in the confirmation popup window. The data-method attribute value is delete. This is the http verb to be used for this link. The rel=nofollow tells spiders not to crawl these links because it will delete records in the database.

The combination of the URI pattern and the http verb DELETE uniquely identifies a resource endpoint on the server.

\newpage

### Step 4 ###

Right click on the http://localhost:3000/articles page. Click on the jquery_ujs.js link. 

![Data Confirm Link Element](./figures/data_confirm_ujs)

Search for 'confirm'. The first occurrence shows you the link element bound by jquery-ujs. UJS stands for Unobtrusive Javascript. It is unobtrusive because you don't see any javascript code in the html page.

![Data Confirm Popup](./figures/data_confirm_popup)

The second occurrence of the 'confirm' shows you the default confirm dialog.

![Data Method Delete](./figures/data_method_delete)

You can search for 'method'. You can see handler method that handles 'data-method' on links.

\newpage

### Step 5 ###

In the articles index page, click on the 'Delete' link.

![Confirmation Popup](./figures/delete_confirmation)

Click 'Cancel'.

\newpage

### Step 6 ###

Define the destroy method in articles controller as follows:

```ruby
def destroy
  @article = Article.find(params[:id])
  @article.destroy
  
  redirect_to articles_path
end
```

This method is very similar to update method. Instead of updating the record we are deleting it. You already know by this time how to look at the values sent by the browser to the server by looking at the server log output. You also know that params hash will contain the data sent to the server and Rails automatically populates the params hash.

\newpage

### Step 7 ###

In the articles index page, click on the 'Delete' link. Click 'Ok' in the confirmation popup. The record will now be deleted from the database and you will be redirected back to the articles index page.

![First Record Deleted](./figures/first_record_deleted)

Did we really delete the record? 

### Step 8 ###

The record was deleted but there is no feedback to the user. Let's modify the destroy action as follows:

```ruby
def destroy
  @article = Article.find(params[:id])
  @article.destroy
  
  redirect_to articles_path, notice: "Delete success"
end
```

Add the following code after the body tag in the application layout file, app/views/layouts/application.html.erb

```ruby
<% flash.each do |name, msg| -%>
      <%= content_tag :div, msg, class: name %>
<% end -%>
```

Your updated layout file will now look like this:

```ruby
<!DOCTYPE html>
<html>
<head>
<title>Blog</title>
<%= stylesheet_link_tag "application", 
media: "all", 
"data-turbolinks-track" => true %>
<%= javascript_include_tag "application", 
"data-turbolinks-track" => true %>
<%= csrf_meta_tags %>
</head>
<body>

	<% flash.each do |name, msg| -%>
	      <%= content_tag :div, msg, class: name %>
	<% end -%>

<%= yield %>

</body>
</html>
```

\newpage

### Step 9 ###

In the articles index page, click on the 'Delete' link.

![Delete Success](./figures/delete_success)

Now you see the feedback that is displayed to the user after delete operation.

\newpage

### Step 10 ###

In the articles index page, do a 'View Page Source'.

![Delete Success Page Source](./figures/delete_success_source)

You can see the content_tag helper generated html for the notice section.

## Summary ##

In this lesson we learned how to delete a given article. We also learned about flash notice to provide user feedback. In the next lesson we will learn about eliminating duplication in views.


\newpage
