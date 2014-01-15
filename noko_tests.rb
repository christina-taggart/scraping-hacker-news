require_relative 'noko_practice.rb'

describe Post do
  doc = Nokogiri::HTML(open("https://news.ycombinator.com/item?id=7064435"))

  before :each do
    @post = Post.new "https://news.ycombinator.com/item?id=7064435"
  end

  describe "#initialize" do
    it "defines the post url and Nokogiri object" do
      expect(@post.url).to eq("https://news.ycombinator.com/item?id=7064435")
    end

    it "calls get attributes" do
      expect(@post.points).to be > 0
      expect(@post.item_id).to eq(7064435)
      expect(@post.title).to eq('Nassim Taleb: We should retire the notion of standard deviation')
      expect(@post.comments).to be_instance_of(Array)
    end

    it "has a valid comment list" do
      # expect(@post.comments[42].username).to eq('truthteller')
      # expect(@post.comments[42].text).to eq("he's really lost the plot. :(")
      expect(@post.comments[0].username).to eq('bluecalm')
      expect(@post.comments[0].text.length).to eq(3098)
    end
  end
end

describe Comment do

  before :each do
    @comment = Comment.new("leishman", "this is a test comment")
  end

  describe "#initialize" do
    it "should define a username and text attribute" do
      expect(@comment.username).to eq("leishman")
      expect(@comment.text).to eq("this is a test comment")
    end
  end
end