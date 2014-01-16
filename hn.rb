require 'rubygems'
require 'nokogiri'
require 'open-uri'


class Post

  def initialize(title, url, points, id, doc)
    @title = title
    @url = url
    @points = points
    @id = id
    @doc = doc

    @comment_usernames = get_user_names
    @comment_links = get_comment_links
    @comment_dates = get_comment_dates
    @comment_dates.shift
    @comment_texts = get_comment_texts

    @all_comments = []
    create_comment_array
    @formatted = @all_comments.transpose
    format_comments(@formatted)
  end

  def get_user_names
    @doc.search('.comhead > a:nth-child(1)').map do |element|
      element.inner_text
    end
  end

  def get_comment_links
    @doc.search('.comhead > a:nth-child(2)').map do |element|
      element['href']
    end
  end

  def get_comment_dates
    @doc.search('.comhead').map do |element|
      element.inner_text.gsub(/\D/, "")
    end
  end

  def get_comment_texts
    @doc.search('.comment').map do |element|
      element.inner_text
    end
  end

  def create_comment_array
    @all_comments << @comment_usernames
    @all_comments << @comment_dates
    @all_comments << @comment_texts
    @all_comments << @comment_links
    @all_comments
  end

  def format_comments(final_list_of_comments)
    comments_to_display = final_list_of_comments.to_a
    comments_to_display.each do |comment|
      puts "#{comment[1]} days ago, #{comment[0]} said the following: #{comment[2]}"
      puts "The comment can be found at https://news.ycombinator.com/#{comment[3]}"
      puts "-----------"
    end
  end

  def display
    format_comments(@formatted)
  end

  def add_comment(comment)
    @formatted << [comment.user, comment.date, comment.comment_text, comment.link]
  end

end


class Comment

  attr_reader :user, :date, :comment_text, :link

  def initialize (user, date, comment_text, link )
    @user = user
    @date = date
    @comment_text = comment_text
    @link = link
  end

end


#----------------------------------------------------------------------------------------------------------------------------------------------------------

#url = "https://news.ycombinator.com/item?id=5003980"
#url = "hn_scraper/post.html"
url = ARGV[0]
/(?<first_part_url>.*)(?<seperator>(id=))(?<url_id>.*)/ =~ url



#doc = Nokogiri::HTML(open(url))
doc = Nokogiri::HTML(File.open(url))

title = doc.css("title")[0].text
points = doc.css("#score_5003980")[0].text
id = url_id

hn_post = Post.new(title, url, points, id, doc)
hn_post.add_comment(Comment.new("adityam", 200, "ab testing is awesome", "https://news.ycombinator.com/item?id=1234567"))
hn_post.display





# p extract_usernames(doc)
# "----"
# p doc.search('.subtext > span:first-child').map { |span| span.inner_text}
# p "----"
# p doc.search('.subtext > a:nth-child(3)').map {|link| link['href'] }
# p "----"
# p doc.search('.title > a:first-child').map { |link| link.inner_text}
# p "----"
# p doc.search('.title > a:first-child').map { |link| link['href']}
# p "----"
# p doc.search('.comment > font:first-child').map { |font| font.inner_text}










# PAGE_URL = "http://ruby.bastardsbook.com/files/hello-webpage.html"
# page = Nokogiri::HTML(open(PAGE_URL))

# # puts page.css("title")[0].name   # => title
# # puts page.css("title")[0].text   # => My webpage

# # links = page.css("a")
# # puts links.length   # => 6
# # puts links[0].text   # => Click here
# # puts links[0]["href"] # => http://www.google.com

# news_links = page.css("a[data-category=news]")
# news_links.each{|link| puts link['href']}
# #=>   http://reddit.com
# #=>   http://www.nytimes.com

# puts news_links.class   #=>   Nokogiri::XML::NodeSet