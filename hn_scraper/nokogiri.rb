require 'rubygems'
require 'nokogiri'

$doc = Nokogiri::HTML(File.open('post.html'))

class Post
	attr_reader :title, :url, :item_id, :points
	def initialize
		@title = $doc.search('.title > a:first-child').map { |link| link.inner_text}
		@url = "https://news.ycombinator.com/item?id=5003980"
		@item_id = $doc.search('.subtext > a:nth-child(3)').map {|link| link['href'] }
		@points = $doc.search('.subtext > span:first-child').map { |span| span.inner_text}.join("")
	end
end

class Comment
	def initialize(comment)
	end
end

post = Post.new
p post.title
p post.points