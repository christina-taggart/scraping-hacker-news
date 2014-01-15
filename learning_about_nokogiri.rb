# Playing around with Nokogiri and trying to understand how it works
# Note: Nokogiri documentation sucks to read!
require 'nokogiri'
doc = Nokogiri::HTML(File.open('html/post.html'))

def extract_usernames(doc)
  doc.search('.comhead > a:first-child').map do |element|
    p element.inner_text
  end
end

extract_usernames(doc)

# . is css class notation
# select elements from css class subtext
# where the immediate children are span elements
# and only select the first child of the parent (span) element
# This should return the points values of the post
doc.search('.subtext > span:first-child').map { |span| p span.inner_text}

# select elements belonging to the css class subtext
# only select the immediate children of subtext which are an <a> element
# only select any element that is the 3rd child of its parent (subtext)
# 3rd element just so happens to be <a> element, so this will return
# the comments link
# link['href'] means look in the Nokogiri object that was returned
# and return the value of that matching name inside the object.

doc.search('.subtext > a:nth-child(3)').map {|link| p link['href'] }

# select elements belonging to css class title
# only select the immediate children of .title which are <a>
# only select an <a> which is the first child of its parent (.title)
# this should return the link to the article being talked about in comments
# inner text will return the text of this Nokogiri node, in this case the title
doc.search('.title > a:first-child').map { |link| p link.inner_text}

# select elements belonging to css title class
# only select the immediate children of the title class
# only select the <a> element which is the first child of it's parent tag
# once we have a Nokogiri object, select the 'href' property, return the value
# I should get a link to the main article being discussed.
doc.search('.title > a:first-child').map { |link| p link['href']}


# select elements belonging to css class="comment"
# only select the immediate children belonging to css class="comment"
# select the <font> tag which is the first child of its parent element.
# This should return the comments for this article.
# inner text basically gives us the Nokogiri 'node's' text
doc.search('.comment > font:first-child').map { |font| p font.text}

# To pull the first (top) comment out:
p doc.search('.comment > font:first-child').text