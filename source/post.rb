require 'nokogiri'
require_relative 'comment.rb'
require 'open-uri'

class Post
	attr_reader :url, :points, :title, :item_id, :comments

	def initialize(url = nil)
		@url = url || ARGV[0]
		@document = url.nil? ? open(ARGV[0]) : Nokogiri::HTML(File.open(@url))
		@points = parse_points
		@title = parse_title
		@item_id = parse_item_id
		@comments = parse_comments
	end

	def parse_points
		# the element received returns a number followed by 'points' e.g. 50 points
		# i want to grab the first number that comes before the word point
		@document.search('.subtext > span:first-child')[0].inner_text.match(/(\d+) point/)[1]
	end

	def parse_title
		@document.search('.title > a:first-child')[0].inner_text
	end

	def parse_item_id
		# the search finds the item id in the format 'item?id=<number>' e.g. item?id=5003980
		# i want to grab the first number that comes after the pattern 'item?id'
		@document.search('.subtext > a:nth-child(3)')[0]['href'].match(/item\?id=(\d+)/)[1]
	end

	def parse_comments
		@comments = @document.search('.comment > font:first-child').map { |font| Comment.new(font.inner_text) }
	end

	def add_comment(text)
		@comments << Comment.new(text)
	end
end