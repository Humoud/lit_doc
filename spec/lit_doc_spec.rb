require "spec_helper"
require 'modules/scanner'
require 'active_support'
require 'active_support/core_ext'
include Scanner

RSpec.configure do |config|
  # config.before(:each) do
  #   puts "before each"
  # end
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
    file_paths = Scanner.read_source_file("doc/source/source.md")
    expect(file_paths.blank?).to eq(false)
  end

  it "get lines with lit doc syntax" do
    file_paths = Scanner.read_source_file("doc/source/source.md")
    lines_with_docs = Scanner.scan_file(file_paths, Dir.pwd)
    expect(lines_with_docs.blank?).to eq(false)
  end

end

# file_paths = Scanner.read_source_file("doc/source/source.md")
# # get lines that contain lit doc code
# lines_with_docs = Scanner.scan_file(file_paths)
# # process lines
# @generated_file_path = "doc/gen/generated.md"
# process_lines(lines_with_docs, @generated_file_path)
