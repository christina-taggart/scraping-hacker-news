require 'nokogiri'

class Post
  def initialize(title, url, points, item_id)
    @title = title
    @url = url
    @points = points
    @item_id = item_id
    @comments = []
  end

  def comments
    @comments.each { |comment| p comment}
  end

  def add_comment(new_comment)
    @comments.push(new_comment)
  end

end #ends post class

class Comment
  def initialize(commentor, comment)
    @commentor = commentor
    @comment = comment
  end
end #ends comment class


doc = Nokogiri::HTML(open('post.html'))

def extract_usernames(doc)
  doc.search('.comhead > a:first-child').map do |element|
    element.inner_text
  end
end

#creating needed parameters to instantiate post object
points = doc.search('.subtext > span:first-child').map { |span| span.inner_text}
item_id = doc.search('.subtext > a:nth-child(3)').map {|link| link['href'] }
title = doc.search('.title > a:first-child').map { |link| link.inner_text}
url = doc.search('.title > a:first-child').map { |link| link['href']}
comment = doc.search('.comment > font:first-child').map { |font| font.inner_text}
commentors = extract_usernames(doc)

# Creating new post object
post_object = Post.new(title, url, points, item_id)
p post_object.inspect


# Filling Post object with comments
for i in (0..comment.length-1) do
  comment_object = Comment.new(commentors[i], comment[i])
  post_object.add_comment(comment_object)
end

my_new_comment = Comment.new("henry", "snowman")
p my_new_comment


p post_object
p "-----"
post_object.add_comment(my_new_comment)
p post_object

post_object.comments

p post_object.class == Post











