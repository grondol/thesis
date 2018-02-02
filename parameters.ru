# This will create a XML with desired document parameters

require "rexml/document"
#include REXML  # so that we don't have to prefix everything with REXML::...

data = [["leftmargin", 0],
    ["rightmargin", 0],
    ["topmargin", 0],
    ["bottommargin", 0],
    ["headline_chapter_counting_from", 0],
    ["headline_chapter_text_size", 15],
    ["headline_chapter_font", "Helvetica"],
    ["headline_chapter_font_style", :bold],
    ["headline_chapter_upper_space", 20],
    ["headline_chapter_indent",1]
]

doc = REXML::Document.new
doc << REXML::XMLDecl.new
root = REXML::Element.new("data")
doc.elements << root
data.each do |value|
   new_element = REXML::Element.new(value[0]) 
   new_element.text = value[1]
   root.elements << new_element
end

File.open("config.xml", "w") do |file|
    doc.write(file, 2)
end