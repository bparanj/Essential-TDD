CHAPTER 12
=============
Restricting Operations
------------------------------


## Objective ##

- To learn how to use simple HTTP authentication to restrict access to actions

## Steps ##

### Step 1 ###

Add the following code to the top of the articles_controller.rb:

```ruby
class ArticlesController < ApplicationController
  
  http_basic_authenticate_with name: 'welcome', 
  password: 'secret', 
  except: [:index, :show]

  <!-- actions such as index, new etc omitted here -->
end
```

This declaration protects the creating, editing and deleting functionality. Read only operations such as show and index are not protected.

### Step 2 ###

Reload the articles index page : http://localhost:3000/articles 

\newpage

### Step 3 ###

Click 'Delete' for any of the article. 

![URL Error](./figures/http_basic_auth.png)

You will see popup for authentication.

### Step 4 ###

For user name, enter welcome and for password enter secret. Click 'Login'. Now the record will be deleted.

## Exercise 1 ##

Use http basic authentication to protect deleting comments in the articles show page.

## Exercise 2 ##

In the rails console do this:

```ruby
> ApplicationController.respond_to?(:http_basic_authenticate_with)
 => true 
> ApplicationController.method(:http_basic_authenticate_with).source_location
=> ["/Users/zepho/.rvm/gems/ruby-2.3.1@r5.0/gems/actionpack-5.0.0/lib/action_controller/metal/http_authentication.rb", 69]
```

Go to the file shown in the output and line 68. Read the code.

## Summary ##

This completes our quick tour of Rails 5. If you have developed the blog application following the 12 lessons you will now have a strong foundation to build upon by reading other Rails books to continue your journey to master the Rails framework. Good luck.

\newpage
