require 'nokogiri'
require 'open-uri'



# hacker_news = Nokogiri::HTML(open("https://news.ycombinator.com/"))
post = Nokogiri::HTML(open(ARGV[0])) do |config|
  config
end

# post = Nokogiri::HTML(open(ARGV[0])) do |config|
#   config
# end

# post = Nokogiri::HTML(open("post.html")) do |config|
#   config
# end

# def extracting_something(doc)
  #doc.search('.subtext > span:first-child').map { |span| span.inner_text}
  # => This returns the subtext point value for the post.
  #doc.search('.subtext > a:nth-child(3)').map {|link| link['href'] }
  # => This returns the third child element of the class subtext.
  #doc.search('.title > a:first-child').map { |link| link.inner_text}
  # => This returns the actual text of 'A/B testing mistakes'
  #doc.search('.title > a:first-child').map { |link| link['href']}
  # => This returns the link to the website from 'A/B testing mistakes'
  #doc.search('.comment > font:first-child').map { |font| font.inner_text}
  # => This pulls all of the text for all comments.
  #doc.search('.comment > font > p > a:first-child').map { |link| link['href'] }
  #=> This pulls all of the links past the first paragraph within the comment section.
  #doc.search('font > a:first-child').map { |link| link['href'] }
  #=> This pulls out the first links within the comment section.
# end

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

  def number_of_comments
    @comment_list.length
  end

  def find_post_title(doc)
    @post_title = doc.search('.title > a:first-child').map { |link| link.inner_text}.join()
  end

  def add_comment(comment)
    @comment_list << comment.text
  end

  def display_comment(number_in_list)
    @comment_list[number_in_list]
  end

  def extract_usernames(doc)
    @user_names = doc.search('.comhead > a:first-child').map {|element| element.inner_text }.uniq!.join(" ")
  end

  def to_s
    puts "Post title: #{@post_title}\nNumber of comments: #{@comment_list.length}\nList of commentors: #{@user_names}"
  end

end

class Comment
  attr_reader :user, :date, :link, :text, :post
  def initialize(user, text)
    @user = user
    @date = Time.now
    @link = link
    @text = text
    @post = post
  end


end


new_post = Post.new

new_post.comments(post)

new_post.find_post_title(post)
new_post.extract_usernames(post)
new_post.to_s