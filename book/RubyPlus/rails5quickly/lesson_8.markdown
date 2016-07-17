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

```sh
      Prefix Verb   URI Pattern                  Controller#Action
    articles GET    /articles(.:format)          articles#index
             POST   /articles(.:format)          articles#create
 new_article GET    /articles/new(.:format)      articles#new
edit_article GET    /articles/:id/edit(.:format) articles#edit
     article GET    /articles/:id(.:format)      articles#show
             PATCH  /articles/:id(.:format)      articles#update
             PUT    /articles/:id(.:format)      articles#update
             DELETE /articles/:id(.:format)      articles#destroy
```			 

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

```html
<a data-confirm="Are you sure?" rel="nofollow" data-method="delete" href="/articles/1">Delete</a>
```

You see the html5 data attribute data-confirm with the value 'Are you sure?'. This is the text displayed in the confirmation popup window. The data-method attribute value is delete. This is the http verb to be used for this link. The `rel=nofollow` tells spiders not to crawl these links because it will delete records in the database.

The combination of the URI pattern and the http verb DELETE uniquely identifies a resource endpoint on the server.

\newpage

### Step 4 ###

Right click on the http://localhost:3000/articles page. Click on the `/assets/jquery_ujs.self-xyz.js` link. 

![Data Confirm Link Element](./figures/data_confirm_ujs)

Search for 'confirm'. The first occurrence shows you the link element bound by jquery-ujs.

```javascript
// Link elements bound by jquery-ujs
    linkClickSelector: 'a[data-confirm], a[data-method], a[data-remote]:not([disabled]), a[data-disable-with], a[data-disable]',
```

UJS stands for Unobtrusive Javascript. It is unobtrusive because you don't see any javascript code in the html page.

![Data Confirm Popup](./figures/data_confirm_popup)

```javascript
// Default confirm dialog, may be overridden with custom confirm dialog in $.rails.confirm
    confirm: function(message) {
      return confirm(message);
    },
```	
If you scroll down you the see default confirm dialog as shown in the above code snippet.

![Data Method Delete](./figures/data_method_delete)

You can search for 'data-method'.

```javascript
// Handles "data-method" on links such as:
  // <a href="/users/5" data-method="delete" rel="nofollow" data-confirm="Are you sure?">Delete</a>
    handleMethod: function(link) {
      var href = rails.href(link),
        method = link.data('method'),
        target = link.attr('target'),
        csrfToken = rails.csrfToken(),
        csrfParam = rails.csrfParam(),
        form = $('<form method="post" action="' + href + '"></form>'),
        metadataInput = '<input name="_method" value="' + method + '" type="hidden" />';
```

You can see handler method that handles 'data-method' on links as shown in the above code snippet.

\newpage

### Step 5 ###

In the articles index page, click on the 'Delete' link.

![Confirmation Popup](./figures/delete_confirmation)

Click 'Cancel' for the confirmation popup window.

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

This method is very similar to update method. Instead of updating the record we are deleting it. You already know how to look at the values sent by the browser to the server by looking at the server log output. You also know that params hash will contain the data sent to the server and Rails automatically populates the params hash.

\newpage

### Step 7 ###

In the articles index page, click on the 'Delete' link. Click 'Ok' in the confirmation popup. The record will now be deleted from the database and you will be redirected back to the articles index page.

![First Record Deleted](./figures/first_record_deleted)

```sh
Started DELETE "/articles/1" for ::1 at 2016-07-05 20:59:30 -0700
Processing by ArticlesController#destroy as HTML
  Parameters: {"authenticity_token"=>"5xRDtKZ7NN7sXlzAQk6pZ+zs0lfxCrPKj78ihHuqma0s/uR4OkhYgrk+tvxRLFypBcPKyYB2gloc+cGhWielgw==", "id"=>"1"}
  Article Load (0.2ms)  SELECT  "articles".* FROM "articles" WHERE "articles"."id" = ? LIMIT ?  [["id", 1], ["LIMIT", 1]]
   (0.1ms)  begin transaction
  SQL (0.3ms)  DELETE FROM "articles" WHERE "articles"."id" = ?  [["id", 1]]
   (80.8ms)  commit transaction
Redirected to http://localhost:3000/articles
Completed 302 Found in 95ms (ActiveRecord: 82.2ms)

Started GET "/articles" for ::1 at 2016-07-05 20:59:30 -0700
Processing by ArticlesController#index as HTML
  Rendering articles/index.html.erb within layouts/application
  Article Load (0.2ms)  SELECT "articles".* FROM "articles"
  Rendered articles/index.html.erb within layouts/application (3.1ms)
Completed 200 OK in 46ms (Views: 43.7ms | ActiveRecord: 0.2ms)
```

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
<%= stylesheet_link_tag "application",  media: "all",  "data-turbolinks-track" => true %>
<%= javascript_include_tag "application",  "data-turbolinks-track" => true %>
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

```html
<div class="notice">Delete success</div>
```

You can see the generated html for the notice section.

## Summary ##

In this lesson we learned how to delete a given article. We also learned about flash notice to provide user feedback. In the next lesson we will learn how to eliminate duplication in views.


\newpage
