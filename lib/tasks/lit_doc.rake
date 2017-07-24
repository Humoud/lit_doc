# should be at root of rails app for this to work
require 'modules/scanner'
include Scanner

namespace :lit_doc do
  @generated_file_path = "doc/gen/generated.md"
  ##########################################################################
  ###       CREATE FILES AND FOLDERS DEPENDENCIES
  #
  directory "doc"
  directory "doc/gen" => "doc"
  directory "doc/source" => "doc"
  file "doc/source/source.md" => ["doc/source", "doc/gen"] do
    touch "doc/source/source.md"
  end
  file @generated_file_path => "doc/source/source.md" do
    touch @generated_file_path
  end

  task :prepare => ["doc/source/source.md", @generated_file_path]

  ##########################################################################
  ###  Lit Doc Rake Task
  #
  task :generate => :prepare do
    puts "Reading list of files to scan:"
    # get files that are imported
    file_paths_and_header_sizes = Scanner.read_source_file("doc/source/source.md")
    puts "files to be imported: #{file_paths}"
    # get lines that contain lit doc code
    lines_and_header_sizes = Scanner.scan_file(file_paths_and_header_sizes)
    # puts "lines that contain doc syntax: #{lines_with_docs}"
    # process lines
    process_lines(lines_and_header_sizes, @generated_file_path)
  end
end
