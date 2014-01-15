require 'rubygems'
require 'nokogiri'

$doc = Nokogiri::HTML(File.open('post.html'))

class Post
	attr_reader :title, :url, :item_id, :points, :comments
	def initialize
		@title = get_title
		@url = "https://news.ycombinator.com/item?id=5003980"
		@item_id = get_item_id
		@points = get_points
		@comments = grab_comments
	end
	def add_comment(comment)
		@comments << Comment.new(comment).comment
	end
	def get_title
		$doc.search('.title > a:first-child').map { |link| link.inner_text}.join("")
	end
	def get_item_id
		$doc.search('.subtext > a:nth-child(3)').map {|link| link['href'] }.join("")
	end
	def get_points
		$doc.search('.subtext > span:first-child').map { |span| span.inner_text}.join("")
	end

	private
	def grab_comments
		@comments = ($doc.search('.comment > font:first-child').map { |font| font.inner_text})
	end
end

class Comment
	attr_reader :comment
	def initialize(comment)
		@comment = comment
	end
end

post = Post.new
p post.title
p post.url
p post.item_id
p post.points
post.add_comment("****************************")
p post.comments #== "I thought that was a really interesting point"