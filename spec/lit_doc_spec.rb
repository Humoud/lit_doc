require "spec_helper"
require 'modules/scanner'
require 'modules/processor'
require 'active_support'
require 'active_support/core_ext'
require 'fileutils'
require 'byebug'

include Scanner
include Processor

RSpec.configure do |config|

  config.before(:all) do
    # create file in case it does not exist
    FileUtils.makedirs('spec/support/rails_app/doc/gen/')
    FileUtils.touch('spec/support/rails_app/doc/gen/generated.md')
    # clear out file in case it exists and has content
    File.truncate('spec/support/rails_app/doc/gen/generated.md', 0)
  end

  config.before(:each) do
    @original_working_dir = Dir.pwd
    Dir.chdir("spec/support/rails_app")
  end

  config.after(:each) do
    Dir.chdir(@original_working_dir)
    puts "working dir afer: #{Dir.pwd}"
  end
end

RSpec.describe LitDoc do
  it "has a version number" do
    expect(LitDoc::VERSION).not_to be nil
  end

  it "get files to import from source file" do
    file_paths, regular_markdown_lines = Scanner.read_source_file("doc/source/source.md")
    expect(file_paths.blank?).to eq(false)
    expect(regular_markdown_lines.blank?).to eq(false)

  end

  it "get lines with lit doc syntax" do
    file_paths, regular_markdown_lines = Scanner.read_source_file("doc/source/source.md")
    lines_with_docs = Scanner.scan_file(file_paths, Dir.pwd)
    expect(lines_with_docs.blank?).to eq(false)
  end

  it "process lines and generate doc" do
    file_paths, regular_markdown_lines = Scanner.read_source_file("doc/source/source.md")
    lines_with_docs = Scanner.scan_file(file_paths, Dir.pwd)

    Processor.process_regular_markdown_lines(regular_markdown_lines, "doc/gen/generated.md")
    Processor.process_lit_doc_lines(lines_with_docs, "doc/gen/generated.md")

    expect(File.zero?("doc/gen/generated.md")).to eq(false)
  end
end
