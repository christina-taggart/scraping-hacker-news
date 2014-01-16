require_relative "../source/comment.rb"
require_relative "../source/post.rb"

describe Post do

	let(:local_page) { "post.html"}
	let(:post) { Post.new(local_page) } 

	describe "when I load a post from hacker news" do 
		let(:page_title) { "A/B testing mistakes" }
		let(:page_points) { "50" }
		let(:item_id) { "5003980" }

		it "should have a title" do
			expect(post.title).to eq page_title
		end

		it "should have a url" do
			expect(post.url).to eq local_page
		end

		it "should have points" do
			expect(post.points).to eq page_points
		end

		it "should have an item id" do
			expect(post.item_id).to eq item_id
		end

		describe "when I load the comments from hacker news" do
			let(:comments_count) { 18 }

			it "should load all the comments on the page" do
				expect(post.comments.length).to eq comments_count
			end

			describe "when I load the first comment from pages loaded" do
				let(:first_comment) { "I recently implemented A/B testing on a client's "\
																"site using one of these Javascript-based A/B "\
																"testing tools (but not this one).I hadn't used "\
																"one before, so wanted to verify the data would "\
																"actually be accurate.I did an A/A test, basically "\
																"testing the same exact pageâ\u0080\u0093â\u0080\u0093"\
																"expecting the results would be the same.Not only "\
																"were the results not the same, but they were off "\
																"by a wide margin.Given this, I don't know how I'm "\
																"supposed to trust any of the data.Has anyone else "\
																"had experiences like this? Is A/B testing in Javascript"\
																" just not as reliable?" }

				it "should load the entire comment text" do
					expect(post.comments.first.text).to eq first_comment
				end
			end

			describe "when I load the last comment from pages loaded" do
				let(:last_comment) { "8) Have a hypothesis of what you're testing and "\
															"control for variables. Run a MVT test if you're "\
															"changing a lot of things. If the test wins and "\
															"it's implemented, everyone is happy and people "\
															"don't ask too many questions. If it loses, what "\
															"have you learned? Test a hypothesis.If a client "\
															"looks at a comp for a test and asks to change "\
															"something, I always ask them, \"What hypothesis "\
															"are we testing with that change?\"" }

				it "should load the entire comment text" do
					expect(post.comments.last.text).to eq last_comment
				end
			end
		end

		describe "when I add a comment" do
			let(:new_text) { "this is a new comment yo. AB testing rocks!" }
			let(:new_comment) { Comment.new(new_text) }

			before do
				post.add_comment(new_comment)
			end

			it "should load the new comment as the last comment" do
				expect(post.comments.last.text).to eq new_comment
			end
		end
	end
end