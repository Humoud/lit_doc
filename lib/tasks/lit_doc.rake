# should be at root of rails app for this to work
require 'modules/scanner'
include Scanner

namespace :lit_doc do

  directory "doc"
  directory "doc/gen" => "doc"
  directory "doc/source" => "doc"
  file "doc/source/source.md" => ["doc/source", "doc/gen"] do
    touch "doc/source/source.md"
  end

  task :prepare => "doc/source/source.md"

  task :generate => :prepare do
    puts "Reading list of files to scan:"
    # src_files = Dir.glob("*")
    # src_files = Dir.glob("app/controllers/*")
    # puts "#{src_files}"
    file_paths = Scanner.read_source_file("doc/source/source.md")
    puts "files to be imported: #{file_paths}"
    lines_with_docs = Scanner.scan_file(file_paths)
    puts "lines that contain doc syntax: #{lines_with_docs}"
  end
end
####################################################################
# end goal usage scenario:
# in source.md:
#
# have a mixture of markdown syntax and "@import 'rails.root/path_to_file'" statements
#
# in the imported file:
#
# above each action that the user wishes to document, he/she will use the following syntax
# it starts with 2 ## hashtags
## h: header text
## route: http method route
## body: dictionary
## body-model: path to model
## response: dictionary
## response-serializer: path to serializer
## response-model: path to model

# RegEx used to detect if this line is to be analyzed: /^\s*##.*/
