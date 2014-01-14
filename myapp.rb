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

#Set the route to edit post (both get and post)
get "/posts/:id/edit" do
  @post = Post.find(params[:id])
  @title = "Edit Form"
  erb :"posts/edit"
end
put "/posts/:id" do
  @post = Post.find(params[:id])
  @post.update(params[:post])
  redirect "/posts/#{@post.id}"
end

#Escaping fields to prevent xss for security
helpers do
  include Rack::Utils
  alias_method :h, :escape_html
end

#Routes the delete function to the delete.erb file when a user clicks the delete link.
get '/posts/:id/delete' do
  @post = Post.find(params[:id])
  @title = "Confirm deletion of note ##{params[:id]}"
  if @post
    erb :"posts/delete"
  else
    redirect'/', :error => "Can't find that post."
  end
end

#Route to complete the delete function when the user clicks the link
delete '/posts/:id' do
  n = Post.find(params[:id])
  if n.destroy  
          redirect '/', :notice => 'Note deleted successfully.'  
      else  
          redirect '/', :error => 'Error deleting note.'  
      end
end
