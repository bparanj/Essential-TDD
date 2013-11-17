# 3. Model #

## Objective ##

- To learn the model part M of the MVC framework

## Steps ##
### Step 1 ##

Open config/routes.rb file and add :

```ruby
resources :articles
```
 
Save the file. Your file should like this :

```ruby 
Blog::Application.routes.draw do
  root 'welcome#index'
  
  resources :articles
end
```
 
What is a resource? Resource can represent any concept. For instance if you read the documenation for [Twitter API](https://dev.twitter.com/docs/api/1.1/ "Twitter API"), you will see that Timeline is a resource. It is defined in the documenation as collections of Tweets, ordered with the most recent first. There may not be a one-to-one correspondence between a resource and database table. In our case we have one-to-one correspondence between the database table articles and the article resource.

We have a plural resource so we will have index page that displays a list of all the articles in our case. Singular resource can be used when you don't need index action, for instance if a customer has a billing profile then from the perspective of a customer you can use a singular resource for billing_profile. From an admin perspective you could have a plural resource to manage billing profiles of customers (most likely using admin namespace in the routes).

### Step 2 ##

Go to the blog directory in the terminal and run:

```ruby
$ rake routes
```

![Installed Routes](./figures/rake_routes.png)

The output shows that defining the articles resource in the routes.rb gives us routing for :

Action         Purpose       								 
------------  ------------------------------ 
 create       creating a new article         
 update       updating a given article       
 delete       deleting a given article       
 show         displaying a given article     
 index        displaying a list of articles 


Since we have plural resources in the routes.rb, we get the index action. If you had used a singular resource : 

```ruby
resource :article
```
 
then you will not have a routing for index action. Based on the requirements you will choose a singular or plural resources for your application.

### Step 3 ##	 

In the previous lesson we saw how the controller and view work together. Now let's look at the model. Create an active_record object by running the following command:

```ruby
$ rails g model article title:string description:text
```
 
![Article Model](./figures/create_model.png)
 
In this command the rails generator generates a model by the name of article. The active_record is the singular form, the database will be plural form called as articles. The articles table will have a title column of type string and description column of type text. 

### Step 4 ##

Open the file db/migrate/xyz_create_articles.rb file. The xyz will be a timestamp and it will differ based on when you ran the command. 

There is a change() method in the migration file. Inside the change() method there is create_table() method that takes the name of the table to create and also the columns and it's data type. 

In our case we are creating the articles table. Timestamps gives created_at and updated_at timestamps that tracks when a given record was created and updated respectively. By convention the primary key of the table is id. So you don't see it explictly in the migration file.

### Step 5 ##

Go to the blog directory in the terminal and run :

```ruby
$ rake db:migrate
```
 
![Create Table](./figures/migrate.png)
 
This will create the articles table. 
 
### Step 6 ##

In the blog directory run:

```ruby
$ rails db
```
 
This will drop you into the database console. You can run SQL commands to query the development database.
 
### Step 7 ##

In the database console run:

```ruby
select * from articles;
```

![Rails Db Console](./figures/dbconsole.png)
 
You can see from the output there are no records in the database. 

### Step 8 ##
 
Open another tab in the terminal and go to the blog directory. Run the following command:

```ruby
$ rails c
```
 
c is the alias for console. This will take you to rails console where you can execute Ruby code and experiment to learn Rails.

### Step 9 ##
 
Type : 

```ruby
Article.count 
```

in the rails console. 

![Rails Console](./figures/rails_console.png)

You will see the count is 0. Let's create a row in the articles table. 

### Step 10 ##

Type : 

```ruby
Article.create(title: 'test', description: 'first row')
```

![Create a Record](./figures/rails_console_3.png)
 
The Article class method create creates a row in the database. You can see the ActiveRecord generated SQL query in the output.

## Exercise 1 ##

Check the number of articles count by using the database console or the rails console.

### Step 11 ##

Let's create another record by running the following command in the rails console:

```ruby   
$ article = Article.new(title: 'record two', description: 'second row')
```

![Article Instance](./figures/rails_console_4.png)

Now it's time for the second exercise.

## Exercise 2 ##

Check the number of articles count by using the database console or the rails console. How many rows do you see in the articles table? Why?

\newpage

The reason you see only one record in the database is that creating an instance of Article does not create a record in the database. The article instance in this case is still in memory. 

![Article Count](./figures/rails_console_5.png)

In order to save this instance to the articles table, you need to call the save method like this:

```ruby
$ article.save
```
 
![Saving a Record](./figures/rails_console_6.png)
 
Now query the articles table to get the number of records. We now have some records in the database. In the next chapter we will display all the records in articles table on the browser.

## Summary ##

In this chapter we focused on learning the model part M of the MVC framework. We experimented in the rails console and database console to create records in the database. In the next lesson we will see how the different parts of the MVC interact to create database driven dynamic web application.

\newpage
