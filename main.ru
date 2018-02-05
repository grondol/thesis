require "prawn"
require "rexml/document"
Prawn::Font::AFM.hide_m17n_warning = true

def read_config #will read all document parametres from config.xml
  params = {}
  File.open($config_file, "r") do |file|
    doc = REXML::Document.new(file)
    doc.root.elements.each do |element|
      params[element.name.strip] = element.text.strip
    end
  end
  return params
end

# returns ordered array, first comes the format flag, second is the content
def read_source
  source = []
  File.open($source_file, "r") do |file|
    doc = REXML::Document.new(file)
    doc.root.elements.each do |element|
      source << [element.name.strip, element.text.strip]
    end
  end
  return source
end  
  

def set_params(params)
  $leftmargin = params["leftmargin"].to_i
  $rightmargin = params["rightmargin"].to_i
  $topmargin = params["topmargin"].to_i
  $bottommargin = params["bottommargin"].to_i
  $headline_chapter_counting_from = params["headline_chapter_counting_from"].to_i
  $headline_chapter_text_size = params["headline_chapter_text_size"].to_i
  $headline_chapter_font = params["headline_chapter_font"]
  $headline_chapter_font_style = :bold
  $headline_chapter_upper_space = params["headline_chapter_upper_space"].to_i
  $headline_chapter_indent = params["headline_chapter_indent"].to_i
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

# ************ main instructions *************

$config_file = "config.xml"
$source_file = "source.xml"
params = read_config
source = read_source
set_params(params)


Prawn::Document.generate("hello.pdf", :margin => [$topmargin,$rightmargin,$bottommargin,$leftmargin]) do
  source.each do |element|
    send(element[0], element[1]) #runs method in string element[0]
  end
end


