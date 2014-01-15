require 'nokogiri'
require 'open-uri'

class Post
	def initialize(url)
		@page = Nokogiri::HTML(open(url))
		@comments = []
	end

	def get_info
		get_title
		get_comments
	end

	def get_title
		@post_title = @page.css('td.title a').text
	end

	def get_comments 
		@page.css('span.comment').each { |comment| @comments << Comment.new(comment.text)}
	end

	def display_info
		puts "#{@post_title} \n Number of Comments: #{@comments.length}"
	end
end

class Comment
	def initialize(words)
		@words = words
	end
end

url = 'hn.html'

hacker_news = Post.new(url)
hacker_news.get_info
hacker_news.display_info




