# Bonus Chapter #

--------------------------------------

# Multiple Representations of a Resource #

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

  Rest of the code remains the same as before
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

\newpage

## Summary ##

In this lesson you learned how to represent a resource in different formats. You learned about the format variable in the output of rake routes and how it plays a role in representing a resource in different formats. You can customize the fields that you want to display to the user by reading the Rails documentation.

\newpage
