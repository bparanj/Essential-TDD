# Bonus Chapters #

--------------------------------------

# 1. Multiple Representations of a Resource #

## Objective ##

- To learn how to represent a resource in different formats such as XML and JSON.

## Steps ##
### Step 1 ###

Add the line:

```ruby
respond_to :xml
```

to articles_controller.rb file like this:

```ruby
class ArticlesController < ApplicationController
  respond_to :xml

  # Rest of the code remains the same as before
end
```

### Step 2 ###

Add the line:

```ruby
respond_with(@articles)
```

to index action in the articles_controller like this:

```ruby
def index
  @articles = Article.all
  
  respond_with(@articles)
end
```

### Step 3 ###

Open http://localhost:3000/articles.xml in the browser.

![XML Representation of Resource](./figures/xml_representation.png)

Rails automatically converts ActiveRecord objects to XML representation.

\newpage

### Step 4 ###

Open http://localhost:3000/articles in the browser.

![Broken HTML Representation](./figures/broken_html_representation.png)

Rails does not recognize this request and throws UnknownFormat error.

\newpage

### Step 5 ###

Change the line :

```ruby
respond_to :xml
```

to :

```ruby
respond_to :xml, :html
```

Reload http://localhost:3000/articles.html in the browser. You will now see that list of articles displayed in the browser in html format.

![Format Value in Brower Request](./figures/format_browser_request.png)

The value of format in the URI can be html, xml, json etc.

\newpage

![Format in URI](./figures/uri_format.png)

Format variable in the URI as seen in the output of 'rake routes' command.

## Exercise ##

Modify the respond_to to handle JSON format. Use the symbol :json and view the JSON representation in the browser.

## Summary ##

In this lesson you learned how to represent a resource in different formats. You learned about the format variable in the output of rake routes and how it plays a role in representing a resource in different formats. You can customize the fields that you want to display to the user by reading the Rails documentation.

\newpage

# 2. Filters #

## Objective ##

- To learn how to use before_action filter 

## Steps ##
### Step 1 ###

Add find_article method to articles_controller.rb:

```ruby
def find_article
  Article.find(params[:id])
end
```

### Step 2 ###

Add the before_action filter to articles_controller.rb:

```ruby
before_action :find_article, except: [:new, :create, :index]
```

We are excluding the new, create and index actions because we don't need to find an article for a given id for those methods.

### Step 3 ###

Remove the duplication in edit, updated, show and destroy by using the find_article method. The articles_controller.rb now looks like this:

```ruby
class ArticlesController < ApplicationController
  before_action :find_article, except: [:new, :create, :index]
  
  respond_to :xml, :html
  
  http_basic_authenticate_with name: 'welcome', 
  password: 'secret', 
  except: [:index, :show]

  def index
    @articles = Article.all
    
    respond_with(@articles)
  end
  
  def new
    @article = Article.new
  end
  
  def create
    Article.create(params.require(:article).permit(:title, :description))
    
    redirect_to articles_path
  end
  
  def edit
    @article = find_article
  end
  
  def update
    @article = find_article
    allowed_params = params.require(:article).permit(:title, :description)
    @article.update_attributes(allowed_params)
    
    redirect_to articles_path
  end
  
  def show
    @article = find_article
  end
  
  def destroy
    @article = find_article
    @article.destroy
    
    redirect_to articles_path, notice: "Delete success"
  end
  
  def find_article
    Article.find(params[:id])
  end
end
```

### Step 4 ###

We don't want the find_article method to be exposed as an action that can be called. So let's make it private like this:

```ruby
private

def find_article
  Article.find(params[:id])
end
```

Now this method can only be used within the articles controller class. Edit, delete and show features will work.

## Summary ##

In this lesson we learned how to use before_action filter. It takes the name of the method as a symbol and calls that method before an action is executed. We customized the filter by excluding some of the actions that does not require loading the article from the database. To learn more about filters check out the http://guides.rubyonrails.org/ site.

\newpage

# 3. Validations #

## Objectives ##

- To learn about validating user input
- To learn about render and redirect

## Steps ##
### Step 1 ###

Go to http://localhost:3000/articles page in the browser. Click on 'New Article' link and click submit without filling out the form. You will see that the title and description of the article is blank in the database. Let's fix this problem.

### Step 2 ###

Add the validation declarations to article.rb as follows:

```ruby
validates :title, presence: true
validates :description, presence: true
```

The article.rb file now looks like this:

```ruby
class Article < ActiveRecord::Base
  has_many :comments, dependent: :destroy
  
  validates :title, presence: true
  validates :description, presence: true
end
```

\newpage

### Step 3 ###

Submit the new article form without values for title and description. No new record is created but there is no feedback to the user explaining why new record was not created. 

![Blank Values Inserted in the Database](./figures/blank_values.png)

Let's provide user feedback.

\newpage

### Step 4 ###

Add the code to display validation error messsages to the app/views/articles/_form.html.erb file:

```ruby
<% if @article.errors.any? %>
  <h2><%= pluralize(@article.errors.count, "error") %> prohibited
    this article from being saved:</h2>

  <ul>
  <% @article.errors.full_messages.each do |m| %>
    <li><%= m %></li>
  <% end %>
  </ul>
<% end %>
```

Now the form partial looks like this:

```ruby
<%= form_for @article do |f| %>

  <% if @article.errors.any? %>
    <h2>
		  <%= pluralize(@article.errors.count, "error") %> 
		  prohibited this article from being saved:
		</h2>

    <ul>
    <% @article.errors.full_messages.each do |m| %>
      <li><%= m %></li>
    <% end %>
    </ul>
  <% end %>
	
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

The pluralize view helper method pluralizes the string argument depending on the number of the first parameter. In our case if there are more than one error than the output of pluralize will be 'errors' otherwise it will be 'error'. 

The any? method returns true if there are any elements in a given array, otherwise it returns false.

![The Array any? Method in Action](./figures/any_method.png)

Experimenting in the Rails console to learn about any? method.

\newpage

We iterate through all the error messages for the article object and display it in a list.

![Experimenting in the Rails Console](./figures/validation_errors.png)

### Step 5 ###

Change the create action in the articles controller as follows:

```ruby
def create
  allowed_params = params.require(:article).permit(:title, :description)
  article = Article.create(allowed_params)
  
  if article.errors.any?
    render :new
  else
    redirect_to articles_path
  end
end
```

\newpage

### Step 6 ###

Submit an empty new article form.

![Article Instance Variable is Nil](./figures/article_local_variable_error.png)

We get an error because when the render call renders the app/views/new.html.erb but does not execute the new action in the articles controller. 

\newpage

Since we need the instance variable that has errors we cannot use the article instance variable in the new action. 

![Article Instance in Memory](./figures/new_article_instance.png)

Let's change the local variable to an instance variable.

\newpage

### Step 7 ###

Change the article to @article in the create action of the articles_controller.rb.

```ruby
def create
  allowed_params = params.require(:article).permit(:title, :description)
  @article = Article.create(allowed_params)
  
  if @article.errors.any?
    render :new
  else
    redirect_to articles_path
  end
end
```

![Experimenting in the Rails Console](./figures/create_errors.png)

Learning the Rails API by experimenting in the Rails console.

Here we have changed the local variable article to an instance variable @article. This change allows the app/views/new.html.erb to render the form partial which uses @article variable. The render call will directly render the app/views/new.html.erb and will not execute any code in the new action in articles controller. This is different from redirect, which sends a 302 status code to the browser and it will execute the action before the view is rendered.

\newpage

### Step 8 ###

Submit an empty form for creating a new article. 

![Validation Error Messages](./figures/validation_error_messages.png)

You will now see error messages displayed to the user.

\newpage

## Exercises ##

1. Read the Rails documentation and add the validation check for the title so that the minimum length of title is 2.
2. Why does Article.new with no values for title and description have no errors whereas Article.create with no values for title and description have errors?

## Summary ##

In this lesson we learned how to display validation error messages to the user when the user does not provide required fields. We also learned the difference between the render and redirect calls.

\newpage

# 4. Using Twitter Bootstrap 3 #

## Objective ##

- Learn how to integrate Twitter Bootstrap 3 with Rails 4 and style your web application.

## Steps ##
### Step 1 ###

Add the following line to Gemfile:

```ruby
gem 'bootstrap-sass', github: 'thomas-mcdonald/bootstrap-sass'
```

### Step 2 ###

Run :

```ruby
bundle install
```

from the blog directory.

### Step 3 ###

Add the following line in your app/assets/javascripts/application.js file:

```ruby
//= require bootstrap 
```

### Step 4 ###
 
Make a file in app/assets/stylesheets called load_bootstrap.css.scss and in that file put:

```ruby
@import "bootstrap";
```

### Step 5 ###

The app/assets/stylesheets/application.css should look something like this:

```ruby
*= require_self
*= require load_bootstrap
*= require_tree .
*/
```
 
This loads the load_bootstrap file into the asset pipeline.

### Step 6 ###

In app/views/layouts/application.html.erb, inside the body tag change the html to the code shown below:

```ruby
	<nav class="navbar navbar-default" role="navigation">
	  <!-- Brand and toggle get grouped for better mobile display -->
	  <div class="navbar-header">
	    <button type="button" class="navbar-toggle" data-toggle="collapse" data-target="#bs-example-navbar-collapse-1">
	      <span class="sr-only">Toggle navigation</span>
	      <span class="icon-bar"></span>
	      <span class="icon-bar"></span>
	      <span class="icon-bar"></span>
	    </button>
	    <a class="navbar-brand" href="#">My Blog</a>
	  </div>

	  <!-- Collect the nav links, forms, and other content for toggling -->
	  <div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
	    <ul class="nav navbar-nav">
	      <li class="active"><a href="#">About</a></li>
	      <li><a href="#">Contact</a></li>

	    </ul>

	  </div><!-- /.navbar-collapse -->
	</nav>
	

	<% flash.each do |name, msg| -%>
	      <%= content_tag :div, msg, class: name %>
	<% end -%>


<%= yield %>	

```

The layout file application.html.erb is responsible for application wide layout. The yield is a place holder and its contents can change for different views. The header, footer and navigation defined in the layout will remain the same across different views.

### Step 7 ###

Wrap a :

```ruby
<div class="container"> 
```

around the yield in app/views/layouts/application.html.erb. So your yield call in layout file app/views/layouts/application.html.erb will look like this:

```ruby
<div class='container'>
<%= yield %>	
</div>
```

\newpage

### Step 8 ###

Reload the http://localhost:3000/ page on your browser:

![Twitter Bootstrap Styled Blog](./figures/bootstrap_styled.png)

You will now see the blog styled using bootstrap.

\newpage

### Step 9 ###

Click on 'My Blog' link, the list of blog posts is not styled. Let's make them look nice now. Replace the contents of app/views/index.html.erb with the following code:

```ruby
<h1>Articles</h1>
<table class="table table-striped">
  <thead>
    <tr>
      <th>ID</th>
      <th>Title</th>
      <th>Description</th>
      <th>Actions</th>
    </tr>
  </thead>
  <tbody>
    <% @articles.each do |article| %>
      <tr>
        <td><%= article.id %></td>
        <td><%= link_to article.title, article %></td>
        <td><%= article.description %></td>
        <td>
          <%= link_to 'Edit', 
											 edit_article_path(article), 
											 :class => 'btn btn-mini' %>
          <%= link_to 'Delete', 
											 article_path(article), 
											 :method => :delete, 
											 :confirm => 'Are you sure?', 
											 :class => 'btn btn-mini btn-danger' %>
        </td>
      </tr>
    <% end %>
  </tbody>
</table>

<%= link_to 'New Article', new_article_path, :class => 'btn btn-primary' %>
```

\newpage

### Step 10 ###

Reload the http://localhost:3000/articles page. 

![Twitter Bootstrap Styled Table](./figures/bootstrap_styled_table.png)

\newpage

### Step 11 ###

Let's now style the messages that is displayed to the user when they update or delete an article. Add the following method to app/views/helpers/application_helper.rb

```ruby
def bootstrap_class_for(flash_type)
  case flash_type
    when :success
      "alert-success"
    when :error
      "alert-error"
    when :alert
      "alert-block"
    when :notice
      "alert-info"
    else
      flash_type.to_s
  end
end
```

\newpage

### Step 12 ##

Replace the following code:

```ruby
<% flash.each do |name, msg| %>
      <%= content_tag :div, msg, class: name %>
<% end -%>
```

with the contents shown below:

![Twitter Bootstrap Flash Messages](./figures/twitter_flash_messages.png)

\newpage

### Step 13 ###

Go to articles index page and delete any one of the articles.

![Twitter Bootstrap Styled Flash Messages](./figures/delete_success_flash.png)

The flash messages will now be styled using Twitter Bootstrap alerts.

\newpage

### Step 14 ##

Let's now highlight the tab according to which tab is selected. Add the following method to the app/views/helpers/application_helper.rb.


```ruby
def active?(controller_name)
  servlet = params[:controller]
  
  if servlet == controller_name
    "active"
  else
    ""
  end

end
```

### Step 15 ###

Replace the hard coded active class in app/views/layouts/application.html.erb as shown below:

```ruby
<div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
  <ul class="nav navbar-nav">
		<li class="<%= active?('welcome')%>"> 
			<a href="/">Home</a>
		</li>
		<li class="<%= active?('articles')%>"> 
			<a href="/articles">Articles</a>
		</li>
    <li>
			<a href="#">Contact</a>
		</li>
  </ul>
</div><!-- /.navbar-collapse -->
```

![Highlight Home Page](./figures/home_page_highlight.png)

![Highlight Articles Page](./figures/articles_page_highlight.png)


Now you will the correct tab highlighted based on which tab is selected.

## Exercise ##

Implement the 'About' tab so that it displays the content of about page. Use welcome_controller.rb and define the appropriate routes.

## Summary ##

In this lesson you learned about application wide layout file and how to configure and use Twitter Bootstrap 3 with Rails application. You also learned about the view helpers that can be used in the views.

\newpage
