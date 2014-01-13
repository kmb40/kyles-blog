# myapp.rb
#This file is the core of the application - Kyle M. Brown
#ActiveRecord is an ORM (Object Relational Mapping (ORM). It does the translations between Ruby objects and the database which deals with records and relations.

#required elements
require 'sinatra'
require 'sinatra/activerecord' 
require './database-config'

#Error and validation handling
require 'sinatra/flash'
require 'sinatra/redirect_with_flash'

enable :sessions

#class Post < ActiveRecord::Base
#end

class Post < ActiveRecord::Base
 validates :title, presence: true, length: { minimum: 5 }
 validates :body, presence: true
end

#Setup the route for the index page.
get "/" do
  @posts = Post.order("created_at DESC")
  @title = "Welcome."
  erb :"posts/index"
end

#Sets the variable for the title.
helpers do
  def title
    if @title
      "#{@title}"
    else
      "Welcome."
    end
  end
end

#Setup the route for the create post when clicked link.
get "/posts/create" do
 @title = "Create post"
 @post = Post.new
 erb :"posts/create"
end

#Setup the route for post request (new titles and descirptions are submitted).
post "/posts" do
 @post = Post.new(params[:post])
 if @post.save
   redirect "posts/#{@post.id}", :notice => 'Congrats! Love the new post. (This message will disapear in 4 seconds.)'
 else
   redirect "posts/create", :error => 'Something went wrong. Try again. (This message will disapear in 4 seconds.)'
 end
end

#Setup the route for the post (title) link when clicked.
get "/posts/:id" do
 @post = Post.find(params[:id])
 @title = @post.title
 erb :"posts/view"
end
