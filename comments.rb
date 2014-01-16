require 'nokogiri'

 # doc.search('.subtext > span:first-child').map { |span| span.inner_text}

 # doc.search('.subtext > a:nth-child(3)').map {|link| link['href'] }

 # doc.search('.title > a:first-child').map { |link| link.inner_text}

 # doc.search('.title > a:first-child').map { |link| link['href']}


doc = Nokogiri::HTML(open('post.html')) do |config|
  config
end

class Post
  attr_reader :title, :url, :points, :item_id
  def initialize
    @title = title
    @url = url
    @points = points
    @item_id = item_id
    @comment_list = nil
  end


  def comments(doc)
   @comment_list = doc.search('.comment > font:first-child').map { |font| font.inner_text}
  end

  def add_comment(new_comment)
    @comment_list << new_comment.text
  end

end

class Comment
  attr_reader :user_id, :time, :item_id, :text
  def initialize(text)
    @user_id = user_id
    @time = time
    @item_id = item_id
    @text = text
  end
end


newthing = Post.new
newthing.comments(doc)
newthing.add_comment(Comment.new("Here's the comment"))

