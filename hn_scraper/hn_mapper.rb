require 'nokogiri'

class Post
  attr_reader :title, :post_link, :url, :item_id, :comments
  attr_accessor :points
  def initialize(url)
    @doc = Nokogiri::HTML(File.open(url))
    @title = get_title
    @url = url
    @item_id = get_item_id
    @points = get_points
    @comments = load_existing_comments
  end

  def get_title
    @doc.search('.title > a').map{|title| title.inner_text}.join
  end

  def get_points
    @doc.search('.subtext > span').map{|points| points.inner_text.match(/\d+/).to_s}.join.to_i
  end

  def get_item_id
    @doc.search('.subtext > span').map{|span| span['id'].match(/\d+/).to_s}.join.to_i
  end

  def load_existing_comments
    all_comments = @doc.search('.default').map{|comment| comment}
    loaded = []
    all_comments.each do |comment|
      loaded << Comment.new(comment)
    end
    loaded
  end

  def add_comments
  end

end

class Comment
  attr_reader :username, :created_at, :permalink, :body #, :parent

  def initialize(comment_object)
    @comment_object = comment_object
    @username = get_username
    @created_at = get_created_at
    @body = get_body
    @permalink = get_permalink
  end

  def get_username
    @comment_object.search('.comhead > a:first-child').map{|name| name.inner_text}.join
  end

  def get_created_at
    @comment_object.search('.comhead').map{|date| date.inner_text.gsub(/\A.+\s(\d+\s+.+)\| link/, '\1')}.join.strip
  end

  def get_permalink
    @comment_object.search('.comhead > a:nth-child(2)').map {|link| "https://news.ycombinator.com/#{link['href']}"}.join
  end

  def get_body
    @comment_object.search('.comment').map{|body| body.inner_text}.join
  end

end

#.comhead first child, inner text = username
# .comhead inner text = /\d* .* ago/
posts = Post.new('post.html')
p posts.item_id