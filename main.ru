require "prawn"
require "rexml/document"
Prawn::Font::AFM.hide_m17n_warning = true

# **************************************
# here I set parameters for the target document

$leftmargin = 0
$rightmargin = 0
$topmargin = 0
$bottommargin = 0

$headline_chapter_counting_from = 0
$headline_chapter_text_size = 15
$headline_chapter_font = "Helvetica"
$headline_chapter_font_style = :bold
$headline_chapter_upper_space = 20
$headline_chapter_indent = 1

# **************************************

$config_file = "config.xml"
params = {}

def read_config #will read all document parametres from config.xml
  File.open($config_file, "r") do |file|
    doc = REXML::Document.new(file)
    doc.root.elements.each do |element|
      params[element.name.strip] = element.text.strip
    end
  end
end

#takes in a hash with styling and a text string
def print_out(style, input)
  move_down style[:upper_space]
  font style[:font_variable], :style => $headline_chapter_font_style
  font_size style[:font_size_variable]
  text input
end

# method headline_chapter takes a string creates a formatted headline of a chapter
def headline_chapter(input)
  $headline_chapter_counting_from += 1
  style = {:upper_space => $headline_chapter_upper_space,
  :font_variable => $headline_chapter_font,
  :font_size_variable => $headline_chapter_text_size,
  :font_style => $headline_chapter_font_style
  }
  indent = "\xC2\xA0" * $headline_chapter_indent
  print_out(style, "#{indent}#{$headline_chapter_counting_from}. #{input}".rjust(10))
end

# creates a bulletpoint with a sign in front (no number)
def bulletpoint(input)
  
end

Prawn::Document.generate("hello.pdf", :margin => [$topmargin,$rightmargin,$bottommargin,$leftmargin]) do
  text "Hello World!,Hello World!,Hello World!,Hello World!,Hello World!,Hello World!,Hello World!,Hello World!,Hello World!,Hello World!,Hello World!,Hello World!,Hello World!,"
=begin  
  ["Courier", "Helvetica", "Times-Roman"].each do |example_font|
    move_down 20
    [:bold, :bold_italic, :italic, :normal].each do |style|
      font example_font, :style => style
      text "I'm writing in #{example_font} (#{style})"
    end
  end
=end
  headline_chapter("This is a chapter headline") 
  headline_chapter("Second chapter") 
  p params
end