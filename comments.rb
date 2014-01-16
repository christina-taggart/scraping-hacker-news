require 'nokogiri'
require 'open-uri'

 # doc.search('.subtext > span:first-child').map { |span| span.inner_text}

 # doc.search('.subtext > a:nth-child(3)').map {|link| link['href'] }

 # doc.search('.title > a:first-child').map { |link| link.inner_text}

 # doc.search('.title > a:first-child').map { |link| link['href']}


site_to_scrape = Nokogiri::HTML(open(ARGV[0])) do |config|
  config
end

class Post
  attr_reader :title, :url, :points, :item_id
  attr_accessor :comment_list
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

  def num_of_comments
    puts "Number of comments: #{@comment_list.length}"
  end

  def post_title(doc)
    @title = doc.search('.title > a:first-child').map { |link| link.inner_text}.join()
    puts "Post title: #{@title}"
  end

end

class Comment
  attr_reader :user, :date, :link, :text, :post
  def initialize(text)
    @user = user
    @date = Time.now
    @link = link
    @text = text
    @post = post
  end
end


newthing = Post.new
newthing.comments(site_to_scrape)
newthing.add_comment(Comment.new("Here's the comment"))
newthing.num_of_comments
newthing.post_title(post.html)


