require_relative '../source/post.rb'

filename = "post.html" 
new_comment = "this post rocks!"

p "Loading page from file: #{filename}..."
local_post = Post.new(filename)
p "There are #{local_post.comments.length} posts"
p "The last post content: "
p local_post.comments.last.text
p "Adding comment: #{new_comment}"
local_post.add_comment(new_comment)
p "There are #{local_post.comments.length} posts"
p "The last post content: "
p local_post.comments.last.text