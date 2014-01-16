require 'nokogiri'
require 'open-uri'

#doc = Nokogiri::HTML(File.open('post.html'))


class Post
  attr_reader :title, :url, :points, :item_id, :doc, :user_id, :posts
  def initialize(url = ARGV.join)
    @doc = Nokogiri::HTML(File.open(url))
    @title = title
    @url = url
    @points = points
    @item_id = item_id
    @user_id = user_id
    @posts = posts

  end

  def get_title
    title = @doc.search('.title > a:first-child').map { |link| link.inner_text}
    # @doc.css("title").text
    puts "Post title: #{title}"
  end

  def get_points
     points = @doc.search('.subtext > span:first-child').map { |span| span.inner_text}
    puts "This post has #{points}."
  end

  def get_url
    url = @doc.search('.title > a:first-child').map { |link| link['href']}
  end

  def get_user_id
    user_id = @doc.search('.comhead > a:first-child').map { |font| font.inner_text}
  end

  def get_item_id
    item_id = @doc.search('.subtext > a:nth-child(3)').map {|link| link['href'] }
  end

  def show_comments
    posts = @doc.search('.comment > font:first-child').map { |font| font.inner_text}
    puts posts
  end

  def add_comments
    @posts << Comment.new
  end

  # def create_hash
  #   comments_arr = @doc.search('.comment > font:first-child').map { |font| font.inner_text}
  #   n = @user_id.zip(@comments_arr)
  #   p users_comments = Hash[n]

end


class Comment
  attr_accessor :user_id, :message
  def initialize(user_id, comment)
    @user_id = user_id
    @message = message
  end

  def user_id?
    user_id
  end

  def message?
    message
  end

end





post = Post.new('post.html')
# newclass = Comment.new("nc", "hi there")
p post.get_title
p post.get_points
# p post.show_comments
# # post.show_comments
# p newclass.user_id?

# un = doc.search('.comhead > a:first-child').map { |font| font.inner_text}
# p un[0]

# title = doc.css("title").text
# puts "Post title: #{title}"

# number_comments = doc.search('.comment > font:first-child').length
# puts "Number of comments: #{number_comments}"

# p doc.search('.subtext > span:first-child').map { |span| span.inner_text} #points

# p doc.search('.subtext > a:nth-child(3)').map {|link| link['href'] } # item id

# p doc.search('.title > a:first-child').map { |link| link.inner_text} #title

# p doc.search('.title > a:first-child').map { |link| link['href']} # link

# p doc.search('.comhead > a:first-child').map { |font| font.inner_text} # usernames


# user_id = doc.search('.comhead > a:first-child').map { |font| font.inner_text}
# comments_arr = doc.search('.comment > font:first-child').map { |font| font.inner_text}
# new = user_id.zip(comments_arr)
# newer = Hash[new]
# p newer
