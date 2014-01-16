require 'rubygems'
require 'nokogiri'
require 'open-uri'

class Post
	attr_reader :title, :url, :item_id, :points, :comments
	def initialize(url = ARGV.join)
		@doc = Nokogiri::HTML(open(url))
		@title = get_title
		@item_id = get_item_id
		@points = get_points
		@comments = grab_comments
	end
	def add_comment(comment)
		@comments << Comment.new(comment).comment
	end
	def get_title
		@doc.search('.title > a:first-child').inner_text
	end
	def get_item_id
		@doc.search('.subtext > a:nth-child(3)').map {|link| link['href'] }.join("")
	end
	def get_points
		@doc.search('.subtext > span:first-child').inner_text
	end

	private
	def grab_comments
		@comments = @doc.search('.comment > font:first-child').map { |font| font.inner_text}
	end
end

class Comment
	attr_reader :comment
	def initialize(comment)
		@comment = comment
	end
end

post = Post.new
p "Post title: #{post.title}"
p "Post id#: #{post.item_id}"
p "Page points: #{post.points}"