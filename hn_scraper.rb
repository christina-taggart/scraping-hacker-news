require 'nokogiri'

class Post
  attr_accessor  :url, :hn_post, :title, :item_id, :points

  def initialize(url)
    @url = url
    @hn_post = Nokogiri::HTML(File.open(@url))
    @title = @hn_post.search('.title > a:first-child').text
    @item_id = @hn_post.search('a+span').first['id'].gsub(/\D/, '')
    # @points = @hn_post.search()
    comments
  end

  def display_comments
    puts "Comments for this post:"
    @comments.each_with_index do |comment, idx| 
      puts "#{idx+1}>\t#{comment.text}\n"
    end
  end

  private
  def comments
    @comments = []
    @hn_post.search('.comment > font:first-child').map do |font|
      add_comment(Comment.new(font.text))
    end
  end

  def add_comment(comment_obj)
    @comments << comment_obj
  end
end

class Comment
  attr_accessor :text

  def initialize(comment_text)
    @text = comment_text
  end
end

# Driver Code
# hn_article_url = "https://news.ycombinator.com/item?id=6561358"
hn_article_url = "html/post.html"
hn_post = Post.new(hn_article_url)
puts "Post Title: #{hn_post.title}"
puts "Post Points: #{hn_post.points}"
puts "Item Id: #{hn_post.item_id}"
hn_post.display_comments

