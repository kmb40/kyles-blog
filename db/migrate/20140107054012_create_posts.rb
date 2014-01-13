#The up method is used when we complete the migration (rake db:migrate), while the down method is ran when we rollback the last migration (rake db:rollback)

class CreatePosts < ActiveRecord::Migration
 def self.up
   create_table :posts do |t|
     t.string :title
     t.text :body
     t.timestamps
   end
 end

 def self.down
   drop_table :posts
 end
end