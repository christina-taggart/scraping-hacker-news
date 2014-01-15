require 'nokogiri'
require 'open-uri'

class Post
  attr_accessor  :url, :hn_post, :title, :item_id, :points

  def initialize(url=nil)
    @url = ARGV[0].nil? ? open(url) : open(ARGV[0])
    @hn_post = Nokogiri::HTML(File.open(@url))
    @title = @hn_post.search('.title > a:first-child').text
    @item_id = @hn_post.search('a+span').first['id'].gsub(/\D/, '')
    @points = @hn_post.search("#score_#{@item_id}").text
    @usernames = extract_usernames
    comments
  end

  def display_comments
    puts "Post Title: #{@title}\nPost Points: #{@points}"
    puts "Item Id: #{@item_id}\nComments for this post:\n\n"
    @comments.each_with_index do |comment, idx|
      lines = []
      lines << comment.text.slice!(0, 80) until comment.text.empty?
      puts "#{idx+1}> #{comment.username}:\t"
      lines.each { |line| puts line.gsub(/^ +/,'') }
      puts
    end
  end

  private
  def comments
    @comments = []
    @hn_post.search('.comment > font:first-child').map.with_index do |font, idx|
      add_comment(Comment.new(font.text, @usernames[idx]))
    end
  end

  def add_comment(comment_obj)
    @comments << comment_obj
  end

  def extract_usernames
    @hn_post.search('.comhead > a:first-child').map { |element| element.inner_text }
  end
end

class Comment
  attr_accessor :text, :username

  def initialize(comment_text, username)
    @text = comment_text
    @username = username
  end
end

# Driver Code
hn_article_url = "https://news.ycombinator.com/item?id=6561358"
hn_post = Post.new(hn_article_url)
hn_post.display_comments