require_relative '../source/post.rb'

describe Post do
	
	let(:site_url) { "https://news.ycombinator.com/item?id=5003980" }
	let(:site_title) { "A/B testing mistakes" }

	describe "when I parse a web page" do
		let(:post) { Post.new }

		before do
			ARGV.clear
			ARGV << site_url
		end

		it "should have read the url from the ARGV" do
			expect(post.url).to eq site_url
		end

		it "should read the title of the page" do
			expect(post.title).to eq site_title
		end
	end
end