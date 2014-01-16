require 'nokogiri'
# require 'open-uri'

# html_file = open(ARGV[0])

class Post
  attr_reader :title, :url, :points, :item_id, :doc
  def initialize(doc)
    @doc = doc
    @title = doc.search('.title > a:first-child').map { |link| link.inner_text}[0]
    @item_id = doc.search('.subtext > a:nth-child(3)').map {|link| link['href'] }[0]
    @url = "https://news.ycombinator.com/" + @item_id
    @points = doc.search('.subtext > span:first-child').map { |span| span.inner_text}[0]
    @comment_list = []
  end

  def comments

    @comment_list = doc.search('.comment > font:first-child').map { |font| font.inner_text}
    @comment_list.map!{ |comment| Comment.new(comment) }


  end

  def add_comment(comment)
    @comment_list << Comment.new("comment")
  end
end


class Comment
  attr_reader :text
  def initialize(text)
    @text = text
  end
end

#post = Post.new(Nokogiri::HTML(File.open(html_file)))
post = Post.new(Nokogiri::HTML(File.open('post.html')))
comment = Comment.new(post)
# post.add_comment(comment)

post.comments
p "Post title: " + "#{post.title}"
p "Number of comments: " + "#{post.comments.length}"
# p post.points
# p post.item_id
