require_relative '../source/post.rb'

new_comment = "this post rocks!"

p "Loading page from url: #{ARGV[0]}"
local_post = Post.new
p "There are #{local_post.comments.length} posts"
p "The last post content: "
p local_post.comments.last.text
p "Adding comment: #{new_comment}"
local_post.add_comment(new_comment)
p "There are #{local_post.comments.length} posts"
p "The last post content: "
p local_post.comments.last.text
