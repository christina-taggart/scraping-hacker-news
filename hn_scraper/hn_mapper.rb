require 'nokogiri'
require 'open-uri'

class Post
  attr_reader :title, :post_link, :url, :item_id, :comments
  attr_accessor :points
  def initialize(url = ARGV.join)
    @doc = Nokogiri::HTML(open(url))
    @title = get_title
    @url = url
    @item_id = get_item_id
    @points = get_points
    @comments = load_existing_comments
  end

  def get_title
    @doc.search('.title > a').inner_text
  end

  def get_points
    @doc.search('.subtext > span').inner_text[/\d+/]
  end

  def get_item_id
    @doc.search('.subtext > span').to_s.gsub!(/(.+_)(\d+).+/, '\2')
  end

  def load_existing_comments
    all_comments = @doc.search('.default').map{|comment| comment}
    loaded = []
    all_comments.each do |comment|
      loaded << Comment.new(comment)
    end
    loaded
  end

  def add_comment(comment)
    @comments << comment
  end

  def print_post_stats
    puts "Post title: #{title}"
    puts "#{comments.length} comments, #{points} points"
  end

  def print_comments
    @comments.each do |comment|
      puts "#{comment.username}, #{comment.created_at} | #{comment.permalink} \n #{comment.body}\n\n"
    end
  end

  def print
    print_post_stats
    print_comments
  end

end

class Comment
  attr_reader :username, :created_at, :permalink, :body #, :parent

  def initialize(comment)
    @comment_hash = comment.class == Hash ? comment : {}
    @comment_object = comment.class != Hash ? comment : nil
    @username = @comment_hash.fetch(:username) { get_username }
    @created_at = @comment_hash.fetch(:created_at){ get_created_at }
    @body = @comment_hash.fetch(:body){ get_body }
    @permalink = "https://news.ycombinator.com/?id=#{@comment_hash.fetch(:permalink) { get_permalink }}"
  end

  def get_username
    @comment_object.search('.comhead > a:first-child').inner_text
  end

  def get_created_at
    @comment_object.search('.comhead').inner_text.gsub!(/\A\S+ (\d+.+ago)\s+\| link/, '\1')
  end

  def get_permalink
    @comment_object.search('.comhead > a:nth-child(2)').to_s[/\d+/]
  end

  def get_body
    @comment_object.search('.comment').inner_text
  end
end


posts = Post.new
posts.print
local_posts = Post.new('post.html')
local_posts.print
