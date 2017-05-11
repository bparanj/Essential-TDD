CHAPTER 3
=============
Model
------------------------------


## Objective ##

- To learn the model part M of the MVC framework

## Context 

We are going to create an web application that will have articles to read, create, list, update and delete.

## Steps ##
### Step 1 ##

In Rails, model is a persistent object that can also contain business logic. Model is the Object Relational Mapping (ORM) layer that uses ActiveRecord design pattern. Open config/routes.rb file and add :

```ruby
resources :articles
```
 
Save the file. Your file should like this :

```ruby 
Rails.application.routes.draw do
  resources :articles
  
  root 'welcome#index'
end
```
 
What is a resource? Resource can represent any concept. For instance if you read the documentation for [Twitter API](https://dev.twitter.com/docs/api/1.1/ "Twitter API"), you will see that Timeline is a resource. It is defined in the documentation as collections of Tweets, ordered with the most recent first. 

There may not be a one-to-one correspondence between a resource and a database table. In our case we have one-to-one correspondence between the database table articles and the article resource.

We have a plural resource, so we will have index page that displays a list of all the articles in our case. Singular resource can be used when you don't need index action, for instance if a customer has a billing profile then from the perspective of a customer you can use a singular resource for billing_profile. From an admin perspective you could have a plural resource to manage billing profiles of customers (most likely using admin namespace in the routes).

### Step 2 ##

Go to the blog directory in the terminal and run:

```ruby
$ rails routes
```

```sh
$ rake routes
      Prefix Verb   URI Pattern                  Controller#Action
    articles GET    /articles(.:format)          articles#index
             POST   /articles(.:format)          articles#create
 new_article GET    /articles/new(.:format)      articles#new
edit_article GET    /articles/:id/edit(.:format) articles#edit
     article GET    /articles/:id(.:format)      articles#show
             PATCH  /articles/:id(.:format)      articles#update
             PUT    /articles/:id(.:format)      articles#update
             DELETE /articles/:id(.:format)      articles#destroy
        root GET    /                            welcome#index
```

![Installed Routes](./figures/rails_routes.png)

The output shows that defining the articles resource in the routes.rb gives us routing for :

```sh
Action         Purpose       								 
------------  ------------------------------ 
 create       Creating a new article         
 update       Updating a given article       
 delete       Deleting a given article       
 show         Displaying a given article     
 index        Displaying a list of articles 
```

Since we have plural resources in the routes.rb, we get the index action. If you had used a singular resource : 

```ruby
resource :article
```
 
then you will not have a routing for index action. 

```sh
      Prefix Verb   URI Pattern             Controller#Action
     article POST   /article(.:format)      articles#create
 new_article GET    /article/new(.:format)  articles#new
edit_article GET    /article/edit(.:format) articles#edit
             GET    /article(.:format)      articles#show
             PATCH  /article(.:format)      articles#update
             PUT    /article(.:format)      articles#update
             DELETE /article(.:format)      articles#destroy
```

Based on the requirements you will choose either a singular or plural resources for your application.

### Step 3 ##	 

In the previous lesson we saw how the controller and view work together. Now let's look at the model. Create an ActiveRecord subclass by running the following command:

```ruby
$rails g model article title:string description:text
```
 
![Article Model](./figures/create_model.png)
 
In this command the rails generator generates a model by the name of article. The ActiveRecord class name is in the singular form, the database will be plural form called as articles. The articles table will have a title column of type string and description column of type text. The title will be displayed as a text field and the description will be displayed as text area in the view.

\newpage

### Step 4 ##

Open the file db/migrate/xyz_create_articles.rb file. The xyz will be a timestamp and it will differ based on when you ran the command. The class CreateArticles is a subclass of ActiveRecord::Migration class.

There is a change() method in the migration file. Inside the change() method there is create_table() method that takes the name of the table to create and also the columns and it's data type. 

In our case we are creating the articles table, t.timestamps gives created_at and updated_at timestamps that tracks when a given record was created and updated respectively. By convention the primary key of the table is id. So you don't see it in the migration file.

### Step 5 ##

Go to the blog directory in the terminal and run :

```ruby
$ rails db:migrate
```

You will see the output:

```sh
== 20160705224113 CreateArticles: migrating ===========
-- create_table(:articles)
   -> 0.0017s
== 20160705224113 CreateArticles: migrated (0.0018s) ==
```
 
![Create Articles Table](./figures/migrate.png)
 
This will create the articles table. 
 
\newpage
 
### Step 6 ##

In the blog directory run:

```sh
$rails db
```
 
This will drop you into the database console. You can run SQL commands to query the development database.
 
### Step 7 ##

In the database console run:

```sh
select count(*) from articles;
```

![Rails Db Console](./figures/dbconsole.png)

```sh
$rails db
SQLite version 3.7.7 2011-06-25 16:35:41
Enter ".help" for instructions
Enter SQL statements terminated with a ";"
sqlite> select count(*) from articles;
0
```
 
You can see from the output there are no records in the database. If you want to exit the db console type `.quit`.

\newpage

### Step 8 ##
 
Open another tab in the terminal and go to the blog directory. Run the following command:

```sh
$rails c
```
 
c is the alias for console. This will take you to rails console where you can execute Ruby code and experiment to learn Rails.

### Step 9 ##
 
Type : 

```ruby
Article.count 
```

in the rails console. 

![Rails Console](./figures/rails_console.png)

```sh
 (0.1ms)  SELECT COUNT(*) FROM "articles"
 => 0 
```

You can see that ActiveRecord generated the SQL query we used in Step 7. The count is 0. Let's create a new record in the articles table. 

\newpage

### Step 10 ##

Type : 

```ruby
Article.create(title: 'test', description: 'first row')
```
 
![Create a Record](./figures/rails_console_3.png)

```sh
(0.1ms)  begin transaction
SQL (0.4ms)  INSERT INTO "articles" ("title", "description", "created_at", "updated_at") VALUES (?, ?, ?, ?)  [["title", "test"], ["description", "first row"], ["created_at", 2016-07-05 22:47:17 UTC], ["updated_at", 2016-07-05 22:47:17 UTC]]
(43.8ms)  commit transaction
 => #<Article id: 1, title: "test", description: "first row", created_at: "2016-07-05 22:47:17", updated_at: "2016-07-05 22:47:17"> 	 
```
 
The create class method inherited from ActiveRecord by Article creates a row in the database. You can see the ActiveRecord generated insert SQL query in the output. 

## Exercise 1 ##

Check the number of articles count by using the database console or the rails console.

### Step 11 ##

Let's create another record by running the following command in the rails console:

```ruby   
article = Article.new(title: 'record two', description: 'second row')
```

![Article Instance](./figures/rails_console_4.png)

You will see this output:

```sh
=> #<Article id: nil, title: "record two", description: "second row", created_at: nil, updated_at: nil>
```

Now it's time for the second exercise.

## Exercise 2 ##

Check the number of articles count by using the database console or the rails console. How many rows do you see in the articles table? Why?

\newpage

The reason you see only one record in the database is that creating an instance of Article does not create a record in the database. The article instance in this case is still in memory. 

![Article Count](./figures/rails_console_5.png)

In order to save this instance to the articles table, you need to call the save method like this:

```ruby
article.save
```

![Saving a Record](./figures/rails_console_6.png)

```sh 
(0.1ms)  begin transaction
SQL (0.5ms)  INSERT INTO "articles" ("title", "description", "created_at", "updated_at") VALUES (?, ?, ?, ?)  [["title", "record two"], ["description", "second row"], ["created_at", 2016-07-05 22:55:55 UTC], ["updated_at", 2016-07-05 22:55:55 UTC]]
(50.2ms)  commit transaction
=> true
```
 
Now query the articles table to get the number of records. You should now have two records in the database.

\newpage

## Summary ##

In this chapter we focused on learning the model part M of the MVC framework. We experimented in the rails console and database console to create records in the database. In the next lesson we will display all the records in articles table on the browser. We will also see how the different parts of the MVC interact to create database driven dynamic web application.

\newpage
