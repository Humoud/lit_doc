# should be at root of rails app for this to work
require 'modules/scanner'
require 'modules/processor'
include Scanner
include Processor

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
    file_paths_and_header_sizes, regular_markdown_lines = Scanner.read_source_file("doc/source/source.md")
    puts "files to be imported: #{file_paths}"
    # get lines that contain lit doc code
    lines_and_header_sizes = Scanner.scan_file(file_paths_and_header_sizes)
    # process regular markdown lines
    Processor.process_regular_markdown_lines(regular_markdown_lines, @generated_file_path)
    # process lit doc lines
    Processor.process_lit_doc_lines(lines_and_header_sizes, @generated_file_path)
  end
end
