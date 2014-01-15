require 'nokogiri'
require 'open-uri'

class Post
  attr_reader :url, :page_object, :title, :points, :item_id, :comments

  def initialize(url)
    @url = url
    create_page_object
    get_attributes
  end

  private

    def create_page_object
      @page_object = Nokogiri::HTML(open(@url))
    end

    def get_attributes
      @title = get_title
      @points = get_points
      @item_id = get_post_id
      @comments = get_comments
    end

    def get_title
      @page_object.search('.title > a').text
    end

    def get_points
      points_text = @page_object.search('.subtext > span').text
      (/^\d*/).match(points_text)[0].to_i
    end

    def get_post_id
      /\d*$/.match(@url)[0].to_i
    end

    def get_comments
      @page_object.css('td.default').map do |row|
        create_comment_from_row(row)
      end
    end

    def create_comment_from_row(row)
      username = row.css('.comhead a')[0].text
      text = row.css('span')[1].text
      Comment.new(username, text)
    end
end

class Comment
  attr_reader :username, :text

  def initialize(username, text)
    @text = text
    @username = username
  end
end

########## RUN PROGRAM ##########

url = ARGV[0]
post = Post.new(url)


