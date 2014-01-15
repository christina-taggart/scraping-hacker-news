# TODO: Instantiate a Post Object
# TODO: Parse HackerNews HTML
# TODO: Create a new Comment object for each comment in the HTML, adding it to
#       the post object.
class Post
  attr_reader :title, :url, :points, :item_id

  def initialize(url)
  end

  def comments(particular_post)
    # returns all comments associated with a particular post
  end

  def add_comment(comment_obj)
    # takes a comment object as its input
    # adds it to the comment list
  end
end

class Comment
end

Post.new("https://news.ycombinator.com/item?id=6561358")

