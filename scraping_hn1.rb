require 'nokogiri'
require 'open-uri'
class Post
  attr_reader :title, :url, :points, :item_id, :poster_id, :comments

  def initialize(doc)
    @doc = doc
    create_page_object
    get_attributes
  end

  def create_page_object
    @page_object = Nokogiri::HTML(File.open(@doc))
  end

  def get_attributes
    @title = get_title
    @points = get_points
    @item_id = get_item_id
    @comments = get_comments
    @url = get_comments
  end

  def get_title
    @page_object.search('.title > a:first-child').map { |link| link.inner_text}[0]
  end

  def get_points
    @points = @page_object.search('.subtext > span:first-child').map { |span| span.inner_text}[0]
  end

  def get_url
    @url = 'https://news.ycombinator.com/' + @item_id
  end

  def get_poster_names
    @poster_names = @page_object.search('.comhead > a:first-child').map {|link| link.inner_text}
  end

  def get_comments
   @comments = @page_object.search('.comment > font:first-child')
  end

  def comments
   @page_object.css('td.default').map do |row|
    add_comment(row)
  end
  end

  def get_item_id
    @item_id = @page_object.search('.subtext > a:nth-child(3)').map {|link| link['href'] }[0]
  end


  def add_comment(row)
    username = row.css('comhead > a')[0].text
    text = row.css('span')[1].text
    Comment.new(username, text)
  end
end

class Comment
  attr_reader :username, :text
  def initialize(username, text)
    @username = username
    @text = text
  end
end

test = Post.new('post.html')
test






# def extract_usernames
#   doc = Nokogiri::HTML(File.open('post.html'))
#   doc.search('.comhead > a:first-child').map do |element|
#     element.inner_text
#   end
#   doc.search('.subtext > span:first-child').map { |span| span.inner_text} #=> 50 points
#   doc.search('.subtext > a:nth-child(3)').map {|link| link['href'] } #=>item?id=5003980
#   doc.search('.title > a:first-child').map { |link| link.inner_text} #=> A/B testing mistakes
#   doc.search('.title > a:first-child').map { |link| link['href']} #=>"http://visualwebsiteoptimizer.com/split-testing-blog/seven-ab-testing-mistakes-to-stop-in-2013/"
#   p doc.search('.comment > font:first-child').map { |font| font.inner_text} #=> Comment section text, all of it
#   p doc.search('.comhead > a:first-child').map {|link| link.inner_text} #=> "Jasber", "jfarmer", "btilly", "jfarmer", "robrenaud", "jfarmer", "noelwelsh", "siddharthdeswal", "Angostura", "siddharthdeswal", "chc", "jfarmer", "mjw", "jfarmer", "friendofasquid", "marcosdumay", "orangethirty", "karolisd", names of commenters
# end