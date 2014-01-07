# myapp.rb

require 'sinatra'
require 'sinatra/activerecord'
require './database-config'


class Post < ActiveRecord::Base
end