require 'nokogiri'
require 'open-uri'

#$doc = Nokogiri::HTML(open('post.html'))

class Post
  attr_reader :title, :url, :points, :item_id

  def initialize(post_doc)
    @title =  post_doc.search('.title > a:first-child').map { |link| link.inner_text}.pop
    @url = post_doc.search('.title > a:first-child').map { |link| link['href']}.pop
    @points = post_doc.search('.subtext > span:first-child').map { |span| span.inner_text}.pop
    @points = @points.match(/\d+/).to_s.to_i
    @item_id = post_doc.search('.subtext > a:nth-child(3)').map { |link| link['href']}.pop
    @item_id = @item_id.match(/\d+/).to_s.to_i
    @all_comments = post_doc.search('.comment')
    @all_comheads = post_doc.search('.comhead')
    @comments = Array.new
    create_comments
  end

  def create_comments
    counter = 0
    until counter >= @all_comments.length
      @comments << Comment.new(@all_comments[counter], @all_comheads[counter + 1])
      counter += 1
    end
  end

  def comments
    @comments.each { |comment| comment.print }
  end

  def statistics
    puts "---"
    puts "POST ID: #{@item_id}"
    puts "THIS POST HAS #{@comments.length} COMMENTS."
    puts "THIS POST HAS #{@points} POINTS."
  end

  def add_comment(comment)
    @comments << comment
  end
end


class Comment
  attr_reader :user, :text, :item_id

  def initialize(nokogiri_comment, nokogiri_comhead)
    @user = nokogiri_comhead.search('a:first-child').inner_text
    @text = nokogiri_comment.inner_text
    @item_id = nokogiri_comhead.search('a:nth-child(2)')[0].attributes['href'].value
    @item_id = @item_id.match(/\d+/).to_s.to_i
  end

  def print
    puts "user: #{@user}   item_id: #{@item_id}"
    puts "---"
    puts "#{@text}"
    puts
  end
end

#-----DRIVERS-----
# our_post = Post.new($doc)
# p our_post.title
# p our_post.url
# p our_post.points
# p our_post.item_id
# test_nokogiri_comhead = $doc.search('.comhead')[1]
# test_nokogiri_comment = $doc.search('.comment')[0]
# test_comment = Comment.new(test_nokogiri_comment, test_nokogiri_comhead)
# p test_comment.user
# p test_comment.text
# p test_comment.item_id
# p our_post.all_comments[0]
# our_post.comments

#-----ARGVifying our scraper-----
link = ARGV[0]
hn_page = Nokogiri::HTML(open(link))
current_post = Post.new(hn_page)
current_post.comments
current_post.statistics