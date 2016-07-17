# Bonus Chapter 1 - Filters #

## Objective ##

- To learn how to use before_action filter 

## Steps ##
### Step 1 ###

Add a find_article method to articles_controller.rb:

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
    
  http_basic_authenticate_with name: 'welcome', 
  password: 'secret', 
  except: [:index, :show]

  def index
    @articles = Article.all    
  end
  
  def new
    @article = Article.new
  end
  
  def create
    Article.create(params.require(:article).permit(:title, :description))
    
    redirect_to articles_path
  end
  
  def edit
  end
  
  def update
    allowed_params = params.require(:article).permit(:title, :description)
    @article.update_attributes(allowed_params)
    
    redirect_to articles_path
  end
  
  def show
  end
  
  def destroy
    @article.destroy
    
    redirect_to articles_path, notice: "Delete success"
  end
  
  def find_article
    @article = Article.find(params[:id])
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

In this lesson we learned how to use before_action filter. It takes the name of the method as a symbol and calls that method before an action is executed. We customized the filter by excluding some of the actions that does not require loading the article from the database. To learn more about filters check out the  [Rails Getting Started Guide] (http://guides.rubyonrails.org/ 'Rails Getting Started Guide') site.

\newpage

# Bonus Chapter 2 - Validations #

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

#  Bonus Chapter 3 -  Twitter Bootstrap 3.3 #

## Objective ##

- Learn how to integrate Twitter Bootstrap 3.3 with Rails 4.2 and style your web application.

## Steps ##
### Step 1 ###

Add the following line to Gemfile:

```ruby
gem 'bootstrap-sass', '~> 3.3.1'
```

If you skip this step, you will get the error: `File to import not found or unreadable: bootstrap-sprockets`. Rails 4.2 automatically adds the sass-rails gem to the Gemfile. You can open the Gemfile to verify it.

### Step 2 ###

It is also recommended to use [Autoprefixer](https://github.com/ai/autoprefixer-rails "Autoprefixer") with Bootstrap to add browser vendor prefixes automatically. Simply add the gem:

```ruby
gem 'autoprefixer-rails'
```

to Gemfile.

### Step 3 ###

Run :

```ruby
bundle install
```

from the blog directory. Restart your server to make the files available through the asset pipeline.

###  Step 4 ### 

Open the file `app/assets/stylesheets/application.css.scss` and import Bootstrap styles:

```scss
// "bootstrap-sprockets" must be imported before 
// "bootstrap" and "bootstrap/variables"
@import "bootstrap-sprockets";
@import "bootstrap";
```

`bootstrap-sprockets` must be imported before `bootstrap` for the icon fonts to work.

### Step 5 ### 

Make sure the file has `.css.scss` extension for Sass syntax. If you have just generated a new Rails app, it may come with a `.css` file instead. If this file exists, it will be served instead of Sass, so rename the `app/assets/stylesheets/application.css` to `app/assets/stylesheets/application.css.scss`.

### Step 6 ### 

Require Bootstrap Javascripts in `app/assets/javascripts/application.js`:

```js
//= require jquery
//= require bootstrap-sprockets
//= require jquery_ujs
//= require turbolinks
//= require_tree .
```

### Step 7 ### 

Bootstrap makes use of certain HTML elements and CSS properties that require the use of the HTML5 doctype. Include it at the beginning of all the layout files and any views that has html tag.

```html
<!DOCTYPE html>
<html lang='en'>

</html>
```

Update the application.html.erb with the minimal Bootstrap document.

```ruby
<!DOCTYPE html>
<html lang="en">
  <head>
	<meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
	<title>Blog</title>
	<%= stylesheet_link_tag    'application', media: 'all', 'data-turbolinks-track' => true %>
	<%= javascript_include_tag 'application', 'data-turbolinks-track' => true %>
	<%= csrf_meta_tags %>
	<!-- HTML5 shim and Respond.js for IE8 support of HTML5 elements and media queries -->
    <!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
    <!--[if lt IE 9]>
      <script src="https://oss.maxcdn.com/html5shiv/3.7.2/html5shiv.min.js"></script>
      <script src="https://oss.maxcdn.com/respond/1.4.2/respond.min.js"></script>
    <![endif]-->
  </head>
  <body>
	<p class="notice"><%= notice %></p>
    <p class="alert"><%= alert %></p>
    
	<ul class="hmenu">

	</ul>

	<%= yield %>
	
  </body>
</html>
```

### Step 8 ### 

Start the rails server and go to the home page. You should see 'Hello, Rails'.

### Step 9 ### 

Create app/views/shared/_navigation_bar.html.erb.

```html
<nav class="navbar navbar-default" role="navigation">
  <div class="container-fluid">
    <!-- Brand and toggle get grouped for better mobile display -->
    <div class="navbar-header">
      <button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#bs-example-navbar-collapse-1">
        <span class="sr-only">Toggle navigation</span>
        <span class="icon-bar"></span>
        <span class="icon-bar"></span>
        <span class="icon-bar"></span>
      </button>
      <a class="navbar-brand" href="#">Brand</a>
    </div>

    <!-- Collect the nav links, forms, and other content for toggling -->
    <div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
      <ul class="nav navbar-nav">
        <li class="active"><a href="#">Link <span class="sr-only">(current)</span></a></li>
        <li><a href="#">Link</a></li>
        <li class="dropdown">
          <a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-expanded="false">Dropdown <span class="caret"></span></a>
          <ul class="dropdown-menu" role="menu">
            <li><a href="#">Action</a></li>
            <li><a href="#">Another action</a></li>
            <li><a href="#">Something else here</a></li>
            <li class="divider"></li>
            <li><a href="#">Separated link</a></li>
            <li class="divider"></li>
            <li><a href="#">One more separated link</a></li>
          </ul>
        </li>
      </ul>
      <form class="navbar-form navbar-left" role="search">
        <div class="form-group">
          <input type="text" class="form-control" placeholder="Search">
        </div>
        <button type="submit" class="btn btn-default">Submit</button>
      </form>
      <ul class="nav navbar-nav navbar-right">
        <li><a href="#">Link</a></li>
        <li class="dropdown">
          <a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-expanded="false">Dropdown <span class="caret"></span></a>
          <ul class="dropdown-menu" role="menu">
            <li><a href="#">Action</a></li>
            <li><a href="#">Another action</a></li>
            <li><a href="#">Something else here</a></li>
            <li class="divider"></li>
            <li><a href="#">Separated link</a></li>
          </ul>
        </li>
      </ul>
    </div><!-- /.navbar-collapse -->
  </div><!-- /.container-fluid -->
</nav>
```

This is copied from Twitter Bootstrap 3.3 Documentation.

### Step 10 ###

Add `<%= render 'shared/navigation_bar' %>` to the app/views/application.html.erb. The layout file now looks like this:

```ruby
  <body>
	<p class="notice"><%= notice %></p>
    <p class="alert"><%= alert %></p>
    
    <%= render 'shared/navigation_bar' %>
	
	<ul class="hmenu">

	</ul>

	<%= yield %>
	
  </body>
```

Reload the home page.

### Step 11 ### 

The navigation bar has a gap at the top. Let's fix it now. Add `navbar-fixed-top` to the nav class in app/views/shared/_navigation_bar.html.erb file, the first line now becomes as follows:

```html
<nav class="navbar navbar-default navbar-fixed-top" role="navigation">
```

Reload the page and the navigation bar will now stay at the top.


### Step 12 ###

The main content for the page has no gap to the left. Let's fix it now. Edit the application.html.erb file to wrap the `yield' with div tag with class container. This class is provided by the Twitter Bootstrap 3.3.

```ruby
<div class='container'>
	<%= yield %>
</div>
```

Reload the page, now the main content will be displayed with a gap at the left of the browser.

### Step 13 ###

Let's change the button to use Twitter Bootstrap button for create new article page. Edit the app/views/articles/new.html.erb.

```ruby
<div class="actions">
  <%= f.submit "Submit", class: 'btn btn-primary' %>
</div>
```

Click on the 'New Article' link. You will now see a blue Submit button.

### Step 14 ###

Click on 'My Blog' link, the list of blog posts is not styled. Let's make them look nice now. Replace the contents of app/views/articles/index.html.erb with the following code:

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

### Step 15 ###

Reload the http://localhost:3000/articles page. 

![Twitter Bootstrap Styled Table](./figures/bootstrap_styled_table.png)

\newpage

## Exercise ##

Implement the 'About' tab so that it displays the content of about page. Use welcome_controller.rb and define the appropriate routes.

## Summary ##

In this lesson you learned about application wide layout file and how to configure and use Twitter Bootstrap 3.3 with Rails 4.2 application. 

\newpage
